<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 완료 - 신한EZ</title>
    <link rel="stylesheet" href="${ctx}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .result-container {
            max-width: 500px;
            margin: 80px auto;
            padding: 40px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success-icon {
            width: 80px;
            height: 80px;
            background: #d1e7dd;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
        }
        .success-icon i {
            font-size: 40px;
            color: #198754;
        }
        .result-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a2b4a;
            margin-bottom: 10px;
        }
        .result-message {
            color: #666;
            margin-bottom: 30px;
        }
        .result-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            text-align: left;
            margin-bottom: 30px;
        }
        .result-info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .result-info-row:last-child {
            border-bottom: none;
        }
        .result-info-label {
            color: #666;
        }
        .result-info-value {
            font-weight: 600;
            color: #1a2b4a;
        }
        .result-amount {
            color: #0d6efd;
            font-size: 20px;
        }
        .btn-group {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        .btn {
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #0d6efd;
            color: #fff;
        }
        .btn-primary:hover {
            background: #0b5ed7;
        }
        .btn-outline {
            background: #fff;
            border: 1px solid #dee2e6;
            color: #333;
        }
        .btn-outline:hover {
            background: #f8f9fa;
        }
        .receipt-link {
            margin-top: 20px;
        }
        .receipt-link a {
            color: #0d6efd;
            font-size: 14px;
        }
    </style>
</head>
<body style="background: #f4f6f9;">

<div class="result-container">
    <div class="success-icon">
        <i class="bi bi-check-lg"></i>
    </div>
    <h2 class="result-title">결제가 완료되었습니다</h2>
    <p class="result-message">보험료가 정상적으로 납부되었습니다.</p>

    <div class="result-info">
        <div class="result-info-row">
            <span class="result-info-label">주문번호</span>
            <span class="result-info-value">${response.orderId}</span>
        </div>
        <div class="result-info-row">
            <span class="result-info-label">결제수단</span>
            <span class="result-info-value">${response.method}</span>
        </div>
        <div class="result-info-row">
            <span class="result-info-label">결제금액</span>
            <span class="result-info-value result-amount">
                <fmt:formatNumber value="${response.totalAmount}" type="number"/>원
            </span>
        </div>
        <div class="result-info-row">
            <span class="result-info-label">결제상태</span>
            <span class="result-info-value" style="color:#198754;">
                <i class="bi bi-check-circle-fill"></i> 승인완료
            </span>
        </div>
    </div>

    <div class="btn-group">
        <a href="${ctx}/" class="btn btn-primary">홈으로</a>
        <a href="${ctx}/mypage/contract" class="btn btn-outline">납입내역 확인</a>
    </div>

    <c:if test="${not empty response.receiptUrl}">
    <div class="receipt-link">
        <a href="${response.receiptUrl}" target="_blank">
            <i class="bi bi-receipt"></i> 영수증 보기
        </a>
    </div>
    </c:if>
</div>

</body>
</html>
