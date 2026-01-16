<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today" />

<!DOCTYPE html>
<html lang="ko">
<head>
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
                                    <label class="form-label">계약ID</label>
                                    <input type="text" class="form-control"
										   id="claimContractId"
                                           placeholder="계약ID"
										   readonly>
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
                            <button type="button" id="getListContract" class="btn btn-outline" style="margin-right:1vw;">청구인 계약조회</button>
                            <a href="${ctx}/admin/claims" class="btn btn-secondary" style="margin-right: 1vw;" >목록</a>
                            <button type="submit" class="btn btn-primary">등록</button>
                        </div>
                    </form>
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
        <div style="display:flex; gap:8px; align-items:center; margin-bottom:12px;">
            <div style="font-size:13px; color:#666;">
                고객 ID
            </div>
			
			<input type="text" id="modalCustomerIdInput" class="form-control" placeholder="예: C001" style="max-width:220px;">
			<button type="button" class="btn btn-outline" id="btnModalSearchContracts">조회</button>
			
        </div>

        <div id="contractModalMsg" style="display:none; margin:10px 0; padding:10px 12px; border-radius:10px; background:#f6f7fb; color:#333;"></div>

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
            <tbody id="contractTbody">
            <!-- JS로 채움 -->
            </tbody>
        </table>

        <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:14px;">
            <button type="button" class="btn btn-secondary" id="btnConfirmContract">확인</button>
        </div>
    </div>
</div>

<script>
	window.APP_CTX = "${ctx}";
</script>
<script src="${ctx}/js/claims_insert.js"></script>
</body>
</html>