/**
 * [User Claims - MyPage 청구 목록 + 서류 모달]
 * - 목록 API: GET  /user/claims/api/list
 * - 파일 목록: GET  /user/claims/{claimId}/files
 * - 파일 업로드: POST /user/claims/{claimId}/files (multipart)
 *
 * 정책:
 * - COMPLETED/REJECTED 상태인 청구는 서류 추가 업로드 금지(읽기 전용)
 * - 목록/파일 렌더링은 XSS 방지를 위해 escapeHtml 사용
 *
 * 참고:
 * - fetch 경로는 현재 절대경로(/user/...) 기준.
 */

document.addEventListener("DOMContentLoaded", () => {
    // 페이지 최초 진입 시 내 청구 목록 로딩
    loadClaims();
});


/** =========================================================
 * 1) Claims List (목록 조회 + 테이블 렌더링)
 * ========================================================= */
async function loadClaims() {
    const tbody = document.getElementById("claimsTbody");
    const empty = document.getElementById("claimsEmpty");
    const table = document.getElementById("claimsTable");

    try {
        // 청구 목록 조회
        const res = await fetch(`/user/claims/api/list`, {
            method: "GET",
            headers: { "Accept": "application/json" }
        });

        // 인증 필요(세션 만료/미로그인)
        if (res.status === 401) {
            table.style.display = "none";
            empty.style.display = "block";
            empty.querySelector("p").textContent = "로그인이 필요합니다.";
            return;
        }

        if (!res.ok) throw new Error(`HTTP ${res.status}`);

        const list = await res.json();
        tbody.innerHTML = "";

        // 목록이 비어있으면 테이블 숨기고 empty 안내 노출
        if (!list || list.length === 0) {
            table.style.display = "none";
            empty.style.display = "block";
            updateClaimSummaryCounts([]);
            return;
        }

        table.style.display = "";
        empty.style.display = "none";

        // 상단 요약 카운트(대기/반려/승인) 갱신
        updateClaimSummaryCounts(list);

        // 목록 행 생성
        const rowsHtml = list.map(c => {
            const claimId = c.claimId;

            // 상태 → 한글/스타일 클래스 매핑
            const statusText = toKoreanStatus(c.status);
            const statusClass = toStatusClass(c.status);

            const accidentDate = c.accidentDate ?? "-";
            const claimDate = c.claimDate ?? "-";
            const amount = formatNumber(c.claimAmount) + "원";
            const adminName = c.adminName ?? "-";

            // 정책: 승인/반려는 추가 업로드 불가(서류 확인만)
            const uploadDisabled = (c.status === "COMPLETED" || c.status === "REJECTED");
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
            <!-- 버튼 data-* 로 claimId/업로드가능여부 전달 -->
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
        // 네트워크/서버 오류
        console.error(e);
        table.style.display = "none";
        empty.style.display = "block";
        empty.querySelector("p").textContent = "청구 목록을 불러오지 못했습니다.";
    }
}


/** =========================================================
 * 2) Modal State (현재 선택된 청구ID / 업로드 잠금 여부)
 * ========================================================= */
let currentClaimId = null;
let currentUploadDisabled = false;


/** =========================================================
 * 3) Open Modal (테이블 버튼 클릭 → 모달 오픈 + 파일 목록 로드)
 * - 이벤트 위임 방식: 목록이 동적 렌더링이라 document에서 캐치
 * ========================================================= */
document.addEventListener("click", async (e) => {
    const btn = e.target.closest(".js-docs-btn");
    if (!btn) return;

    currentClaimId = btn.dataset.claimId;
    currentUploadDisabled = (btn.dataset.uploadDisabled === "Y");

    openFilesModalUI(currentClaimId, currentUploadDisabled);
    await loadFilesList(currentClaimId);
});


/** =========================================================
 * 4) Modal Open/Close (UI 초기화 포함)
 * ========================================================= */
function openFilesModalUI(claimId, uploadDisabled) {
    const backdrop = document.getElementById("filesModalBackdrop");
    const modal = document.getElementById("filesModal");

    // 표시
    backdrop.style.display = "block";
    modal.style.display = "block";

    // 헤더/힌트 초기화
    document.getElementById("filesModalSub").textContent = `청구ID: ${claimId}`;
    document.getElementById("filesUploadStatus").textContent = "";
    document.getElementById("filesUploadHint").textContent = "pdf/jpg/png 권장, 여러 개 선택 가능";

    // 파일 input 초기화 + 확장자 제한(UX)
    const input = document.getElementById("filesModalInput");
    input.value = "";
    input.accept = ".pdf,.jpg,.jpeg,.png";

    // 정책: 승인/반려면 업로드 막기
    document.getElementById("btnUploadFiles").disabled = uploadDisabled;
    input.disabled = uploadDisabled;

    if (uploadDisabled) {
        document.getElementById("filesUploadHint").textContent =
            "승인이나 반려된 청구는 서류 추가 첨부가 제한됩니다.";
    }
}

function closeFilesModalUI() {
    document.getElementById("filesModalBackdrop").style.display = "none";
    document.getElementById("filesModal").style.display = "none";

    // 상태 초기화(다음 오픈 시 혼선 방지)
    currentClaimId = null;
    currentUploadDisabled = false;
}

// 배경 클릭 / X 버튼 클릭으로 닫기
document.addEventListener("click", (e) => {
    if (e.target.id === "filesModalBackdrop" || e.target.id === "btnCloseFilesModal") {
        closeFilesModalUI();
    }
});


/** =========================================================
 * 5) Load Files List (파일 목록 조회 + 렌더링)
 * - GET /user/claims/{claimId}/files
 * - 현재는 body에 인라인 스타일 HTML을 주입
 * ========================================================= */
async function loadFilesList(claimId) {
    const body = document.getElementById("filesModalBody");
    body.innerHTML = "불러오는 중...";

    try {
        const res = await fetch(`/user/claims/${encodeURIComponent(claimId)}/files`, {
            headers: { "Accept": "application/json" }
        });

        // 서버가 에러 바디를 내려줄 수 있으니 로그 확보
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

// 목록 새로고침 버튼
document.getElementById("btnRefreshFiles")?.addEventListener("click", async () => {
    if (!currentClaimId) return;
    await loadFilesList(currentClaimId);
});


/** =========================================================
 * 6) Upload from Modal (파일 업로드)
 * - POST /user/claims/{claimId}/files
 * - 프론트에서 확장자 1차 필터링(보안이 아니라 UX)
 * ========================================================= */
document.getElementById("btnUploadFiles")?.addEventListener("click", async () => {
    if (!currentClaimId) return;

    const input = document.getElementById("filesModalInput");
    const statusEl = document.getElementById("filesUploadStatus");
    const files = input.files;

    if (!files || files.length === 0) {
        statusEl.innerHTML = `<span style="color:#666;">업로드할 파일을 선택해 주세요.</span>`;
        return;
    }

    // 확장자 1차 체크(UX): 실제 검증은 서버에서도 반드시 해야 함
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

        // 업로드 후 목록 갱신
        await loadFilesList(currentClaimId);

        // 메인 목록까지 갱신이 필요하다면 사용(현재는 첨부 카운트 표시 등이 없으니 주석 처리)
        // await loadClaims();

    } catch (err) {
        console.error(err);
        statusEl.innerHTML = `<span style="color:#b02a37;">업로드 실패: 파일 형식/용량을 확인해 주세요.</span>`;
    } finally {
        // 승인/반려 상태면 업로드 버튼 잠금 유지
        btn.disabled = currentUploadDisabled;
    }
});


/** =========================================================
 * 7) Helpers (표시/포맷/안전 처리)
 * ========================================================= */

// 상태 한글 변환
function toKoreanStatus(status) {
    switch (status) {
        case "PENDING": return "대기";
        case "REJECTED": return "반려";
        case "COMPLETED": return "승인";
        default: return status ?? "-";
    }
}

// 상태 → CSS 클래스 매핑
function toStatusClass(status) {
    switch (status) {
        case "PENDING": return "status-PENDING";
        case "REJECTED": return "status-OVERDUE";
        case "COMPLETED": return "status-PAID";
        default: return "";
    }
}

// 요약 카운트 표시(대기/반려/승인)
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

// 금액 포맷팅(로케일)
function formatNumber(v) {
    if (v === null || v === undefined || v === "") return "0";
    const n = Number(v);
    if (Number.isNaN(n)) return String(v);
    return n.toLocaleString("ko-KR");
}

// XSS 방지용 escape(HTML 출력 시 반드시 사용)
function escapeHtml(str) {
    if (str === null || str === undefined) return "";
    return String(str)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}

// 파일 크기 보기 좋게 변환
function formatBytes(bytes) {
    if (bytes === null || bytes === undefined) return "";
    const b = Number(bytes);
    if (!Number.isFinite(b)) return String(bytes);
    const units = ["B", "KB", "MB", "GB"];
    let i = 0, n = b;
    while (n >= 1024 && i < units.length - 1) { n /= 1024; i++; }
    return `${n.toFixed(i === 0 ? 0 : 1)}${units[i]}`;
}

// 에러 응답 바디를 안전하게 읽기(없어도 죽지 않게)
async function safeReadText(res) {
    try { return await res.text(); } catch { return ""; }
}
