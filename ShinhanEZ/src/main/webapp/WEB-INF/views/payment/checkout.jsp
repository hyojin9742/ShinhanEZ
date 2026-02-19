<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제하기 - 신한EZ</title>
    <link rel="stylesheet" href="${ctx}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .payment-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .payment-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .payment-header h2 {
            color: #1a2b4a;
            margin-bottom: 10px;
        }
        .payment-header p {
            color: #666;
        }
        .payment-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
        }
        .payment-info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .payment-info-row:last-child {
            border-bottom: none;
        }
        .payment-info-label {
            color: #666;
        }
        .payment-info-value {
            font-weight: 600;
            color: #1a2b4a;
        }
        .payment-amount {
            font-size: 24px;
            color: #0d6efd;
        }
        .payment-methods {
            margin-bottom: 25px;
        }
        .payment-methods h4 {
            margin-bottom: 15px;
            color: #1a2b4a;
        }
        .method-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px 20px;
            border: 2px solid #dee2e6;
            border-radius: 10px;
            background: #fff;
            cursor: pointer;
            transition: all 0.2s;
            margin-bottom: 10px;
            width: 100%;
        }
        .method-btn:hover {
            border-color: #0d6efd;
            background: #f8f9ff;
        }
        .method-btn.active {
            border-color: #0d6efd;
            background: #e7f1ff;
        }
        .method-btn i {
            font-size: 24px;
            color: #0d6efd;
        }
        .method-btn span {
            font-size: 16px;
            font-weight: 500;
        }
        .btn-pay {
            width: 100%;
            padding: 15px;
            font-size: 18px;
            font-weight: 600;
            background: #0d6efd;
            color: #fff;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-pay:hover {
            background: #0b5ed7;
        }
        .btn-pay:disabled {
            background: #6c757d;
            cursor: not-allowed;
        }
        .secure-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 20px;
            color: #198754;
            font-size: 14px;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #666;
            cursor: pointer;
        }
    </style>
</head>
<body style="background: #f4f6f9;">

<div class="payment-container">
    <div class="payment-header">
        <h2><i class="bi bi-shield-check"></i> 안전한 결제</h2>
        <p>토스페이먼츠를 통한 안전한 결제 서비스</p>
    </div>

    <!-- 결제 정보 -->
    <div class="payment-info">
        <div class="payment-info-row">
            <span class="payment-info-label">주문번호</span>
            <span class="payment-info-value">${orderId}</span>
        </div>
        <div class="payment-info-row">
            <span class="payment-info-label">상품명</span>
            <span class="payment-info-value">${orderName}</span>
        </div>
        <div class="payment-info-row">
            <span class="payment-info-label">결제금액</span>
            <span class="payment-info-value payment-amount">
                <fmt:formatNumber value="${amount}" type="number"/>원
            </span>
        </div>
    </div>

    <!-- 결제 수단 선택 -->
    <div class="payment-methods">
        <h4>결제 수단 선택</h4>
        <button type="button" class="method-btn active" data-method="카드">
            <i class="bi bi-credit-card"></i>
            <span>신용/체크카드</span>
        </button>
        <button type="button" class="method-btn" data-method="계좌이체">
            <i class="bi bi-bank"></i>
            <span>계좌이체</span>
        </button>
        <button type="button" class="method-btn" data-method="가상계좌">
            <i class="bi bi-wallet2"></i>
            <span>가상계좌</span>
        </button>
    </div>

    <!-- 결제 버튼 -->
    <button type="button" id="payment-button" class="btn-pay">
        <fmt:formatNumber value="${amount}" type="number"/>원 결제하기
    </button>

    <div class="secure-badge">
        <i class="bi bi-lock-fill"></i>
        <span>토스페이먼츠 보안 결제</span>
    </div>

    <a class="back-link" id="back-btn">
        <i class="bi bi-arrow-left"></i> 돌아가기
    </a>
</div>

<!-- 토스페이먼츠 SDK -->
<script src="https://js.tosspayments.com/v1/payment"></script>
<script>
    // 토스페이먼츠 클라이언트 초기화
    var clientKey = '${clientKey}';
    var tossPayments = TossPayments(clientKey);

    // 결제 수단 선택
    var selectedMethod = '카드';
    document.querySelectorAll('.method-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.method-btn').forEach(function(b) {
                b.classList.remove('active');
            });
            this.classList.add('active');
            selectedMethod = this.getAttribute('data-method');
        });
    });

    // 결제 버튼 클릭
    document.getElementById('payment-button').addEventListener('click', function() {
        var orderId = '${orderId}';
        var amount = ${amount};
        var orderName = '${orderName}';
        var successUrl = '${successUrl}';
        var failUrl = '${failUrl}';

        // 결제 수단에 따른 결제 요청
        var paymentMethodType = 'CARD';
        if (selectedMethod === '계좌이체') {
            paymentMethodType = 'TRANSFER';
        } else if (selectedMethod === '가상계좌') {
            paymentMethodType = 'VIRTUAL_ACCOUNT';
        }

        tossPayments.requestPayment(paymentMethodType, {
            amount: amount,
            orderId: orderId,
            orderName: orderName,
            successUrl: successUrl,
            failUrl: failUrl
        }).catch(function(error) {
            if (error.code === 'USER_CANCEL') {
                alert('결제가 취소되었습니다.');
            } else {
                alert('결제 오류: ' + error.message);
            }
        });
    });
    
 	// 돌아가기 버튼 클릭
    document.getElementById('back-btn').addEventListener('click', function(e) {
        e.preventDefault();
        history.back();
    });

</script>

</body>
</html>
