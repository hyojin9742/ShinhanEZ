<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head id="inc-head">
    <%@ include file="/WEB-INF/views/inc/head.jsp" %>
    <style>
        .detail-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 180px 20px 60px 20px;
        }
        .detail-header {
            background: linear-gradient(135deg, #1a2b4a 0%, #2d4263 100%);
            color: #fff;
            padding: 50px 40px;
            border-radius: 20px;
            margin-bottom: 30px;
        }
        .detail-category {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .detail-name {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #fff !important;
        }
        .detail-price-wrap {
            display: flex;
            align-items: baseline;
            gap: 10px;
            margin-top: 20px;
        }
        .detail-price-label {
            font-size: 16px;
            opacity: 0.8;
        }
        .detail-price {
            font-size: 36px;
            font-weight: 700;
            color: #ffc107;
        }
        .detail-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        .detail-card-header {
            padding: 20px 25px;
            border-bottom: 1px solid #eee;
            font-size: 18px;
            font-weight: 600;
            color: #1a2b4a;
        }
        .detail-card-header i {
            margin-right: 10px;
            color: #0d6efd;
        }
        .detail-card-body {
            padding: 25px;
        }
        .info-row {
            display: flex;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            width: 150px;
            color: #666;
            font-weight: 500;
        }
        .info-value {
            flex: 1;
            color: #333;
        }
        .coverage-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .coverage-list li {
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
        }
        .coverage-list li:last-child {
            border-bottom: none;
        }
        .coverage-list li i {
            color: #198754;
            margin-right: 12px;
            font-size: 18px;
        }
        .btn-group-detail {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .btn-subscribe {
            flex: 1;
            padding: 18px 30px;
            background: #0d6efd;
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            text-align: center;
            text-decoration: none;
        }
        .btn-subscribe:hover {
            background: #0b5ed7;
            color: #fff;
        }
        .btn-back {
            padding: 18px 30px;
            background: #fff;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
        }
        .btn-back:hover {
            background: #f8f9fa;
        }
        .notice-box {
            background: #fff3cd;
            border: 1px solid #ffecb5;
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
        }
        .notice-box h4 {
            color: #664d03;
            margin-bottom: 10px;
            font-size: 16px;
        }
        .notice-box p {
            color: #664d03;
            font-size: 14px;
            margin: 0;
        }
    </style>
</head>
<body class="sub">
<div id="wrap">
    <div id="page">
        <header id="header" class="header">
            <%@ include file="/WEB-INF/views/inc/header.jsp" %>
        </header>

        <main id="main">
            <div class="detail-container">
                <!-- 상품 헤더 -->
                <div class="detail-header">
                    <span class="detail-category">${product.category}</span>
                    <h1 class="detail-name">${product.productName}</h1>
                    <div class="detail-price-wrap">
                        <span class="detail-price-label">월 보험료</span>
                        <span class="detail-price"><fmt:formatNumber value="${product.basePremium}" type="number"/>원</span>
                    </div>
                </div>

                <!-- 상품 정보 -->
                <div class="detail-card">
                    <div class="detail-card-header">
                        <i class="bi bi-info-circle"></i> 상품 정보
                    </div>
                    <div class="detail-card-body">
                        <div class="info-row">
                            <span class="info-label">상품명</span>
                            <span class="info-value">${product.productName}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">분류</span>
                            <span class="info-value">${product.category}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">보장기간</span>
                            <span class="info-value">${product.coveragePeriod}개월</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">월 보험료</span>
                            <span class="info-value" style="color:#0d6efd; font-weight:600;">
                                <fmt:formatNumber value="${product.basePremium}" type="number"/>원
                            </span>
                        </div>
                    </div>
                </div>

                <!-- 보장 내용 -->
                <div class="detail-card">
                    <div class="detail-card-header">
                        <i class="bi bi-shield-check"></i> 보장 내용
                    </div>
                    <div class="detail-card-body">
                        <ul class="coverage-list">
                            <li><i class="bi bi-check-circle-fill"></i> ${product.coverageRange}</li>
                            <li><i class="bi bi-check-circle-fill"></i> 24시간 사고 접수 서비스</li>
                            <li><i class="bi bi-check-circle-fill"></i> 전문 상담원 1:1 상담</li>
                            <li><i class="bi bi-check-circle-fill"></i> 빠른 보험금 지급</li>
                        </ul>
                    </div>
                </div>

                <!-- 가입 안내 -->
                <div class="notice-box">
                    <h4><i class="bi bi-exclamation-triangle"></i> 가입 전 확인사항</h4>
                    <p>본 상품은 보험계약 체결 전 반드시 상품설명서 및 약관을 확인하시기 바랍니다.<br>
                    보험계약 청약 시 보험료 결제가 진행됩니다.</p>
                </div>

                <!-- 버튼 그룹 -->
                <div class="btn-group-detail">
                    <a href="${ctx}/product/list" class="btn-back">
                        <i class="bi bi-arrow-left"></i> 목록으로
                    </a>
                    <a href="${ctx}/product/subscribe/${product.productNo}" class="btn-subscribe">
                        <i class="bi bi-credit-card"></i> 가입하기
                    </a>
                </div>
            </div>
        </main>

        <footer id="footer" class="footer">
            <%@ include file="/WEB-INF/views/inc/footer.jsp" %>
        </footer>
    </div>
    <button type="button" id="btn-page-top"><span class="sr-only">상단으로 이동</span></button>
</div>

<div id="sitemap" class="sitemapArea">
    <%@ include file="/WEB-INF/views/inc/sitemap.jsp" %>
</div>
</body>
</html>
