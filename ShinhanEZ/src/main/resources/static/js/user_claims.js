(function () {
  // === (1) 요소 캐싱 ===
  const openBtn = document.getElementById("btnClaimStart");           // 모달 오픈 버튼
  const backdrop = document.getElementById("contractModalBackdrop");  // 백드롭
  const modal = document.getElementById("contractModal");             // 모달

  const closeBtn = document.getElementById("btnCloseContractModal");  // 닫기
  const confirmBtn = document.getElementById("btnConfirmContract");   // 확인

  const msgEl = document.getElementById("contractModalMsg");          // 메시지
  const tbody = document.getElementById("contractTbody");             // 테이블 바디

  if (!openBtn || !backdrop || !modal || !tbody) return;

  let selectedContract = null; // 선택된 계약 객체(Contracts)

  // === (2) 유틸 ===
  function escapeHtml(str) {
    return String(str ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;");
  }

  function showMsg(text) {
    if (!msgEl) return;
    msgEl.textContent = text || "";
    msgEl.style.display = text ? "block" : "none";
  }

  function clearRows() {
    tbody.innerHTML = "";
    selectedContract = null;
    if (confirmBtn) confirmBtn.disabled = true;
  }

  function openModal() {
    modal.style.display = "block";
    backdrop.style.display = "block";
    document.body.style.overflow = "hidden";

    // ✅ 모달 열릴 때 자동 조회
    loadContracts();
  }

  function closeModal() {
    modal.style.display = "none";
    backdrop.style.display = "none";
    document.body.style.overflow = "";
  }

  function formatDate(value) {
    // 서버에서 @JsonFormat("yyyy-MM-dd")이면 문자열로 내려올 가능성이 큼
    // 혹시 ISO나 Date로 내려와도 안전하게 처리
    if (!value) return "-";
    if (typeof value === "string") return value; // "yyyy-MM-dd"
    try {
      const d = new Date(value);
      if (Number.isNaN(d.getTime())) return String(value);
      const yyyy = d.getFullYear();
      const mm = String(d.getMonth() + 1).padStart(2, "0");
      const dd = String(d.getDate()).padStart(2, "0");
      return `${yyyy}-${mm}-${dd}`;
    } catch {
      return String(value);
    }
  }

  function statusLabel(contractStatus) {
    // 필요하면 상태코드 -> 한글 라벨로 매핑
    // 태양님 DB/도메인 규칙에 맞게 추가 가능
    if (!contractStatus) return "-";
    const s = String(contractStatus).toUpperCase();
    if (s === "ACTIVE") return "정상";
    if (s === "EXPIRED") return "만료";
    if (s === "CANCELLED" || s === "CANCELED") return "해지";
    return contractStatus; // 그대로 표시
  }

  // === (3) REST 호출 + 렌더 ===
  async function loadContracts() {
    clearRows();
    showMsg("계약 정보를 불러오는 중입니다...");

    try {
      const res = await fetch("/user/claims/contracts", {
        method: "GET",
        headers: { "Accept": "application/json" },
        credentials: "same-origin",
      });

      if (res.status === 401) {
        showMsg("로그인이 필요합니다.");
        return;
      }

      if (!res.ok) {
        showMsg(`계약 조회에 실패했습니다. (HTTP ${res.status})`);
        return;
      }

      const list = await res.json();

      if (!Array.isArray(list) || list.length === 0) {
        showMsg("조회된 계약이 없습니다.");
        return;
      }

      showMsg("");

      list.forEach((c) => {
        // Contracts DTO 필드 그대로 사용
        const tr = document.createElement("tr");
        tr.dataset.contractId = c.contractId;

        tr.innerHTML = `
          <td>${escapeHtml(c.contractId)}</td>
          <td>${escapeHtml(c.customerName)}</td>
          <td>${escapeHtml(c.insuredName)}</td>
          <td>${escapeHtml(c.productName)}</td>
          <td>${escapeHtml(c.contractCoverage)}</td>
          <td>${escapeHtml(formatDate(c.regDate))}</td>
          <td>${escapeHtml(statusLabel(c.contractStatus))}</td>
        `;

        tr.addEventListener("click", () => {
          // 선택 표시
          tbody.querySelectorAll("tr").forEach((row) => row.classList.remove("is-selected"));
          tr.classList.add("is-selected");

          selectedContract = c;
          if (confirmBtn) confirmBtn.disabled = false;
        });

        tbody.appendChild(tr);
      });

      // 첫 번째 자동 선택(원치 않으면 제거)
      const firstRow = tbody.querySelector("tr");
      if (firstRow) firstRow.click();

    } catch (e) {
      showMsg("네트워크 오류로 계약 정보를 불러오지 못했습니다.");
    }
  }

  // === (4) 이벤트 바인딩 ===
  openBtn.addEventListener("click", openModal);
  closeBtn?.addEventListener("click", closeModal);
  backdrop.addEventListener("click", closeModal);

  confirmBtn?.addEventListener("click", () => {
    if (!selectedContract) {
      showMsg("계약을 선택해 주세요.");
      return;
    }


    // ✅ 다음 단계: 계약 ID를 가지고 청구 진행 화면으로 이동(예시)
    // location.href = `/user/claims/form?contractId=${encodeURIComponent(selectedContract.contractId)}`;

    // ✅ 또는 기존 commView 흐름을 유지하면서 contractId를 활용하고 싶다면,
    // commView.goQrLk가 파라미터를 받을 수 있는지 규격을 정해야 합니다.
    if (window.commView?.goQrLk) {
      window.commView.goQrLk("3002");
    }
  });
})();

/* 계약 단건 조회 */
(function () {
  const stepContract = document.getElementById("stepContract");
  const stepClaimForm = document.getElementById("stepClaimForm");

  const btnConfirm = document.getElementById("btnConfirmContract");
  const btnBack = document.getElementById("btnBackToList");
  const btnSubmit = document.getElementById("btnSubmitClaim");

  const tbody = document.getElementById("contractTbody");
  const msgEl = document.getElementById("contractModalMsg");

  // 바인딩 대상
  const inCustomerId = document.getElementById("claimCustomerId");
  const inInsuredId  = document.getElementById("claimInsuredId");
  const inContractIdHidden = document.getElementById("claimContractIdHidden");

  const outCustomerName = document.getElementById("claimCustomerName");
  const outInsuredName  = document.getElementById("claimInsuredName");
  const outContractId   = document.getElementById("claimContractId");

  function showMsg(text){
    if(!msgEl) return;
    msgEl.textContent = text || "";
    msgEl.style.display = text ? "block" : "none";
  }

  async function fetchContractOne(contractId){
    // ✅ 태양님 단건 REST 경로로 맞추세요
    const res = await fetch(`/user/claims/contracts/${encodeURIComponent(contractId)}`, {
      headers: { "Accept": "application/json" },
      credentials: "same-origin"
    });
    if (res.status === 401) throw new Error("로그인이 필요합니다.");
    if (!res.ok) throw new Error(`계약 조회 실패(HTTP ${res.status})`);
    return await res.json();
  }

  function bindClaimForm(c){
    // INSERT용
    inCustomerId.value = c.customerId ?? "";
    inInsuredId.value = c.insuredId ?? "";
    inContractIdHidden.value = c.contractId ?? "";

    // 화면 표시용
    outCustomerName.value = c.customerName ?? "";
    outInsuredName.value = c.insuredName ?? "";
    outContractId.value = c.contractId ?? "";
  }

  function goStep2(){
    stepContract.style.display = "none";
    stepClaimForm.style.display = "block";
    btnConfirm.style.display = "none";
    btnBack.style.display = "inline-flex";
    btnSubmit.style.display = "inline-flex";
  }

  function goStep1(){
    stepContract.style.display = "block";
    stepClaimForm.style.display = "none";
    btnConfirm.style.display = "inline-flex";
    btnBack.style.display = "none";
    btnSubmit.style.display = "none";
  }

  btnConfirm?.addEventListener("click", async () => {
    const row = tbody.querySelector("tr.is-selected");
    const contractId = row?.dataset?.contractId;

    if (!contractId){
      showMsg("계약을 선택해 주세요.");
      return;
    }

    btnConfirm.disabled = true;
    showMsg("선택한 계약 정보를 불러오는 중입니다...");

    try{
      const contract = await fetchContractOne(contractId);
      bindClaimForm(contract);
      showMsg("");
      goStep2();
    }catch(e){
      showMsg(e.message || "계약 조회 중 오류가 발생했습니다.");
    }finally{
      btnConfirm.disabled = false;
    }
  });

  btnBack?.addEventListener("click", () => {
    showMsg("");
    goStep1();
  });
})();

function openModal(){
  modal.classList.add("is-open");
  backdrop.classList.add("is-open");
  document.body.style.overflow = "hidden";
}

function closeModal(){
  modal.classList.remove("is-open");
  backdrop.classList.remove("is-open");
  document.body.style.overflow = "";
}
