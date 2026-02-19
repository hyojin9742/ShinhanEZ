<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head id="inc-head">
    <%@ include file="/WEB-INF/views/inc/head.jsp" %>
    <link rel="stylesheet" href="${ctx }/css/product_detail.css">
    <script src="${ctx }/js/product_detail.js"></script>
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
                            <li data-coverage="${product.coverageRange}"><i class="bi bi-check-circle-fill"></i> ${product.coverageRange}</li>
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
                    <a class="btn-subscribe">
                        <i class="bi bi-credit-card"></i> 가입하기
                    </a>
                </div>
            </div>
           	<!-- 모달 -->
            <div class="modal-overlay" id="contractModalOverlay"></div>
	        <div class="modal modal-lg" id="contractModal">
	            <div class="modal-header">
	                <h3 class="modal-title">계약 등록</h3>
	                <button class="modal-close" id="closeContractModal">&times;</button>
	            </div>
	            <div class="modal-body">
	                <form id="contractForm" class="modal-form">
	                    <div class="modal-grid">
	                    	<input type="hidden" name="loginId" id="loginId" />
	                        <div class="form-group">
	                            <label class="form-label">계약자명 <span>*</span></label>
	                            <input type="text" class="form-control" name="customerName" id="customerName" autocomplete="off" readonly>
	                            <input type="hidden" id="customerId" name="customerId">
	                        </div>
                        	<div class="form-group">
                        		<label class="form-label">성별 <span>*</span></label>
	                        	<ul class="gender">
									<li>
										<input type="radio" name="gender" id="gen_male" value="M" readonly>
										<label for="gen_male">남자</label>
									</li>
									<li>
										<input type="radio" name="gender" id="gen_female" value="F" readonly>
										<label for="gen_female">여자</label>
									</li>
								</ul>
                        	</div>
                        	<div class="form-group">
	                        	<label class="form-label">생년월일<span>*</span></label>
	                            <input type="date" class="form-control" name="birth_date" id="birth_date" autocomplete="off" readonly>
                        	</div>
                        	<div class="form-group">
	                        	<label class="form-label">핸드폰<span>*</span></label>
	                            <input type="tel" class="form-control" name="phone" id="phone" autocomplete="off" readonly>
                        	</div>
                        	<div class="form-group">
	                        	<label class="form-label">이메일<span>*</span></label>
	                            <input type="text" class="form-control" name="email" id="email" autocomplete="off" required>
                        	</div>
                        	<div class="form-group">
	                        	<label class="form-label">주소<span>*</span></label>
	                            <input type="text" class="form-control" name="address" id="address" autocomplete="off" required>
                        	</div>
	                        <div class="form-group">
	                            <label class="form-label">상품명 <span>*</span></label>
	                            <input type="text" class="form-control"  name="productName" id="productName" autocomplete="off" value="${product.productName }" readonly>
	                            <input type="hidden" id="productId" name="productId" value="${product.productNo }" readonly>
	                        </div>
	                        <div class="form-group">
	                        	<label class="form-label">보장내용 <span>*</span></label>
	                        	<input type="hidden" name="contractCoverage" value="주계약"/>
	                        	<input type="checkbox" value="주계약" checked disabled/>주계약 <span>*</span>
	                        	<div class="riderList"></div>
                        	</div>
	                        <div class="form-group">
	                            <label class="form-label">계약일 <span>*</span></label>
	                            <input type="date" class="form-control" name="regDate" id="regDate" required>
	                        </div>
	                        <div class="form-group">
	                            <label class="form-label">만료일 <span>*</span></label>
	                            <input type="date" class="form-control" name="expiredDate" id="expiredDate" required>
	                        </div>
	                        <div class="form-group">
	                        	<label class="form-label">보험료 <span>*</span></label>
	                        	<input type="number" class="form-control" name="premiumAmount" id="premiumAmount" value="${product.basePremium}" data-base-premium="${product.basePremium}">
	                        </div>
	                        <div class="form-group">
	                        	<label class="form-label">납부주기 <span>*</span></label>
	                        	<select class="form-control" name="paymentCycle" id="paymentCycle" required>
	                                <option value="">주기 선택</option>
	                                <option value="월납">월납</option>
	                                <option value="분기납">분기납</option>
	                                <option value="반기납">반기납</option>
	                                <option value="연납">연납</option>
	                                <option value="일시납">일시납</option>
	                            </select>
	                        </div>
	                    </div>
                        <div class="form-group">
                            <label class="form-label">피보험자 선택<span>*</span></label>
                            <select class="form-control" name="insuredType" id="insuredType" required>
                            	<option value="self" selected>본인</option>
                            	<option value="other">본인 외</option>
                            </select>
                        </div>
                        <div class="form-group extraInsuredInfo">
               				<input type="hidden" name="insuredName" id="insuredName"/>                 
	        				<input type="hidden" name="insuredId" id="insuredId"/> 
                        </div>
			            <div class="signCanvasDiv">
			            	<canvas id="signCanvas" width="742" height="150" style="border: 1px solid #dee2e6;border-radius: 15px;"></canvas>
			            	<div class="validSign">
				            	<p>※ 본인은 위 이름을 서명하였음을 확인합니다 <input type="text" name="signName" id="signName" /></p>
								<div class="canvasBtn">
									<button class="btn reset-sign">지우기</button>
									<button class="btn submit-sign">서명 완료</button>
								</div>
			            	</div>
							<input type="hidden" id="signImage" name="signImage">
			            </div>
	                </form>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-outline" id="cancelContract">취소</button>
	                <button type="button" class="btn btn-primary registerContract" id="saveContract">
	                    가입
	                </button>
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
