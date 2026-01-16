document.addEventListener("DOMContentLoaded", function(){
	
/* 모달 open / close 구현 */	
	const openBtn = document.getElementById("getListContract");
	const backdrop = document.getElementById("contractModalBackdrop");
	const modal = document.getElementById("contractModal");
	
	if(!openBtn || !backdrop || !modal) return;
 	
	function openModal(){
		backdrop.style.display = "block";
		modal.style.display = "block";
	}

	function closeModal(){
		backdrop.style.display = "none";
		modal.style.display = "none";
	}

	openBtn.addEventListener("click", openModal);
	backdrop.addEventListener("click", closeModal);
	document.getElementById("btnCloseContractModal").addEventListener("click", closeModal);
/* /모달 open / close 구현 */

/* ===== 조회(API 호출) + 테이블 렌더링 ===== */
	const customerIdInput = document.getElementById("modalCustomerIdInput");
	const searchBtn = document.getElementById("btnModalSearchContracts");
	const tbody = document.getElementById("contractTbody");
	const msgBox = document.getElementById("contractModalMsg");
	
	// 모달 요소가 없으면 종료
	if (customerIdInput && searchBtn && tbody && msgBox) {
	
	  // 메시지 출력 헬퍼 ??
	  function showMsg(text) {
	    msgBox.style.display = "block";
	    msgBox.textContent = text;
	  }
	
	  // XSS 방지 escape
	  function escapeHtml(str) {
	    return String(str ?? "")
	      .replaceAll("&", "&amp;")
	      .replaceAll("<", "&lt;")
	      .replaceAll(">", "&gt;")
	      .replaceAll('"', "&quot;")
	      .replaceAll("'", "&#039;");
	  }
	
	  async function fetchContracts() {
	    const customerId = customerIdInput.value.trim();
	
	    // 1) 입력 검증
	    if (!customerId) {
	      showMsg("고객 ID를 입력해주세요.");
	      tbody.innerHTML = "";
	      return;
	    }
	
	    // 2) 로딩 표시
	    showMsg("조회 중...");
	    tbody.innerHTML = "";
	
	    try {
	      const ctx = window.APP_CTX ?? "";
	      const url = `${ctx}/admin/claims/contracts?customerId=${encodeURIComponent(customerId)}`; // 입력받은 customerId
	
	      const res = await fetch(url, {
	        method: "GET",
	        headers: { "Accept": "application/json" }
	      });
	
	      if (!res.ok) {
	        showMsg(`조회 실패 (HTTP ${res.status})`);
	        return;
	      }
	
	      const list = await res.json();
	
	      // 3) 결과 처리
	      if (!Array.isArray(list) || list.length === 0) {
	        showMsg("조회 결과가 없습니다.");
	        return;
	      }
	
	      showMsg(`${list.length}건 조회되었습니다.`);
	
		  // 타임포멧
		  function formatDate(isoStr) {
		  		    if (!isoStr) return "";
		  		    // 예: "2023-12-31T15:00:00.000+00:00" -> "2023-12-31"
		  		    return String(isoStr).slice(0, 10);
		  		  }
		  
	      // 4) 테이블 렌더 (가입자/피보험자/상품명/상태)
		  tbody.innerHTML = list.map(row => `
		    <tr data-contract-id="${escapeHtml(row.contractId)}"
		        style="border-bottom:1px solid #eee; cursor:pointer;">
		      <td style="padding:10px 8px;">${escapeHtml(row.customerName)}</td>
		      <td style="padding:10px 8px;">${escapeHtml(row.insuredName)}</td>
		      <td style="padding:10px 8px;">${escapeHtml(row.productName)}</td>
		      <td style="padding:10px 8px;">${escapeHtml(row.contractId)}</td>
		      <td style="padding:10px 8px;">${escapeHtml(row.productId)}</td>
		      <td style="padding:10px 8px;">${formatDate(row.regDate)}</td>
		      <td style="padding:10px 8px;">${escapeHtml(row.contractStatus)}</td>
		    </tr>
		  `).join("");
		  
		  /* ===== 계약List 선택 상태 변경 ===== */
		  // 선택된 계약(행) 저장용
		  let selectedContract = null;

		  	const rows = tbody.querySelectorAll("tr");
		  	
		  	rows.forEach(tr => {
		  	  tr.addEventListener("click", function () {
		  	
		  	    // 1) 기존 선택 해제
		  	    rows.forEach(r => {
		  	      r.classList.remove("selected-row");
		  	      r.style.background = ""; // 인라인 스타일로도 확실히 초기화
		  	    });
		  	
		  	    // 2) 현재 행 선택 표시
		  	    tr.classList.add("selected-row");
		  	    tr.style.background = "#D5F3F2FF"; // 보기 좋게 연한 강조
		  	
		  	    // 3) 선택된 데이터 저장
		  	    selectedContract = {
		  	      contractId: tr.dataset.contractId,
		  	      customerName: tr.children[0].textContent.trim(),
		  	      insuredName: tr.children[1].textContent.trim(),
		  	      productName: tr.children[2].textContent.trim(),
		  	      productId: tr.children[4].textContent.trim(),
		  	      regDate: tr.children[5].textContent.trim(),
		  	      contractStatus: tr.children[6].textContent.trim()
		  	    };
		  	  });
		  	});
		  /* ===== /계약List 선택 상태 변경 ===== */
		  
		  /* ===== 계약 단건 API 호출 ===== */
		  const confirmBtn = document.getElementById("btnConfirmContract");
		  if (confirmBtn) {
		    confirmBtn.addEventListener("click", async function () {
		      // 1) 선택 여부 확인
		      if (!selectedContract || !selectedContract.contractId) {
		        showMsg("계약을 선택해주세요.");
		        return;
		      }

		      try {
		        const ctx = window.APP_CTX ?? "";
		        const url = `${ctx}/admin/claims/contracts/${encodeURIComponent(selectedContract.contractId)}`;

		        showMsg("계약 상세 불러오는 중...");

		        const res = await fetch(url, {
		          method: "GET",
		          headers: { "Accept": "application/json" }
		        });

		        if (!res.ok) {
		          showMsg(`상세 조회 실패 (HTTP ${res.status})`);
		          return;
		        }

		        const detail = await res.json();

		        // 2) 메인 폼 채우기 (표시용)
		        const customerNameEl = document.getElementById("claimCustomerName");
		        const insuredNameEl = document.getElementById("claimInsuredName");
		        const contractIdEl = document.getElementById("claimContractId");

		        if (customerNameEl) customerNameEl.value = detail.customerName ?? "";
		        if (insuredNameEl) insuredNameEl.value = detail.insuredName ?? "";
		        if (contractIdEl) contractIdEl.value = detail.contractId ?? "";

		        // 3) 메인 폼 채우기 (전송용 hidden)
		        const customerIdEl = document.getElementById("claimCustomerId");
		        const insuredIdEl = document.getElementById("claimInsuredId");
		        const contractIdHiddenEl = document.getElementById("claimContractIdHidden");

		        if (customerIdEl) customerIdEl.value = detail.customerId ?? "";
		        if (insuredIdEl) insuredIdEl.value = detail.insuredId ?? "";
		        if (contractIdHiddenEl) contractIdHiddenEl.value = detail.contractId ?? "";

		        // 4) 모달 닫기
		        closeModal();

		        // 5) 모달 메시지 숨김/초기화(선택)
		        msgBox.style.display = "none";

		      } catch (e) {
		        console.error(e);
		        showMsg("상세 조회 중 오류가 발생했습니다.");
		      }
		    });
		  }		  
		  /* ===== /계약 단건 API 호출 ===== */
		  
		  
		  
		  
	
	    } catch (e) {
	      console.error(e);
	      showMsg("조회 중 오류가 발생했습니다.");
	    }
	  }
	
	  // 버튼클릭 조회
	  searchBtn.addEventListener("click", fetchContracts);
	
	  // 엔터 조회
	  customerIdInput.addEventListener("keydown", function (e) {
	    if (e.key === "Enter") {
	      e.preventDefault();
	      fetchContracts();
	    }
	  });
	}	
/* /===== 조회(API 호출) + 테이블 렌더링 ===== */





}) // end of js