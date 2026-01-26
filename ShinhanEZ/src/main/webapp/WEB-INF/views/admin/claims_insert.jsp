<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today" />
<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- 토스트 표시 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="inc/head.jsp"/>
    <link rel="stylesheet" href="${ctx}/css/admin/payment.css">
</head>
<body class="admin-page">
<div class="admin-wrapper">
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="claims"/>
    </jsp:include>
    <div class="admin-main">
        <jsp:include page="inc/header.jsp"/>
        <main class="admin-content">
            <div class="page-title-area">
                <h2 class="page-title">청구 등록</h2>
            </div>
            <div class="card">
                <div class="card-header">
                    <span>청구 등록</span>
                </div>
                <div class="card-body">
					<!-- 청구 등록 폼 -->
                    <form action="${ctx}/admin/claims/insert" method="post">
                        <div class="payment-form">
                            <div>
                                <div class="form-group">
                                    <label class="form-label">청구인</label>
                                    <input type="text" class="form-control"
										   id="claimCustomerName"
                                           placeholder="청구인"
                                           disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">피보험자</label>
                                    <input type="text" class="form-control"
										   id="claimInsuredName"
                                           placeholder="피보험자"
										   disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">전화번호</label>
                                    <input type="text" class="form-control"
										   id="customerPhone"
                                           placeholder="전화번호"
										   disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">이메일</label>
                                    <input type="text" class="form-control"
										   id="customerEmail"
                                           placeholder="이메일"
										   disabled>
                                </div>
								<div class="form-group" style="width: 200%;">
								  <label class="form-label">제출 서류</label>
								  <textarea class="form-control"
								            name="documentList"
								            rows="4"
								            placeholder="예: 진단서, 입원확인서, 신분증 사본, 특이사항"></textarea>
								</div>
                            </div>
                            <div>
								<div class="form-group">
                                    <label class="form-label">계약ID</label>
                                    <input type="text" class="form-control"
										   id="claimContractId"
                                           placeholder="계약ID"
										   readonly>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">사고일</label>
                                    <input type="date" class="form-control"
                                           name="accidentDate"
                                           value="${today}">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">청구금액</label>
                                    <input type="number" class="form-control"
                                           name="claimAmount"
                                           placeholder="청구금액"
                                           required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">처리 상태</label>
                                    <div class="radio-group">
                                        <label><input type="radio" name="status" value="PENDING" checked> 대기</label>
                                    </div>
                                </div>
                            </div>
							<input type="hidden" name="customerId" id="claimCustomerId">
							<input type="hidden" name="insuredId" id="claimInsuredId">
							<input type="hidden" name="contractId" id="claimContractIdHidden">
                        </div>
                        <div class="btn-area" style="display: flex; justify-content: end;">
                            <button type="button" id="getListContract" class="btn btn-warning" style="margin-right:1vw;">청구인 전화번호 조회</button>
                            <a href="${ctx}/admin/claims" class="btn btn-secondary" style="margin-right: 1vw;" >목록</a>
                            <button type="submit" class="btn btn-primary">등록</button>
                        </div>
                    </form>
					<!-- /청구 등록 폼 -->
                </div>
            </div>
        </main>
        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>


<!-- 계약 선택 모달 -->
<div id="contractModalBackdrop" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.45); z-index:9998;"></div>

	<div id="contractModal" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%);
    	width:min(920px, 92vw); max-height:80vh; overflow:auto; background:#fff; border-radius:14px; z-index:9999;
    	box-shadow:0 20px 60px rgba(0,0,0,.25);">

    <div style="display:flex; justify-content:space-between; align-items:center; padding:16px 18px; border-bottom:1px solid #eee;">
        <div style="font-weight:700;">계약 선택</div>
        <button type="button" class="btn btn-outline" id="btnCloseContractModal" style="color: gray; font-weight: bold;">
			x
		</button>
    </div>
	
    <div style="padding:16px 18px;">
		<!-- 고객ID 입력 + 조회 버튼 -->
        <div style="display:flex; gap:8px; align-items:center; margin-bottom:12px;">
            <div style="font-size:13px; color:#666;">전화번호 검색</div>
			<input type="text" id="modalPhoneInput" class="form-control" placeholder="예: 01012345678" style="max-width:220px;">
			<button type="button" class="btn btn-outline" id="btnModalSearchContracts">조회</button>
        </div>

		<!-- 모달 내부 메시지 -->
        <div id="contractModalMsg" style="display:none; margin:10px 0; padding:10px 12px; border-radius:10px; background:#f6f7fb; color:#333;"></div>

		<!-- 계약 리스트 테이블 -->
        <table style="width:100%; border-collapse:collapse;">
            <thead>
            <tr style="text-align:left; border-bottom:1px solid #eee;">
                <th style="padding:10px 8px;">가입자</th>
                <th style="padding:10px 8px;">피보험자</th>
                <th style="padding:10px 8px;">상품명</th>
                <th style="padding:10px 8px;">계약번호</th>
                <th style="padding:10px 8px;">상품번호</th>
                <th style="padding:10px 8px;">가입날짜</th>
                <th style="padding:10px 8px;">상태</th>
            </tr>
            </thead>
			<!-- JS로 행 추가 -->
            <tbody id="contractTbody">
            <!-- JS로 채움 -->
            </tbody>
        </table>

        <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:14px;">
            <button type="button" class="btn btn-secondary" id="btnConfirmContract">확인</button>
        </div>
    </div>
</div>
<!-- /계약 선택 모달 -->

<!-- 토스트(성공/실패 메시지 표시): msg 있을 때만 렌더링 -->
<c:if test="${not empty msg}">
	<div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3"style="z-index:20000;">
		<div id="appToast" class="toast align-items-center text-bg-${msgType == 'success' ? 'success' : (msgType == 'error' ? 'danger' : 'secondary') } border-0" role="alert" aria-live="assertive" aria-atomic="true">
		    <div class="d-flex">
		    	<div class="toast-body">${msg}</div>
		    	<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
		    </div>
		</div>
	</div>
</c:if>

<!-- Bootstrap JS 번들(Toast 동작 필요) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 전역 컨텍스트 경로: 외부 JS에서 사용 -->
<script>window.APP_CTX = "${ctx}";</script>

<!-- 페이지 전용 JS(계약 조회/모달 제어/hidden 채우기 등) -->
<script src="${ctx}/js/claims_insert.js"></script>

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