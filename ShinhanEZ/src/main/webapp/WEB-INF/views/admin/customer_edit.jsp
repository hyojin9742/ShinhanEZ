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
    
    <!-- 사이드바 -->
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="customer"/>
    </jsp:include>
    
    <!-- 메인 영역 -->
    <div class="admin-main">
        
        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="고객 수정"/>
        </jsp:include>
        
        <!-- 콘텐츠 -->
        <main class="admin-content">
            
            <!-- 페이지 타이틀 -->
            <div class="page-header">
                <h2>고객 정보 수정</h2>
                <p>고객(보험자) 정보를 수정합니다.</p>
            </div>

            <!-- 수정 폼 카드 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-pencil-square"></i> 고객 정보 수정</span>
                </div>
                <div class="card-body">
                    <form action="${ctx}/admin/customer/edit" method="post" class="admin-form">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>고객 ID</label>
                                <input type="text" name="customerId" value="${customer.customerId}" 
                                       class="form-control" readonly>
                                <small>고객 ID는 수정할 수 없습니다.</small>
                            </div>
                            <div class="form-group">
                                <label>이름 <span class="required">*</span></label>
                                <input type="text" name="name" value="${customer.name}" 
                                       class="form-control" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>생년월일 <span class="required">*</span></label>
                                <input type="date" name="birthDate" 
                                       value="<fmt:formatDate value='${customer.birthDate}' pattern='yyyy-MM-dd'/>" 
                                       class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>성별 <span class="required">*</span></label>
                                <div class="radio-group">
                                    <label class="radio-label">
                                        <input type="radio" name="gender" value="M" 
                                               <c:if test="${customer.gender == 'M'}">checked</c:if>>
                                        <span>남성</span>
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="gender" value="F" 
                                               <c:if test="${customer.gender == 'F'}">checked</c:if>>
                                        <span>여성</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>연락처 <span class="required">*</span></label>
                                <input type="text" name="phone" value="${customer.phone}" 
                                       class="form-control" placeholder="010-0000-0000" required>
                            </div>
                            <div class="form-group">
                                <label>이메일</label>
                                <input type="email" name="email" value="${customer.email}" 
                                       class="form-control" placeholder="email@example.com">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group full">
                                <label>주소</label>
                                <input type="text" name="address" value="${customer.address}" 
                                       class="form-control" placeholder="주소를 입력하세요">
                            </div>
                        </div>
                        
                        <!-- 버튼 영역 -->
                        <div class="btn-area">
                            <a href="${ctx}/admin/customer/list" class="btn btn-outline">
                                <i class="bi bi-x-lg"></i> 취소
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg"></i> 수정 완료
                            </button>
                        </div>
                        
                    </form>
                </div>
            </div>
            
        </main>
        
        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>
        
    </div>
</div>
</body>
</html>
