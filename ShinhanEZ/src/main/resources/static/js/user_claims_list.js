document.addEventListener("DOMContentLoaded", () => {
  loadClaims();
});


/** ====== Claims List ====== */
async function loadClaims() {
  const tbody = document.getElementById("claimsTbody");
  const empty = document.getElementById("claimsEmpty");
  const table = document.getElementById("claimsTable");

  try {
    const res = await fetch(`/user/claims/api/list`, {
      method: "GET",
      headers: { "Accept": "application/json" }
    });

    if (res.status === 401) {
      table.style.display = "none";
      empty.style.display = "block";
      empty.querySelector("p").textContent = "로그인이 필요합니다.";
      return;
    }

    if (!res.ok) throw new Error(`HTTP ${res.status}`);

    const list = await res.json();
    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      updateClaimSummaryCounts([]);
      return;
    }

    table.style.display = "";
    empty.style.display = "none";
    updateClaimSummaryCounts(list);

    const rowsHtml = list.map(c => {
      const claimId = c.claimId;
      const statusText = toKoreanStatus(c.status);
      const statusClass = toStatusClass(c.status);

      const accidentDate = c.accidentDate ?? "-";
      const claimDate = c.claimDate ?? "-";
      const amount = formatNumber(c.claimAmount) + "원";
      const adminName = c.adminName ?? "-";

      const uploadDisabled = (c.status === "COMPLETED");
      const docsBtnText = uploadDisabled ? "서류확인" : "서류관리";

      return `
        <tr>
          <td>${escapeHtml(claimId)}</td>
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
          <td>
            <button
              type="button"
              class="btn-doc js-docs-btn"
              data-claim-id="${String(claimId)}"
              data-upload-disabled="${uploadDisabled ? "Y" : "N"}"
            >${docsBtnText}</button>
          </td>
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

/** ====== Modal State ====== */
let currentClaimId = null;
let currentUploadDisabled = false;

/** ====== Open Modal from Table ====== */
document.addEventListener("click", async (e) => {
  const btn = e.target.closest(".js-docs-btn");
  if (!btn) return;

  currentClaimId = btn.dataset.claimId;
  currentUploadDisabled = (btn.dataset.uploadDisabled === "Y");

  openFilesModalUI(currentClaimId, currentUploadDisabled);
  await loadFilesList(currentClaimId);
});

/** ====== Modal Open/Close ====== */
function openFilesModalUI(claimId, uploadDisabled) {
  const backdrop = document.getElementById("filesModalBackdrop");
  const modal = document.getElementById("filesModal");

  backdrop.style.display = "block";
  modal.style.display = "block";

  document.getElementById("filesModalSub").textContent = `청구ID: ${claimId}`;
  document.getElementById("filesUploadStatus").textContent = "";
  document.getElementById("filesUploadHint").textContent = "pdf/jpg/png 권장, 여러 개 선택 가능";

  const input = document.getElementById("filesModalInput");
  input.value = "";
  input.accept = ".pdf,.jpg,.jpeg,.png";

  // 승인 상태면 업로드 막기(정책)
  document.getElementById("btnUploadFiles").disabled = uploadDisabled;
  input.disabled = uploadDisabled;

  if (uploadDisabled) {
    document.getElementById("filesUploadHint").textContent = "승인된 청구는 서류 추가 첨부가 제한됩니다.";
  }
}

function closeFilesModalUI() {
  document.getElementById("filesModalBackdrop").style.display = "none";
  document.getElementById("filesModal").style.display = "none";
  currentClaimId = null;
  currentUploadDisabled = false;
}

document.addEventListener("click", (e) => {
  if (e.target.id === "filesModalBackdrop" || e.target.id === "btnCloseFilesModal") {
    closeFilesModalUI();
  }
});

/** ====== Load Files List ====== */
async function loadFilesList(claimId) {
  const body = document.getElementById("filesModalBody");
  body.innerHTML = "불러오는 중...";

  try {
    const res = await fetch(`/user/claims/${encodeURIComponent(claimId)}/files`, {
      headers: { "Accept": "application/json" }
    });
	
	if (!res.ok) {
	      const msg = await safeReadText(res);
	      console.error("files api error:", res.status, msg);
	      throw new Error(msg || `HTTP ${res.status}`);
	    }

    const files = await res.json();

    if (!files || files.length === 0) {
      body.innerHTML = `<p style="color:#666; margin:0;">첨부된 파일이 없습니다.</p>`;
      return;
    }

    body.innerHTML = `
      <ul style="list-style:none; padding:0; margin:0; display:flex; flex-direction:column; gap:10px;">
        ${files.map(f => `
          <li style="display:flex; justify-content:space-between; align-items:center; gap:10px; border:1px solid #eee; padding:10px; border-radius:10px;">
            <div style="min-width:0;">
              <div style="font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                ${escapeHtml(f.originalName)}
              </div>
              <div style="font-size:12px; color:#777;">
                ${formatBytes(f.fileSize)} · ${escapeHtml(f.createdAt ?? "")}
              </div>
            </div>
			<span style="font-size:12px; color:#6c757d; white-space:nowrap;">
			              등록됨
            </span>
          </li>
        `).join("")}
      </ul>
    `;
  } catch (err) {
    console.error(err);
    body.innerHTML = `<p style="color:#b02a37; margin:0;">파일 목록을 불러오지 못했습니다.</p>`;
  }
}

document.getElementById("btnRefreshFiles")?.addEventListener("click", async () => {
  if (!currentClaimId) return;
  await loadFilesList(currentClaimId);
});

/** ====== Upload from Modal ====== */
document.getElementById("btnUploadFiles")?.addEventListener("click", async () => {
  if (!currentClaimId) return;

  const input = document.getElementById("filesModalInput");
  const statusEl = document.getElementById("filesUploadStatus");
  const files = input.files;

  if (!files || files.length === 0) {
    statusEl.innerHTML = `<span style="color:#666;">업로드할 파일을 선택해 주세요.</span>`;
    return;
  }

  // 프론트 확장자 1차 체크
  const allowExt = ["pdf", "jpg", "jpeg", "png"];
  for (const f of files) {
    const ext = (f.name.split(".").pop() || "").toLowerCase();
    if (!allowExt.includes(ext)) {
      statusEl.innerHTML = `<span style="color:#b02a37;">허용되지 않는 파일 형식: ${escapeHtml(f.name)}</span>`;
      return;
    }
  }

  const btn = document.getElementById("btnUploadFiles");
  btn.disabled = true;
  statusEl.innerHTML = `<span style="color:#666;">업로드 중...</span>`;

  try {
    const form = new FormData();
    for (const f of files) form.append("files", f);

    const res = await fetch(`/user/claims/${encodeURIComponent(currentClaimId)}/files`, {
      method: "POST",
      body: form
    });

    if (res.status === 401) {
      statusEl.innerHTML = `<span style="color:#b02a37;">로그인이 필요합니다.</span>`;
      return;
    }

    if (!res.ok) {
      const msg = await safeReadText(res);
      throw new Error(msg || `HTTP ${res.status}`);
    }

    statusEl.innerHTML = `<span style="color:#0f5132; font-weight:600;">업로드 완료!</span>`;
    input.value = "";

    await loadFilesList(currentClaimId);

    // 메인 목록도 최신화(첨부 개수 표시 등을 하게 되면 필요)
    // await loadClaims();

  } catch (err) {
    console.error(err);
    statusEl.innerHTML = `<span style="color:#b02a37;">업로드 실패: 파일 형식/용량을 확인해 주세요.</span>`;
  } finally {
    btn.disabled = currentUploadDisabled; // 승인 상태면 다시 잠금 유지
  }
});

/** ====== Helpers ====== */
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
    case "REJECTED": return "status-OVERDUE";
    case "COMPLETED": return "status-PAID";
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

function formatBytes(bytes) {
  if (bytes === null || bytes === undefined) return "";
  const b = Number(bytes);
  if (!Number.isFinite(b)) return String(bytes);
  const units = ["B", "KB", "MB", "GB"];
  let i = 0, n = b;
  while (n >= 1024 && i < units.length - 1) { n /= 1024; i++; }
  return `${n.toFixed(i === 0 ? 0 : 1)}${units[i]}`;
}

async function safeReadText(res) {
  try { return await res.text(); } catch { return ""; }
}
