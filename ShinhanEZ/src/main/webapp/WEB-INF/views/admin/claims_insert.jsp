<%-- =========================================================
[Admin Claims Insert]
- 청구 등록 폼 + 계약 선택 모달(전화번호로 계약 조회)
- 모달 동작/데이터 채움: /js/admin/claims_insert.js
- 모달 스타일: /css/admin/claims_insert_modal.css
========================================================= --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <%-- Toast 사용을 위한 Bootstrap --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <jsp:include page="inc/head.jsp"/>

    <%-- 페이지 기본 스타일 --%>
    <link rel="stylesheet" href="${ctx}/css/admin/payment.css">

    <%-- 계약 선택 모달 전용 스타일(인라인 제거) --%>
    <link rel="stylesheet" href="${ctx}/css/admin/claims_insert.css">
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
                    <%-- =========================================================
                    [청구 등록 폼]
                    - 계약 선택 모달에서 customer/insured/contract 정보를 채운 뒤 submit
                    - 서버에서는 ClaimsDTO로 바인딩
                    ========================================================= --%>
                    <form action="${ctx}/admin/claims/insert" method="post">
                        <div class="payment-form">
                            <div>
                                <div class="form-group">
                                    <label class="form-label">청구인</label>
                                    <input type="text" class="form-control" id="claimCustomerName" placeholder="청구인" disabled>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">피보험자</label>
                                    <input type="text" class="form-control" id="claimInsuredName" placeholder="피보험자" disabled>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">전화번호</label>
                                    <input type="text" class="form-control" id="customerPhone" placeholder="전화번호" disabled>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">이메일</label>
                                    <input type="text" class="form-control" id="customerEmail" placeholder="이메일" disabled>
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
                                    <input type="text" class="form-control" id="claimContractId" placeholder="계약ID" readonly>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">사고일</label>
                                    <input type="date" class="form-control" name="accidentDate" value="${today}">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">청구금액</label>
                                    <input type="number" class="form-control" name="claimAmount" placeholder="청구금액" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">처리 상태</label>
                                    <div class="radio-group">
                                        <%-- 정책: 신규 등록은 항상 PENDING --%>
                                        <label><input type="radio" name="status" value="PENDING" checked> 대기</label>
                                    </div>
                                </div>
                            </div>

                            <%-- 모달 선택 결과를 서버로 전달하기 위한 hidden 필드 --%>
                            <input type="hidden" name="customerId" id="claimCustomerId">
                            <input type="hidden" name="insuredId" id="claimInsuredId">
                            <input type="hidden" name="contractId" id="claimContractIdHidden">
                        </div>

                        <div class="btn-area" style="display:flex; justify-content:end;">
                            <%-- 계약 선택 모달 오픈 버튼: 실제 조회/렌더링은 JS가 담당 --%>
                            <button type="button" id="getListContract" class="btn btn-warning" style="margin-right:1vw;">
                                청구인 전화번호 조회
                            </button>

                            <a href="${ctx}/admin/claims" class="btn btn-secondary" style="margin-right:1vw;">목록</a>
                            <button type="submit" class="btn btn-primary">등록</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>


<%-- =========================================================
[계약 선택 모달]
- 전화번호로 고객/계약을 조회하고, 선택한 계약 정보를 폼에 바인딩
- 동작(열기/닫기/조회/선택/확인)은 claims_insert.js에서 처리
========================================================= --%>

<div id="contractModalBackdrop" class="modal-backdrop" aria-hidden="true"></div>

<div id="contractModal" class="modal-sheet" role="dialog" aria-modal="true" aria-labelledby="contractModalTitle">
    <div class="modal-header">
        <div id="contractModalTitle" class="modal-title">계약 선택</div>
        <button type="button" class="btn btn-outline modal-close" id="btnCloseContractModal" aria-label="닫기">x</button>
    </div>

    <div class="modal-body">
        <%-- 검색 영역: 전화번호 입력 후 조회 --%>
        <div class="modal-search-row">
            <div class="modal-search-label">전화번호 검색</div>
            <input type="text" id="modalPhoneInput" class="form-control modal-phone"
                   placeholder="예: 01012345678" inputmode="numeric">
            <button type="button" class="btn btn-outline" id="btnModalSearchContracts">조회</button>
        </div>

        <%-- 모달 내부 안내 메시지(조회 결과 없음/오류 등) --%>
        <div id="contractModalMsg" class="modal-msg" style="display:none;"></div>

        <%-- 계약 리스트(행 렌더링은 JS가 수행) --%>
        <table class="modal-table">
            <thead>
            <tr>
                <th>가입자</th>
                <th>피보험자</th>
                <th>상품명</th>
                <th>계약번호</th>
                <th>상품번호</th>
                <th>가입날짜</th>
                <th>상태</th>
            </tr>
            </thead>
            <tbody id="contractTbody">
            <%-- JS로 채움 --%>
            </tbody>
        </table>

        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" id="btnConfirmContract">확인</button>
        </div>
    </div>
</div>


<%-- Toast: 서버 메시지(msg) 있을 때만 렌더링 --%>
<c:if test="${not empty msg}">
    <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index:20000;">
        <div id="appToast"
             class="toast align-items-center text-bg-${msgType == 'success' ? 'success' : (msgType == 'error' ? 'danger' : 'secondary')} border-0"
             role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">${msg}</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                        data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<%-- 외부 JS에서 컨텍스트 경로 사용(백틱/EL 충돌 피하고, 일관된 경로 생성) --%>
<script>window.APP_CTX = "${ctx}";</script>

<%-- 페이지 전용 JS: 모달 제어/계약 조회/hidden 바인딩 --%>
<script src="${ctx}/js/admin/claims_insert.js"></script>

<script>
    // Toast 자동 표시: msgType이 error면 조금 더 오래 노출
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
