<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <link rel="stylesheet" href="${ctx}/css/admin/admin.css">
    <script src="${ctx}/js/jquery-3.7.1.min.js"></script>
    <script src="${ctx}/js/admin/adminAjaxModule.js"></script>
    <script src="${ctx}/js/admin/admin.js"></script>
</head>
<body class="admin-page">
	<div class="admin-wrapper">
	    
	    <jsp:include page="inc/sidebar.jsp">
	        <jsp:param name="menu" value="system"/>
	    </jsp:include>
	    
	    <div class="admin-main">
	        
	        <jsp:include page="inc/header.jsp"/>
	        
	        <main class="admin-content">
	            
	            <!-- 페이지 타이틀 -->
	            <div class="page-title-area">
	                <h2 class="page-title">관리자 목록</h2>
	                <a href="#" class="btn btn-primary">
	                    <i class="bi bi-plus-lg"></i>&nbsp;관리자 등록
	                </a>
	            </div>
	            <!-- 테이블 -->
	            <div class="card">
	                <div class="card-header">
	                    <span>관리자 목록</span>
	                    <span class="total-admin">총 <strong class="totalAdminInner"></strong>건</span>
	                </div>
	                <div class="card-body no-padding">
	                    <table class="payment-table">
	                        <thead>
	                            <tr>
	                                <th>관리자 번호</th>
	                                <th>관리자 아이디</th>
	                                <th>관리자 이름</th>
	                                <th>권한</th>
	                                <th>부서</th>
	                                <th>마지막 로그인</th>
	                                <th>관리</th>
	                            </tr>
	                        </thead>
	                        <tbody class="adminList">
								<tr>
	                                <th>관리자 번호</th>
	                                <th>관리자 아이디</th>
	                                <th>관리자 이름</th>
	                                <th>부서</th>
	                                <th>마지막 로그인</th>
	                            </tr>
	                        </tbody>
	                    </table>
	                </div>
	            </div>
	            
	            <!-- 페이지네이션 -->
	            <div class="paginationWrap">
	            	<ul class="admin-pagination">
	            		<!-- 이전 페이지 그룹 -->
	            		<li><a href="#">&laquo;</a></li>
	            		<!-- 페이지 번호 -->
	            		<li><a href="#" class="activePage">활성 페이지</a></li>
	            		<li><a href="#">비활성 페이지</a></li>
	            		<!-- 다음 페이지 그룹 -->
	            		<li><a href="#">&raquo;</a></li>
	            	</ul>
	            </div>
	            
	            <!-- 모달 -->
	            <div class="modal-overlay" id="adminModalOverlay"></div>
		        <div class="modal modal-lg" id="adminModal">
		            <div class="modal-header">
		                <h3 class="modal-title">${contractId ? '관리자 수정' : '관리자 등록'}</h3>
		                <button class="modal-close" id="closeContractModal">&times;</button>
		            </div>
		            <div class="modal-body">
		                <form id="adminForm" class="modal-form">
		                    <div class="modal-grid">
		                        <div class="form-group">
		                            <label class="form-label">아이디 <span>*</span></label>
		                            <input type="text" class="form-control" name="adminId" id="adminId" autocomplete="off" required>
		                        </div>
		                        <div class="form-group">
		                            <label class="form-label">비밀번호 <span>*</span></label>
		                            <input type="text" class="form-control" name="adminPw" id="adminPw" autocomplete="off" required>
		                        </div>
		                        <div class="form-group">
		                            <label class="form-label">이름 <span>*</span></label>
		                            <input type="text" class="form-control" id="adminName" name="adminName" autocomplete="off" required>
		                        </div>
		                        <div class="form-group">
		                        	<label class="form-label">부서 <span>*</span></label>
		                        	<input type="text" class="form-control" id="department" name="department" autocomplete="off" required>
	                        	</div>
		                        <div class="form-group">
		                            <label class="form-label">권한 <span>*</span></label>
		                            <select class="form-control" name="adminRole" required>
		                                <option value="">권한 선택</option>
		                                <option value="super">최고관리자</option>
		                                <option value="manager">매니저</option>
		                                <option value="staff">스태프</option>
		                            </select>
		                        </div>
		                    </div>
		                </form>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-outline" id="cancelContract">취소</button>
		                <button type="button" class="btn btn-primary" id="saveContract">
		                    ${contractId ? '수정' : '등록'}
		                </button>
		            </div>
		        </div>
	        	            
	        </main>
	        <jsp:include page="inc/footer.jsp"/>
	    </div>
	</div>
</body>
</html>
