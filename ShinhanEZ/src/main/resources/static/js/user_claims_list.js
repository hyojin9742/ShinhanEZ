document.addEventListener("DOMContentLoaded", () => {
  loadClaims();
});

async function loadClaims() {
  const tbody = document.getElementById("claimsTbody");
  const empty = document.getElementById("claimsEmpty");
  const table = document.getElementById("claimsTable");

  try {
    const res = await fetch("/user/claims/api/list", {
      method: "GET",
      headers: { "Accept": "application/json" }
    });

    if (res.status === 401) {
      // 로그인 필요
      table.style.display = "none";
      empty.style.display = "block";
      empty.querySelector("p").textContent = "로그인이 필요합니다.";
      return;
    }

    if (!res.ok) {
      throw new Error(`HTTP ${res.status}`);
    }

    const list = await res.json();

    // 초기화
    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      updateClaimSummaryCounts([]);
      return;
    }

    // 표시
    table.style.display = "";
    empty.style.display = "none";

    // 요약카드 업데이트
    updateClaimSummaryCounts(list);

    // 테이블 채우기
    const rowsHtml = list.map(c => {
      const statusText = toKoreanStatus(c.status);
      const statusClass = toStatusClass(c.status); // CSS 재활용
      const accidentDate = c.accidentDate ?? "-";
      const claimDate = c.claimDate ?? "-";
      const amount = formatNumber(c.claimAmount) + "원";
      const adminName = c.adminName ?? "-";

      return `
        <tr>
          <td>${escapeHtml(c.claimId)}</td>
          <td>
            <span class="status-badge ${statusClass}">
              ${escapeHtml(statusText)}
            </span>
          </td>
          <td>${escapeHtml(c.customerName ?? "-")}</td>
          <td>${escapeHtml(c.insuredName ?? "-")}</td>
          <td>${escapeHtml(accidentDate)}</td>
          <td>${escapeHtml(claimDate)}</td>
          <td class="amount">${escapeHtml(amount)}</td>
          <td>${escapeHtml(adminName)}</td>
        </tr>
      `;
    }).join("");

    tbody.innerHTML = rowsHtml;

  } catch (e) {
    console.error(e);
    table.style.display = "none";
    empty.style.display = "block";
    empty.querySelector("p").textContent = "청구 목록을 불러오지 못했습니다.";
  }
}

// ----- helpers -----

function getCtx() {
  const path = location.pathname;
  const idx = path.indexOf("/", 1);
  return idx > 0 ? path.substring(0, idx) : "";
}

function toKoreanStatus(status) {
  switch (status) {
    case "PENDING": return "대기";
    case "REJECTED": return "반려";
    case "COMPLETED": return "승인";
    default: return status ?? "-";
  }
}

function toStatusClass(status) {

  switch (status) {
    case "PENDING": return "status-PENDING";
    case "REJECTED": return "status-OVERDUE"; // 반려를 overdue 스타일(빨강)로 재사용
    case "COMPLETED": return "status-PAID";   // 승인를 paid 스타일(초록)로 재사용
    default: return "";
  }
}

function updateClaimSummaryCounts(list) {
  const pending = list.filter(x => x.status === "PENDING").length;
  const rejected = list.filter(x => x.status === "REJECTED").length;
  const completed = list.filter(x => x.status === "COMPLETED").length;

  const pEl = document.getElementById("claimPendingCount");
  const rEl = document.getElementById("claimRejectedCount");
  const cEl = document.getElementById("claimCompletedCount");

  if (pEl) pEl.textContent = `${pending}건`;
  if (rEl) rEl.textContent = `${rejected}건`;
  if (cEl) cEl.textContent = `${completed}건`;
}

function formatNumber(v) {
  if (v === null || v === undefined || v === "") return "0";
  const n = Number(v);
  if (Number.isNaN(n)) return String(v);
  return n.toLocaleString("ko-KR");
}

function escapeHtml(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}
