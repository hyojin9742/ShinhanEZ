<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 실패 - 신한EZ</title>
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
        .fail-icon {
            width: 80px;
            height: 80px;
            background: #f8d7da;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
        }
        .fail-icon i {
            font-size: 40px;
            color: #dc3545;
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
        .error-info {
            background: #fff3cd;
            padding: 15px 20px;
            border-radius: 10px;
            text-align: left;
            margin-bottom: 30px;
            border: 1px solid #ffecb5;
        }
        .error-code {
            font-size: 14px;
            color: #664d03;
            margin-bottom: 5px;
        }
        .error-message {
            color: #664d03;
            font-weight: 500;
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
        .help-text {
            margin-top: 25px;
            font-size: 14px;
            color: #666;
        }
        .help-text a {
            color: #0d6efd;
        }
    </style>
</head>
<body style="background: #f4f6f9;">

<div class="result-container">
    <div class="fail-icon">
        <i class="bi bi-x-lg"></i>
    </div>
    <h2 class="result-title">결제에 실패했습니다</h2>
    <p class="result-message">결제 처리 중 문제가 발생했습니다.</p>

    <c:if test="${not empty errorCode || not empty errorMessage}">
    <div class="error-info">
        <c:if test="${not empty errorCode}">
        <div class="error-code">
            <strong>오류 코드:</strong> ${errorCode}
        </div>
        </c:if>
        <div class="error-message">
            <i class="bi bi-exclamation-triangle"></i>
            ${not empty errorMessage ? errorMessage : '알 수 없는 오류가 발생했습니다.'}
        </div>
    </div>
    </c:if>

    <div class="btn-group">
        <a href="javascript:history.back();" class="btn btn-primary">다시 시도</a>
        <a href="${ctx}/" class="btn btn-outline">홈으로</a>
    </div>

    <p class="help-text">
        문제가 계속되면 <a href="${ctx}/support">고객센터</a>로 문의해 주세요.
    </p>
</div>

</body>
</html>
