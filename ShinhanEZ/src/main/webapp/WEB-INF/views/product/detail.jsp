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
		/* ============================================
		   가입 모달
		   ============================================ */
		   
		/* 모달 오버레이 */
		.modal-overlay {
		    display: none;
		    position: fixed;
		    top: 0;
		    left: 0;
		    width: 100%;
		    height: 100%;
		    background: rgba(0, 0, 0, 0.5);
		    z-index: 1000;
		    animation: fadeIn 0.3s ease;
		}
		
		.modal-overlay.active {
		    display: block;
		}
		
		/* 모달 컨테이너 */
		.modal {
		    display: none;
		    position: fixed;
		    top: 50%;
		    left: 50%;
		    transform: translate(-50%, -50%);
		    background: var(--color-white);
		    border-radius: 10px;
		    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
		    z-index: 1001;
		    max-width: 90%;
		    max-height: 90vh;
		    overflow: hidden;
		    animation: slideUp 0.3s ease;
		}
		
		.modal.active {
		    display: block;
		}
		
		/* 모달 크기 */
		.modal-sm { width: 400px; }
		.modal-md { width: 600px; }
		.modal-lg { width: 800px; }
		.modal-xl { width: 1000px; }
		
		/* 모달 헤더 */
		.modal-header {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    padding: 20px 25px;
		    border-bottom: 1px solid #dee2e6;
		    background: #0d6efd;
		}
		.modal-header h3{
			color: var(--color-white);
		}
		
		.modal-title {
		    margin: 0;
		    font-size: 18px;
		    font-weight: 600;
		    color: var(--color-txt01);
		}
		
		.modal-close {
		    background: none;
		    border: none;
		    font-size: 24px;
		    color: var(--color-white);
		    cursor: pointer;
		    padding: 0;
		    width: 30px;
		    height: 30px;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    border-radius: 5px;
		    transition: all 0.2s ease;
		}
		
		.modal-close:hover {
		    background: #243754;
		    color: var(--color-white);
		}
		
		/* 모달 바디 */
		.modal-body {
		    padding: 25px;
		    max-height: calc(90vh - 150px);
		    overflow-y: auto;
		}
		
		.modal-body::-webkit-scrollbar {
		    width: 8px;
		}
		
		.modal-body::-webkit-scrollbar-track {
		    background: #f8f9fa;
		}
		
		.modal-body::-webkit-scrollbar-thumb {
		    background: #dee2e6;
		    border-radius: 4px;
		}
		
		.modal-body::-webkit-scrollbar-thumb:hover {
		    background: #6c757d;
		}
		
		/* 모달 푸터 */
		.modal-footer {
		    display: flex;
		    justify-content: flex-end;
		    gap: 10px;
		    padding: 15px 25px;
		    border-top: 1px solid #dee2e6;
		    background: #f8f9fa;
		}
		.modal-footer .btn-outline:hover {
			background: var(--color-white);
			
		}
		/* 모달 내부 폼 스타일 */
		.modal-form {
		    display: flex;
		    flex-direction: column;
		    gap: 20px;
		}
		.modal-form span {
			color: #f00;
		}
		
		.modal-form .form-group {
		    margin-bottom: 0;
		}
		
		.modal-form .form-label {
		    display: block;
		    margin-bottom: 8px;
		    font-weight: 500;
		    color: var(--color-txt01);
		}
		
		.modal-form .form-control {
		    width: 100%;
		    padding: 10px 12px;
		    border: 1px solid #dee2e6;
		    border-radius: 5px;
		    font-size: 14px;
		}
		
		.modal-form .form-control:focus {
		    outline: none;
		    border-color: #0d6efd;
		    box-shadow: 0 0 0 3px rgba(66, 133, 244, 0.1);
		}
		.modal-form .form-group input[type="checkbox"][disabled]{
			width: auto;
		}
		.form-group.extraInsuredInfo {grid-column: 1 / -1;}
		.form-group.extraInsuredInfo .infoInner {
    		display: none;
		}
		.form-group.extraInsuredInfo .infoInner {
			grid-column: 1 / 3;
			display: grid;
		    grid-template-columns: 1fr 1fr;
		    gap: 10px 20px;
	        border-top: 1px solid #dee2e6;
		    border-bottom: 1px solid #dee2e6;
		    padding: 15px 0;
		}
		.form-group.extraInsuredInfo .form-label {
			    grid-column: 1 / 3;
		}
		/* 모달 그리드 레이아웃 */
		.modal-grid {
		    display: grid;
		    grid-template-columns: 1fr 1fr;
		    gap: 20px;
		}
		
		.modal-grid .form-group.full-width {
		    grid-column: 1 / -1;
		}
		
		/* 모달 애니메이션 */
		@keyframes fadeIn {
		    from {
		        opacity: 0;
		    }
		    to {
		        opacity: 1;
		    }
		}
		
		@keyframes slideUp {
		    from {
		        opacity: 0;
		        transform: translate(-50%, -45%);
		    }
		    to {
		        opacity: 1;
		        transform: translate(-50%, -50%);
		    }
		}
		
		/* 반응형 처리 */
		@media (max-width: 768px) {
		    .modal {
		        width: 95% !important;
		        max-width: none;
		    }
		    
		    .modal-grid {
		        grid-template-columns: 1fr;
		    }
		    
		    .modal-header,
		    .modal-body,
		    .modal-footer {
		        padding: 15px 20px;
		    }
		}
		
		/* 모달 확인/취소 버튼 스타일 */
		.modal-footer .btn {
		    min-width: 80px;
		    display: inline-block;
		    padding: 11px 16px;
		    border-radius: 5px;
		    font-size: 14px;
		    font-weight: 500;
		    border: none;
		    cursor: pointer;
		    transition: all 0.2s;
		}
		.modal-footer .btn-outline {
		    background: transparent;
		    border: 1px solid #dee2e6;
		    color: var(--color-txt01);
		}
		.modal-footer .btn-primary {
		    background: #0d6efd;
		    color: var(--color-white);
		}
		/* 계약 모달 자동완성 */
		/* 자동완성 */
		#contractForm .form-group {
			position: relative;
		}
		.autocomplete-wrapper {
		    position: relative;
		}
		
		.autocomplete-results {
		    position: absolute;
		    top: 100%;
		    left: 0;
		    right: 0;
		    background: white;
		    border: 1px solid #ddd;
		    border-top: none;
		    border-radius: 0 0 4px 4px;
		    max-height: 200px;
		    overflow-y: auto;
		    z-index: 2000;
		    display: none;
		    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		}
		
		.autocomplete-results.active {
		    display: block !important;
		}
		
		.autocomplete-item {
		    padding: 10px 12px;
		    cursor: pointer;
		    border-bottom: 1px solid #f0f0f0;
		    display: flex;
		    align-items: center;
		}
		
		.autocomplete-item:hover {
		    background: #f5f5f5;
		}
		
		.autocomplete-item:last-child {
		    border-bottom: none;
		}
		
		.autocomplete-id {
		    width: 30%;
		    color: #666;
		    font-size: 13px;
		    padding-right: 10px;
		}
		
		.autocomplete-name {
		    width: 70%;
		    color: #333;
		    font-size: 14px;
		}
		.riderList {
			display: flex;
			flex-flow: wrap;
			gap: 10px;
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
	                        <div class="form-group">
	                            <label class="form-label">계약자명 <span>*</span></label>
	                            <input type="text" class="form-control" name="customerName" id="customerName" autocomplete="off" required>
	                            <input type="hidden" id="customerId" name="customerId">
	                        </div>
	                        <div class="form-group">
	                            <label class="form-label">피보험자 선택<span>*</span></label>
	                            <select class="form-control">
	                            	<option value="self" selected>본인</option>
	                            	<option value="other">타인</option>
	                            </select>
	                        </div>
	                        <div class="form-group extraInsuredInfo">
	                        	<div class="infoInner">
		                        	<label class="form-label">피보험자 추가정보</label>
		                        	<div class="form-group">
			                        	<label class="form-label">이름<span>*</span></label>
			                            <input type="text" class="form-control" name="insuredName" id="insuredName" autocomplete="off" required>
			                            <input type="hidden" id="insuredId" name="insuredId">
		                        	</div>
		                        	<div class="form-group">
			                        	<label class="form-label">성별<span>*</span></label>
			                            <input type="text" class="form-control" name="gender" id="gender" autocomplete="off" required>
		                        	</div>
		                        	<div class="form-group">
			                        	<label class="form-label">생년월일<span>*</span></label>
			                            <input type="date" class="form-control" name="birth_date" id="birth_date" autocomplete="off" required>
		                        	</div>
		                        	<div class="form-group">
			                        	<label class="form-label">핸드폰<span>*</span></label>
			                            <input type="tel" class="form-control" name="phone" id="phone" autocomplete="off" required>
		                        	</div>
		                        	<div class="form-group">
			                        	<label class="form-label">이메일<span>*</span></label>
			                            <input type="text" class="form-control" name="email" id="email" autocomplete="off" required>
		                        	</div>
		                        	<div class="form-group">
			                        	<label class="form-label">주소<span>*</span></label>
			                            <input type="text" class="form-control" name="address" id="address" autocomplete="off" required>
		                        	</div>
	                        	</div>
	                        </div>
	                        <div class="form-group">
	                            <label class="form-label">상품명 <span>*</span></label>
	                            <input type="text" class="form-control"  name="productName" id="productName" autocomplete="off" readonly>
	                            <input type="hidden" id="productId" name="productId"  readonly>
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
	                        	<input type="number" class="form-control" name="premiumAmount" id="premiumAmount" placeholder="0">
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
<script type="text/javascript">
	/* 모달 */
	// 계약 등록 버튼 클릭
	$('.btn-subscribe').on('click', function(e) {
	    e.preventDefault();
	    openContractModal();
	});
	
	// 모달 열기 함수
	function openContractModal() {
	    $('#contractModalOverlay, #contractModal').addClass('active');
	}
	// 모달 닫기
	$('#contractModal').on('click', '.modal-close, #cancelContract', function() {
		closeContractModal();
	});
	// 모달 닫기 함수
	function closeContractModal(){
		$('#contractModal, #contractModalOverlay').removeClass('active');
		// 모달 닫을 때 내용 초기화
	    const formEl = $('#contractForm')[0];
	    formEl.reset();

	    $('#customerId').val('');
	    $('#insuredId').val('');
	    $('#productId').val('');

	    $('.autocomplete-results').removeClass('active').empty().hide();

	    $('.riderList').empty();

	    $('input[type="checkbox"][value="주계약"]').prop('checked', true);
	}
	// 로그인 유저 정보 호출
	function getAuthUser(){
		$.ajax({
			url: "/product/authInfo",
			type: 'GET',
			success: function(){
				
			},
			error:function(){
				
			}
		})
	}
</script>
</body>
</html>
