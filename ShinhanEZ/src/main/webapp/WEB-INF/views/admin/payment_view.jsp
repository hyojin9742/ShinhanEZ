<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <link rel="stylesheet" href="${ctx}/css/admin/payment.css">
</head>
<body class="admin-page">
<div class="admin-wrapper">
    
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="payment"/>
    </jsp:include>
    
    <div class="admin-main">
        
        <jsp:include page="inc/header.jsp"/>
        
        <main class="admin-content">
            
            <div class="page-title-area">
                <h2 class="page-title">납입내역 상세</h2>
                <div>
                    <a href="${ctx}/admin/payment/edit/${payment.paymentId}" class="btn btn-warning">수정</a>
                    <a href="${ctx}/admin/payment/delete/${payment.paymentId}" class="btn btn-danger" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                    <a href="${ctx}/admin/payment/list" class="btn btn-secondary">목록</a>
                </div>
            </div>
            
            <!-- 납입 정보 -->
            <div class="card">
                <div class="card-header">
                    <span>납입 정보</span>
                    <c:choose>
                        <c:when test="${payment.status == 'PAID'}">
                            <span class="badge badge-success">완료</span>
                        </c:when>
                        <c:when test="${payment.status == 'PENDING'}">
                            <span class="badge badge-warning">대기</span>
                        </c:when>
                        <c:when test="${payment.status == 'OVERDUE'}">
                            <span class="badge badge-danger">연체</span>
                        </c:when>
                    </c:choose>
                </div>
                <div class="card-body">
                    <table class="payment-info-table">
                        <tr>
                            <th>납입 ID</th>
                            <td>${payment.paymentId}</td>
                            <th>등록일</th>
                            <td><fmt:formatDate value="${payment.regDate}" pattern="yyyy-MM-dd"/></td>
                        </tr>
                        <tr>
                            <th>납입일</th>
                            <td>
                                <c:choose>
                                    <c:when test="${payment.paymentDate != null}">
                                        <fmt:formatDate value="${payment.paymentDate}" pattern="yyyy-MM-dd"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <th>납입기한</th>
                            <td><fmt:formatDate value="${payment.dueDate}" pattern="yyyy-MM-dd"/></td>
                        </tr>
                        <tr>
                            <th>납입 금액</th>
                            <td><strong class="payment-amount"><fmt:formatNumber value="${payment.amount}" pattern="#,###"/>원</strong></td>
                            <th>납입 방법</th>
                            <td>${payment.method}</td>
                        </tr>
                        <tr>
                            <th>계약 ID</th>
                            <td colspan="3">${payment.contractId}</td>
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
