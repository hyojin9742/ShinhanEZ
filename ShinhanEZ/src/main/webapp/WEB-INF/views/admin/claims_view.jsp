<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
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
                                <span><strong>${contracts.adminName}</strong></span>
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

  <!-- 헤더 -->
  <div style="display:flex; justify-content:space-between; align-items:center; padding:16px 18px; border-bottom:1px solid #eee;">
    <div style="font-weight:700;">지급 처리</div>
    <button type="button" class="btn btn-outline" id="btnClosePayModal" style="color: gray; font-weight: bold;">x</button>
  </div>

  <!-- 바디 -->
  <div style="padding:16px 18px;">
	<form method="post" action="${ctx}/admin/claims/${claimsDTO.claimId}/update" id="decisionForm">
	  
	  <input type="hidden" name="claimId" value="${claimsDTO.claimId}"/>

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

	  <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:14px;">
	    <button type="reset" class="btn btn-secondary" id="btnCancelDecision">재작성</button>
	    <button type="submit" class="btn btn-warning">심사/지급 변경</button>
	  </div>
	</form>
  </div>
  
  
  
</div>


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


</body>
</html>