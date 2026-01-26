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

<!-- 관리자 세션 타임아웃 (10분 무활동시 세션 종료) -->
<script>
(function() {
    var sessionTimeout = 10 * 60 * 1000; // 10분
    var logoutTimer;
    var ctx = '<%=ctx%>';

    function resetTimer() {
        clearTimeout(logoutTimer);

        // 10분 후 알림 및 로그아웃
        logoutTimer = setTimeout(function() {
            alert('10분간 입력이 없어 세션이 종료됩니다.');
            window.location.href = ctx + '/member/logout';
        }, sessionTimeout);
    }

    // 사용자 활동 감지 (입력 관련만)
    document.addEventListener('keydown', resetTimer);
    document.addEventListener('click', resetTimer);

    // 초기화
    resetTimer();
})();
</script>
