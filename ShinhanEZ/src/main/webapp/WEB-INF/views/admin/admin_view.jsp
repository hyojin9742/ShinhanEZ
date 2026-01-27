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
	<div id="alert-area"></div>
	<div class="admin-wrapper">
	    
	    <jsp:include page="inc/sidebar.jsp">
	        <jsp:param name="menu" value="employee"/>
	    </jsp:include>
	    
	    <div class="admin-main">
	        
	        <jsp:include page="inc/header.jsp"/>
	        
	        <main class="admin-content">
	            
	            <div class="page-title-area">
	                <h2 class="page-title">관리자 정보</h2>
	                <div>
	                    <a href="${ctx}/admin/employee" class="btn btn-secondary">목록</a>
	                    <a class="btn btn-warning viewModAdmin" data-admin-idx="${admin.adminIdx}">수정</a>
	                	<a class="btn btn-danger viewDelAdmin" data-admin-idx="${admin.adminIdx}">삭제</a>
	                </div>
	            </div>
	            
	            <!-- 관리자 정보 -->
	            <div class="card">
	                <div class="card-header">
	                    <span>관리자 정보</span>
	                </div>
	                <div class="card-body">
	                    <table class="payment-info-table">
	                        <tr>
	                            <th>관리자 번호</th>
	                            <td colspan="2">${admin.adminIdx }</td>
	                        </tr>
	                        <tr>
	                        	<th>아이디</th>
	                        	<td>${admin.adminId }</td>
	                            <th>비밀번호</th>
	                            <td>${admin.adminPw }</td>
	                        </tr>
	                        <tr>
	                            <th>이름</th>
	                            <td>${admin.adminName }</td>
	                            <th>부서</th>
	                            <td>${admin.department }</td>
	                        </tr>
	                        <tr>
	                            <th>권한</th>
	                            <td>${admin.adminRole }</td>
	                            <th>마지막 로그인</th>
	                            <td>${admin.lastLogin != null ? admin.lastLogin : '-'}</td>
	                        </tr>  
	                    </table>
	                </div>
	            </div>
	            <!-- 모달 -->
	            <div class="modal-overlay" id="adminModalOverlay"></div>
		        <div class="modal modal-lg" id="adminModal">
		            <div class="modal-header">
		                <h3 class="modal-title">관리자 정보 수정</h3>
		                <button class="modal-close" id="closeAdminModal">&times;</button>
		            </div>
		            <div class="modal-body">
		                <form id="adminForm" class="modal-form">
		                	<input type="hidden" name="adminIdx" value="${admin.adminIdx }"/>
		                    <div class="modal-grid">
		                        <div class="form-group">
		                            <label class="form-label">아이디 <span>*</span></label>
		                            <input type="text" class="form-control" name=adminId id="adminId" autocomplete="off" value="${admin.adminId }" readonly>
		                        </div>
		                        <div class="form-group">
		                            <label class="form-label">비밀번호 <span>*</span></label>
		                            <input type="text" class="form-control" name="adminPw" id="adminPw" autocomplete="off" value="${admin.adminPw }" required>
		                        </div>
		                        <div class="form-group">
		                            <label class="form-label">이름 <span>*</span></label>
		                            <input type="text" class="form-control"  name="adminName" id="adminName" autocomplete="off" value="${admin.adminName }" required>
		                        </div>
		                        <div class="form-group">
		                            <label class="form-label">부서 <span>*</span></label>
		                            <input type="text" class="form-control"  name="department" id="department" autocomplete="off" value="${admin.department }" required>
		                        </div>
		                        <div class="form-group">
		                        	<label class="form-label">권한 <span>*</span></label>
		                        	<select class="form-control" name="adminRole" id="adminRole" required>
		                                <option value="">권한 선택</option>
		                                <option value="super" ${admin.adminRole=='super' ? 'selected':'' }>최고관리자</option>
		                                <option value="manager" ${admin.adminRole=='manager' ? 'selected':'' }>매니저</option>
		                                <option value="staff" ${admin.adminRole=='staff' ? 'selected':'' }>스태프</option>
		                            </select>
		                        </div>
		                       	<div class="form-group">
		                            <label class="form-label">마지막 로그인 <span>*</span></label>
		                            <input type="text" class="form-control" name="lastLogin" id="lastLogin" autocomplete="off" value="${admin.lastLogin != null ? admin.lastLogin : '-'}" readonly>

		                        </div>
		                    </div>
		                </form>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-outline" id="cancelAdmin">취소</button>
		                <button type="button" class="btn btn-primary modifyAdmin" id="saveAdmin">
		                    수정
		                </button>
		            </div>
		        </div>
	        </main>
	        
	        <jsp:include page="inc/footer.jsp"/>
	    </div>
	</div>
</body>
</html>
