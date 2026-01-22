<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- 사이드바 -->
<aside class="admin-sidebar">
    <!-- 로고 -->
    <div class="sidebar-logo">
        <a href="${ctx}/admin">
            <img src="${ctx}/images/logo-shez-w.svg" alt="신한EZ손해보험" class="logo-img">
        </a>
    </div>
    
    <!-- 메뉴 -->
    <ul class="sidebar-menu">
        <li>
            <a href="${ctx}/admin" class="${param.menu == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2"></i> 대시보드
            </a>
        </li>
        
        <div class="sidebar-divider"></div>
        
        <li>
            <a href="${ctx}/admin/customer/list" class="${param.menu == 'customer' ? 'active' : ''}">
                <i class="bi bi-people"></i> 고객관리
            </a>
        </li>
        <li>
            <a href="${ctx}/admin/insurance/list" class="${param.menu == 'Insurance' ? 'active' : ''}">
                <i class="bi bi-box-seam"></i> 상품관리
            </a>
        </li>
        <li>
            <a href="/admin/contract/list" class="${param.menu == 'contract' ? 'active' : ''}">
                <i class="bi bi-file-earmark-text"></i> 계약관리
            </a>
        </li>
        <li>
            <a href="${ctx}/admin/claims" class="${param.menu == 'claims' ? 'active' : ''}">
                <i class="bi bi-clipboard-check"></i> 청구관리
            </a>
        </li>
        <li>
            <a href="${ctx}/admin/payment/list" class="${param.menu == 'payment' ? 'active' : ''}">
                <i class="bi bi-credit-card"></i> 납입내역
            </a>
        </li>
        <li>
            <a href="#" class="${param.menu == 'notice' ? 'active' : ''}">
                <i class="bi bi-megaphone"></i> 공지사항
            </a>
        </li>
        
        <div class="sidebar-divider"></div>
        <div class="sidebar-section-title">관리자 설정</div>
        
        <li>
            <a href="/admin/employee" class="${param.menu == 'system' ? 'active' : ''}">
                <i class="bi bi-gear"></i> 관리자 목록
            </a>
        </li>
    </ul>
    
    <!-- 하단 -->
    <div class="sidebar-bottom">
        <a href="${ctx}/" target="_blank"><i class="bi bi-house"></i> 사이트 바로가기</a>
        <a href="${ctx}/member/logout" class="logout-btn">
            <i class="bi bi-box-arrow-right"></i> 로그아웃
        </a>
    </div>
</aside>
