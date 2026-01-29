<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- 토스트 표시 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="inc/head.jsp"/>
	<style>
	/* 카드 안 정보 가독성 개선 */
	.detail-row {
	  padding: 8px 0;
	  border-bottom: 1px dashed #e5e7eb;
	}

	.detail-row:last-child {
	  border-bottom: none;
	}

	.detail-item {
	  display: flex;
	  gap: 10px;
	  padding: 4px 0;
	}

	.detail-item label {
	  min-width: 110px;
	  font-size: 13px;
	  font-weight: 600;
	  color: #6b7280;
	}

	.detail-item span,
	.detail-item strong {
	  font-size: 14px;
	}
	</style>
</head>
<body class="admin-page">
<div class="admin-wrapper">

    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="claims"/>
    </jsp:include>

    <div class="admin-main">
		
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="청구 상세"/>
        </jsp:include>

        <main class="admin-content">
            <div class="page-header">
                <h2>청구 상세정보</h2>
                <p>
                    청구번호 <strong>${claimsDTO.claimId}번의 </strong> 상세 정보입니다.
                </p>
            </div>
            <!-- 1) 청구 기본 정보 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-file-earmark-text"></i> 청구 정보</span>
                </div>
                <div class="card-body">
                    <div class="detail-grid">
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>청구 번호</label>
                                <span><strong>${claimsDTO.claimId}</strong></span>
                            </div>
                            <div class="detail-item">
                                <label>상태</label>
								<!-- 상태값에 따른 배지 표시 -->
								<c:choose>
								    <c:when test="${claimsDTO.status == 'PENDING'}">
								        <span class="badge badge-primary" style="width: fit-content !important;">미처리</span>
								    </c:when>
								    <c:when test="${claimsDTO.status == 'COMPLETED'}">
								        <span class="badge badge-success" style="width: fit-content !important;">승인</span>
								    </c:when>
								    <c:when test="${claimsDTO.status == 'REJECTED'}">
								        <span class="badge badge-danger" style="width: fit-content !important;">반려</span>
								    </c:when>
								    <c:otherwise>
								        <span class="badge badge-secondary">${claimsDTO.status}</span>
								    </c:otherwise>
								</c:choose>
                            </div>
                        </div>
						<!-- 사고일 / 청구일 -->
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>사고일</label>
                                <span><strong>${claimsDTO.accidentDate}</strong></span>
                            </div>
                            <div class="detail-item">
                                <label>청구일</label>
								<span><strong>${claimsDTO.claimDate}</strong></span>
                            </div>
                        </div>
						<!-- 청구금액 / 지급금액 -->
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>청구금액</label>
                                <span><strong><fmt:formatNumber value="${claimsDTO.claimAmount}" pattern="#,##0"/></strong></span>
                            </div>
                            <div class="detail-item">
                                <label>지급금액</label>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty claimsDTO.paidAmount}">
											<span><strong>${claimsDTO.paidAmount}</strong></span>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
						<!-- 지급일 / 처리완료일 -->
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>지급일</label>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty claimsDTO.paidAt}">
											<span><strong>${claimsDTO.completedAt}</strong></span>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="detail-item">
                                <label>처리완료일</label>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty claimsDTO.completedAt}">
											<span><strong>${claimsDTO.completedAt}</strong></span>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
						<!-- 서류 목록 -->
                        <div class="detail-row">
                            <div class="detail-item full">
                                <label>서류 목록</label>
                                <span>${claimsDTO.documentList}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 2) 상품정보 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-people"></i> 상품 정보</span>
                </div>
                <div class="card-body">
                    <div class="detail-grid">
						<div class="detail-row">
						    <div class="detail-item">
						        <label>상품명</label>
						        <span>
						            <c:choose>
						                <c:when test="${not empty contracts.productName}">
											<span><strong>${contracts.productName}</strong></span>
						                </c:when>
						                <c:otherwise>-</c:otherwise>
						            </c:choose>
						        </span>
						    </div>
						    <div class="detail-item">
						        <label>보장내역</label>
						        <span>
						            <c:choose>
						                <c:when test="${not empty contracts.contractCoverage}">
											<span><strong>${contracts.contractCoverage}</strong></span>
						                </c:when>
						                <c:otherwise>-</c:otherwise>
						            </c:choose>
						        </span>
						    </div>
						</div>
                    </div>
                </div>
            </div>
            <!-- 3) 청구인(고객) / 피보험자 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-people"></i> 관련자 정보</span>
                </div>
                <div class="card-body">
                    <div class="detail-grid">
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>보험가입자 ID</label>
                                <span><strong>${claimsDTO.customerId}</strong></span>
                            </div>
                            <div class="detail-item">
                                <label>보험가입자 이름</label>
                                <span><strong>${contracts.customerName}</strong></span>
                            </div>
                            <div class="detail-item">
                                <label>보험가입자 전화번호</label>
                                <span><strong>${customer.phone}</strong></span>
                            </div>
                            <div class="detail-item">
                                <label>보험가입자 이메일</label>
                                <span><strong>${customer.email}</strong></span>
                            </div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>피보험자 ID</label>
                                <span><strong>${claimsDTO.insuredId}</strong></span>
                            </div>
                            <div class="detail-item">
                                <label>피보험자 이름</label>
                                <span><strong>${contracts.insuredName}</strong></span>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <!-- 4) 계약 정보 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-journal-text"></i> 계약 정보</span>
                </div>
                <div class="card-body">
                    <div class="detail-grid">
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>계약 ID</label>
                                <span><strong>${claimsDTO.contractId}</strong></span>
                            </div>
                            <div class="detail-item">
                                <label>담당 관리자</label>
                                <span><strong>${claimsDTO.adminName}</strong></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 버튼 영역 (청구용) -->
            <div class="btn-area">
                <div style="width:100%; display: flex; justify-content: flex-end; gap: 1vw;">
	                <a href="${ctx}/admin/claims/" class="btn btn-outline">
	                    <i class="bi bi-list"></i> 목록
	                </a>
					<c:if test="${claimsDTO.status != 'COMPLETED' and claimsDTO.status != 'REJECTED'}">
	                    <button type="button" class="btn btn-warning" id="btnPay">
	                        <i class="bi bi-cash-coin"></i> 심사/지급
	                    </button>
					</c:if>
                </div>
            </div>
			
        </main>
		<!-- footer -->
        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>

<!-- 지급 처리 모달 -->
<div id="payModalBackdrop"
     style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.45); z-index:9998;"></div>

<div id="payModal"
     style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%);
            width:min(720px, 92vw); max-height:80vh; overflow:auto; background:#fff; border-radius:14px; z-index:9999;
            box-shadow:0 20px 60px rgba(0,0,0,.25);">

  	<!-- 모달 헤더 -->
	<div style="display:flex; justify-content:space-between; align-items:center; padding:16px 18px; border-bottom:1px solid #eee;">
		<div style="font-weight:700;">지급 처리</div>
  		<button type="button" class="btn btn-outline" id="btnClosePayModal" style="color: gray; font-weight: bold;">x</button>
  	</div>

  	<!-- 모달 바디 -->
  	<div style="padding:16px 18px;">
		<!-- 심사/지급 변경 폼 -->
		<form method="post" action="${ctx}/admin/claims/${claimsDTO.claimId}/update" id="decisionForm">
			<!-- claimsId hidden -->
	  		<input type="hidden" name="claimId" value="${claimsDTO.claimId}"/>
			<!-- adminIdx hidden -->
	  		<input type="hidden" name="adminIdx" value="${claimsDTO.adminIdx}"/>
	  		<!-- 결정 상태 -->
	  		<div style="font-size:13px; color:#666; margin-bottom:6px;">심사</div>
	  		<div style="display:flex; gap:14px; align-items:center; padding:8px 0;">
	    		<label style="display:flex; align-items:center; gap:6px; cursor:pointer;">
	      			<input type="radio" name="status" value="PENDING" checked> 미처리
	    		</label>
	    		<label style="display:flex; align-items:center; gap:6px; cursor:pointer;">
	      			<input type="radio" name="status" value="COMPLETED"> 승인
	    		</label>
	    		<label style="display:flex; align-items:center; gap:6px; cursor:pointer;">
	      			<input type="radio" name="status" value="REJECTED"> 반려
	    		</label>
	  		</div>
			<!-- 지급금액/지급일 -->
	  		<div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px; margin-top:10px;">
	    		<div>
	      			<div style="font-size:13px; color:#666; margin-bottom:6px;">지급금액</div>
	      			<input type="number" name="paidAmount" class="form-control" placeholder="예: 300000">
	    		</div>
	    		<div>
	      			<div style="font-size:13px; color:#666; margin-bottom:6px;">지급일</div>
	      			<input type="date" name="paidAt" class="form-control">
	    		</div>
	  		</div>
			<!-- 모달 버튼 -->
	  		<div style="display:flex; justify-content:flex-end; gap:8px; margin-top:14px;">
	    		<button type="reset" class="btn btn-secondary" id="btnCancelDecision">재작성</button>
	    		<button type="submit" class="btn btn-warning">심사/지급 변경</button>
	  		</div>
		</form>
  	</div>
</div>

<!-- 토스트(성공/실패 메시지) -->
<c:if test="${not empty msg}">
	<div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3"style="z-index:20000;">
		<div id="appToast"
	       	 class="toast align-items-center text-bg-${msgType == 'success' ? 'success' : (msgType == 'error' ? 'danger' : 'secondary') } border-0"
	         role="alert" aria-live="assertive" aria-atomic="true">
	    	<div class="d-flex">
	      		<div class="toast-body">${msg}</div>
	      		<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
	    	</div>
	  	</div>
	</div>
</c:if>
<!-- Bootstrap JS 번들(Toast 동작 필요) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 모달 열고 닫기: vanilla JS로 display 제어 -->
<script>
	const btnPay = document.getElementById("btnPay");
	const payModal = document.getElementById("payModal");
	const payModalBackdrop = document.getElementById("payModalBackdrop");
	const btnClosePayModal = document.getElementById("btnClosePayModal");

	// 열기
  	btnPay?.addEventListener("click", () => {
    	payModal.style.display = "block";
    	payModalBackdrop.style.display = "block";
  	});

  	// 닫기 (X 버튼)
  	btnClosePayModal?.addEventListener("click", () => {
    	payModal.style.display = "none";
    	payModalBackdrop.style.display = "none";
  	});

  	// 닫기 (바깥 클릭)
  	payModalBackdrop?.addEventListener("click", () => {
	    payModal.style.display = "none";
    	payModalBackdrop.style.display = "none";
  	});
</script>

<!-- 토스트 자동 표시 -->
<script>
	(function () {
    	const el = document.getElementById("appToast");
    	if (!el) return;

    	const isError = "${msgType}" === "error";
    	bootstrap.Toast.getOrCreateInstance(el, {
      		delay: isError ? 4000 : 2200,
      		autohide: true
    	}).show();
  	})();
</script>

</body>
</html>