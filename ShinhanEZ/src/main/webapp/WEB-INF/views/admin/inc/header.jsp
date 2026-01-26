<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctx = request.getContextPath(); %>

<!-- 상단 헤더 -->
<header class="admin-header">
    <div class="header-search">
        <i class="bi bi-search"></i>
        <input type="text" placeholder="검색어를 입력하세요">
    </div>
    
    <div class="header-right">
        <div class="header-icons">
            <a href="#" title="설정"><i class="bi bi-gear"></i></a>
            <a href="#" title="알림"><i class="bi bi-bell"></i></a>
            <a href="<%=ctx%>/index.jsp" title="사이트 이동"><i class="bi bi-house"></i></a>
        </div>
        <div class="header-user">
            <i class="bi bi-person-circle"></i>
            <c:choose>
                <c:when test="${sessionScope.adminRole == 'super'}">
                    <span>${sessionScope.adminName}(관리자)님</span>
                </c:when>
                <c:when test="${sessionScope.adminRole == 'manager'}">
                    <span>${sessionScope.adminName}(매니저)님</span>
                </c:when>
                <c:otherwise>
                    <span>${sessionScope.adminName}(스태프)님</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
