<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head id="inc-head">
    <%@ include file="/WEB-INF/views/inc/head.jsp" %>
    <style>
        .product-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 180px 20px 60px 20px;
        }
        .product-header {
            text-align: center;
            margin-bottom: 50px;
        }
        .product-header h2 {
            font-size: 36px;
            font-weight: 700;
            color: #1a2b4a;
            margin-bottom: 15px;
        }
        .product-header p {
            color: #666;
            font-size: 18px;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
        }
        .product-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
        }
        .product-card-header {
            background: linear-gradient(135deg, #1a2b4a 0%, #2d4263 100%);
            color: #fff;
            padding: 25px;
        }
        .product-category {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 13px;
            margin-bottom: 10px;
        }
        .product-name {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 5px;
            color: #fff;
        }
        .product-card-body {
            padding: 25px;
        }
        .product-coverage {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 20px;
            min-height: 60px;
        }
        .product-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .product-price {
            font-size: 14px;
            color: #666;
        }
        .product-price .amount {
            display: block;
            font-size: 24px;
            font-weight: 700;
            color: #0d6efd;
        }
        .btn-detail {
            display: inline-block;
            padding: 12px 25px;
            background: #0d6efd;
            color: #fff;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: background 0.2s;
        }
        .btn-detail:hover {
            background: #0b5ed7;
            color: #fff;
        }
        .empty-products {
            text-align: center;
            padding: 80px 20px;
            color: #999;
        }
        .empty-products i {
            font-size: 64px;
            margin-bottom: 20px;
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
            <div class="product-container">
                <div class="product-header">
                    <h2>보험상품 추천</h2>
                    <p>나에게 딱 맞는 보험상품을 찾아보세요</p>
                </div>

                <c:choose>
                    <c:when test="${not empty products}">
                        <div class="product-grid">
                            <c:forEach var="p" items="${products}">
                                <div class="product-card">
                                    <div class="product-card-header">
                                        <span class="product-category">${p.category}</span>
                                        <h3 class="product-name">${p.productName}</h3>
                                    </div>
                                    <div class="product-card-body">
                                        <p class="product-coverage">${p.coverageRange}</p>
                                        <div class="product-info">
                                            <div class="product-price">
                                                월 보험료
                                                <span class="amount"><fmt:formatNumber value="${p.basePremium}" type="number"/>원</span>
                                            </div>
                                            <a href="${ctx}/product/detail/${p.productNo}" class="btn-detail">
                                                상세보기
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-products">
                            <i class="bi bi-box-seam"></i>
                            <p>등록된 보험상품이 없습니다.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>

        <footer id="footer" class="footer">
            <%@ include file="/WEB-INF/views/inc/footer.jsp" %>
        </footer>
    </div>
</div>
</body>
</html>
