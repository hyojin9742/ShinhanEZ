<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <link rel="stylesheet" href="${ctx}/css/admin/contract.css">
    <script src="${ctx}/js/jquery-3.7.1.min.js"></script>
    <script src="${ctx}/js/admin/contractAjaxModule.js"></script>
    <script src="${ctx}/js/admin/contract.js"></script>
</head>
<body class="admin-page">
<div class="admin-wrapper">
    
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="contract"/>
    </jsp:include>
    
    <div class="admin-main">
        
        <jsp:include page="inc/header.jsp"/>
        
        <main class="admin-content">
            
            <div class="page-title-area">
                <h2 class="page-title">계약 상세내역</h2>
                <div>
                    <a href="#" class="btn btn-warning">수정</a>
                    <a href="${ctx}/admin/contract/list" class="btn btn-secondary">목록</a>
                </div>
            </div>
            
            <!-- 계약 정보 -->
            <div class="card">
                <div class="card-header">
                    <span>계약 정보</span>
                    <c:choose>
                        <c:when test="${contract.contractStatus == '활성'}">
                            <span class="badge badge-success">활성</span>
                        </c:when>
                        <c:when test="${contract.contractStatus == '만료'}">
                            <span class="badge badge-warning">만료</span>
                        </c:when>
                        <c:when test="${contract.contractStatus == '해지'}">
                            <span class="badge badge-danger">해지</span>
                        </c:when>
                    </c:choose>
                </div>
                <div class="card-body">
                    <table class="payment-info-table">
                        <tr>
                            <th>계약 ID</th>
                            <td colspan="3">${contract.contractId }</td>
                        </tr>
                        <tr>
                        	<th>계약자 번호</th>
                        	<td>${contract.customerId }</td>
                            <th>계약자 이름</th>
                            <td>${contract.customerName }</td>
                        </tr>
                        <tr>
                            <th>피보험자 번호</th>
                            <td>${contract.insuredId }</td>
                            <th>피보험자 이름</th>
                            <td>${contract.insuredName }</td>
                        </tr>
                        <tr>
                            <th>보험 번호</th>
                            <td>${contract.productId }</td>
                            <th>보험 상품명</th>
                            <td>${contract.productName }</td>
                        </tr>
                        <tr>
                            <th>보장내역</th>
                            <td colspan="5">${contract.contractCoverage }</td>
                        </tr>
                        <tr>
                            <th>계약일</th>
                            <td><fmt:formatDate value="${contract.regDate }" pattern="yyyy-MM-dd"/></td>
                            <th>만료일</th>
                            <td><fmt:formatDate value="${contract.expiredDate }" pattern="yyyy-MM-dd"/></td>
                        </tr>
                        <tr>
                        	<th>보험료</th>
                        	<td>${contract.premiumAmount }</td>
                        	<th>납입주기</th>
                        	<td>${contract.paymentCycle }</td>
                        </tr>
                        <tr>
                        	<th>관리자 번호</th>
                        	<td>${contract.adminIdx }</td>
                        	<th>관리자 이름</th>
                        	<td>${contract.adminName }</td>
                        </tr>
                        <tr>
                        	<th>수정일자</th>
                        	<td colspan="3"><fmt:formatDate value="${contract.updateDate }" pattern="yyyy-MM-dd"/></td>
                        </tr>
                    </table>
                </div>
            </div>
            
        </main>
        
        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>
</body>
</html>
