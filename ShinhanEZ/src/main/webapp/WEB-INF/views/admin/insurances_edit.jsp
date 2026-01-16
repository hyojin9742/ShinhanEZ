<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
</head>
<body class="admin-page">
<div class="admin-wrapper">
    
    <!-- 사이드바 -->
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="customer"/>
    </jsp:include>
    
    <!-- 메인 영역 -->
    <div class="admin-main">
        
        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="상품 수정"/>
        </jsp:include>
        
        <!-- 콘텐츠 -->
        <main class="admin-content">
            
            <!-- 페이지 타이틀 -->
            <div class="page-header">
                <h2>상품 정보 수정</h2>
                <p>상품 정보를 수정합니다.</p>
            </div>

            <!-- 수정 폼 카드 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-pencil-square"></i> 상품 정보 수정</span>
                </div>
                <div class="card-body">
                    <form action="${ctx}/admin/insurance/edit" method="post" class="admin-form">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>고객 ID</label>
                                <input type="text" name="productNo" value="${insurance.productNo}" 
                                       class="form-control" readonly>
                                <small>상품 ID는 수정할 수 없습니다.</small>
                            </div>
                            <div class="form-group">
                                <label>상품명 <span class="required">*</span></label>
                                <input type="text" name="name" value="${insurance.productName}" 
                                       class="form-control" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>분류 <span class="required">*</span></label>
                                <p>${insurance.category}</p>
                                <div class="radio-group">
                                <select name="category" size="4">
								    <option value="생명보험">생명보험</option>
								    <option value="손해보험">손해보험</option>
								    <option value="건강보험">건강보험</option>
								  </select>    
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>기본 보험료 <span class="required">*</span></label>
                                <input type="text" name="basePremium" value="${insurance.basePremium}" 
                                       class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>보장범위</label>
                                <input type="text" name="coverageRange" value="${insurance.coverageRange}" 
                                       class="form-control">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group full">
                                <label>보장기간</label>
                                <input type="number" name="coveragePeriod" value="${insurance.coveragePeriod}" 
                                       class="form-control">
                            </div>
                        </div>
                        
                        <!-- 버튼 영역 -->
                        <div class="btn-area">
                            <a href="${ctx}/admin/customer/list" class="btn btn-outline">
                                <i class="bi bi-x-lg"></i> 취소
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg"></i> 수정 완료
                            </button>
                        </div>
                        
                    </form>
                </div>
            </div>
            
        </main>
        
        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>
        
    </div>
</div>
</body>
</html>
