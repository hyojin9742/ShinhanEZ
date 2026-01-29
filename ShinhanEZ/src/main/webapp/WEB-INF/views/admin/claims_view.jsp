<%-- =========================================================
[Admin Claims View]
- 청구 상세 정보 + 첨부서류 목록 + 심사/지급 처리 모달
- 화면 데이터: claimsDTO, contracts, customer, claimFiles
- 지급 처리: POST /admin/claims/{claimId}/update
- 스타일: /css/admin/claims_view.css
========================================================= --%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <%-- Toast 사용을 위한 Bootstrap --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="inc/head.jsp"/>

    <%-- 청구 상세 화면 전용 스타일(인라인 제거) --%>
    <link rel="stylesheet" href="${ctx}/css/admin/claims_view.css">
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
                <p>청구번호 <strong>${claimsDTO.claimId}번의 </strong> 상세 정보입니다.</p>
            </div>

            <%-- 1) 청구 기본 정보 --%>
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
                                <%-- 상태값 매핑: PENDING=미처리, COMPLETED=승인, REJECTED=반려 --%>
                                <c:choose>
                                    <c:when test="${claimsDTO.status == 'PENDING'}">
                                        <span class="badge badge-primary badge-fit">미처리</span>
                                    </c:when>
                                    <c:when test="${claimsDTO.status == 'COMPLETED'}">
                                        <span class="badge badge-success badge-fit">승인</span>
                                    </c:when>
                                    <c:when test="${claimsDTO.status == 'REJECTED'}">
                                        <span class="badge badge-danger badge-fit">반려</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-secondary badge-fit">${claimsDTO.status}</span>
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
                      <strong><fmt:formatNumber value="${claimsDTO.paidAmount}" pattern="#,##0"/></strong>
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
                      <strong>${claimsDTO.paidAt}</strong>
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
                      <strong>${claimsDTO.completedAt}</strong>
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </span>
                            </div>
                        </div>

                        <div class="detail-row">
                            <div class="detail-item full">
                                <label>특이사항</label>
                                <span>${claimsDTO.documentList}</span>
                            </div>
                        </div>
                    </div>

                    <%-- 첨부 서류(파일 메타 목록) --%>
                    <div class="detail-row">
                        <div class="detail-item full file-block">
                            <label>첨부 서류</label>

                            <c:choose>
                                <c:when test="${empty claimFiles}">
                                    <span class="text-muted">첨부된 서류가 없습니다.</span>
                                </c:when>
                                <c:otherwise>
                                    <table class="table table-sm align-middle file-table">
                                        <thead>
                                        <tr>
                                            <th>파일명</th>
                                            <th class="w-120">용량</th>
                                            <th class="w-160">업로더</th>
                                            <th class="w-160">업로드일</th>
                                            <th class="w-120">다운로드</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="f" items="${claimFiles}">
                                            <tr>
                                                <td><c:out value="${f.originalName}"/></td>
                                                <td><fmt:formatNumber value="${f.fileSize}" pattern="#,##0"/> B</td>
                                                <td><c:out value="${f.uploadedBy}"/></td>
                                                <td><fmt:formatDate value="${f.createdAt}" pattern="yyyy-MM-dd"/></td>
                                                <td>
                                                    <a class="btn btn-sm btn-outline-primary"
                                                       href="${ctx}/admin/claims/${claimsDTO.claimId}/files/${f.fileId}/download">
                                                        다운로드
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
            </div>

            <%-- 2) 상품정보 --%>
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
                      <strong>${contracts.productName}</strong>
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
                      <strong>${contracts.contractCoverage}</strong>
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 3) 관련자 정보 --%>
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

            <%-- 4) 계약 정보 --%>
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

            <%-- 버튼 영역 --%>
            <div class="btn-area">
                <div class="btn-row-right">
                    <a href="${ctx}/admin/claims/" class="btn btn-outline">
                        <i class="bi bi-list"></i> 목록
                    </a>

                    <%-- 완료/반려 상태에서는 심사/지급 불가 --%>
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


<%-- =========================================================
[지급 처리 모달]
- 상태 변경(PENDING/COMPLETED/REJECTED) + 지급정보(paidAmount/paidAt)
- submit: POST /admin/claims/{claimId}/update
========================================================= --%>

<div id="payModalBackdrop" class="modal-backdrop" aria-hidden="true"></div>

<div id="payModal" class="modal-sheet modal-sheet-sm" role="dialog" aria-modal="true" aria-labelledby="payModalTitle">
    <div class="modal-header">
        <div id="payModalTitle" class="modal-title">지급 처리</div>
        <button type="button" class="btn btn-outline modal-close" id="btnClosePayModal" aria-label="닫기">x</button>
    </div>

    <div class="modal-body">
        <form method="post" action="${ctx}/admin/claims/${claimsDTO.claimId}/update" id="decisionForm">
            <input type="hidden" name="claimId" value="${claimsDTO.claimId}"/>
            <input type="hidden" name="adminIdx" value="${claimsDTO.adminIdx}"/>

            <div class="modal-section-title">심사</div>

            <div class="decision-radio-row">
                <label class="decision-radio">
                    <input type="radio" name="status" value="PENDING" checked> 미처리
                </label>
                <label class="decision-radio">
                    <input type="radio" name="status" value="COMPLETED"> 승인
                </label>
                <label class="decision-radio">
                    <input type="radio" name="status" value="REJECTED"> 반려
                </label>
            </div>

            <div class="decision-grid">
                <div>
                    <div class="modal-section-title">지급금액</div>
                    <input type="number" name="paidAmount" class="form-control" placeholder="예: 300000">
                </div>
                <div>
                    <div class="modal-section-title">지급일</div>
                    <input type="date" name="paidAt" class="form-control">
                </div>
            </div>

            <div class="modal-footer">
                <button type="reset" class="btn btn-secondary" id="btnCancelDecision">재작성</button>
                <button type="submit" class="btn btn-warning">심사/지급 변경</button>
            </div>
        </form>
    </div>
</div>


<%-- Toast --%>
<c:if test="${not empty msg}">
    <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index:20000;">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 모달 토글: display로 간단 제어(프로젝트 공통 모달로 확장 가능)
    const btnPay = document.getElementById("btnPay");
    const payModal = document.getElementById("payModal");
    const payModalBackdrop = document.getElementById("payModalBackdrop");
    const btnClosePayModal = document.getElementById("btnClosePayModal");

    btnPay?.addEventListener("click", () => {
        payModal.style.display = "block";
        payModalBackdrop.style.display = "block";
    });

    function closePayModal() {
        payModal.style.display = "none";
        payModalBackdrop.style.display = "none";
    }

    btnClosePayModal?.addEventListener("click", closePayModal);
    payModalBackdrop?.addEventListener("click", closePayModal);
</script>

<script>
    // Toast 자동 표시: msgType이 error면 더 오래 노출
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
