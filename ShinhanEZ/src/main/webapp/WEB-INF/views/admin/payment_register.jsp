<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<jsp:useBean id="now" class="java.util.Date" />
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
                <h2 class="page-title">납입내역 등록</h2>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <span>납입 정보 입력</span>
                </div>
                <div class="card-body">
                    <form action="${ctx}/admin/payment/register" method="post">
                        <div class="payment-form">
                            <div>
                                <div class="form-group">
                                    <label class="form-label">계약 ID *</label>
                                    <input type="number" class="form-control" name="contractId" placeholder="계약 ID 입력" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">납입일</label>
                                    <input type="date" class="form-control" name="paymentDate" value="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">납입기한 *</label>
                                    <input type="date" class="form-control" name="dueDate" value="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>" required>
                                </div>
                            </div>
                            <div>
                                <div class="form-group">
                                    <label class="form-label">납입 금액 *</label>
                                    <input type="number" class="form-control" name="amount" placeholder="금액 입력" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">납입 방법</label>
                                    <select class="form-select full-width" name="method">
                                        <option value="자동이체">자동이체</option>
                                        <option value="카드">카드</option>
                                        <option value="계좌이체">계좌이체</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">납입 상태</label>
                                    <div class="radio-group">
                                        <label><input type="radio" name="status" value="PENDING" checked> 대기</label>
                                        <label><input type="radio" name="status" value="PAID"> 완료</label>
                                        <label><input type="radio" name="status" value="OVERDUE"> 연체</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="btn-area">
                            <button type="submit" class="btn btn-primary">등록</button>
                            <button type="reset" class="btn btn-outline">초기화</button>
                            <a href="${ctx}/admin/payment/list" class="btn btn-secondary">목록</a>
                        </div>
                    </form>
                </div>
            </div>
            
        </main>
        
        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>
</body>
</html>
