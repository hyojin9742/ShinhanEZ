<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <link rel="stylesheet" href="${ctx}/css/admin/contract.css">
    <script src="${ctx}/js/jquery-3.7.1.min.js"></script>
    <script src="${ctx}/js/admin/contractAjaxModule.js"></script>
    <script src="${ctx}/js/admin/contractView.js"></script>
</head>
<body class="admin-page">
	<div id="alert-area"></div>
	<div class="admin-wrapper">
	    
	    <jsp:include page="inc/sidebar.jsp">
	        <jsp:param name="menu" value="contract"/>
	    </jsp:include>
	    
	    <div class="admin-main">
	        
	        <jsp:include page="inc/header.jsp"/>
	        
	        <main class="admin-content">
	            
	            <div class="page-title-area">
	                <h2 class="page-title">계약 상세내역</h2>
	                <div>
	                    <a href="#" class="btn btn-warning contract-update">수정</a>
	                    <a href="${ctx}/admin/contract/list" class="btn btn-secondary">목록</a>
	                </div>
	            </div>
	            
	            <!-- 계약 정보 -->
	            <div class="card">
	                <div class="card-header">
	                    <span>계약 정보</span>
	                    <c:choose>
	                        <c:when test="${contract.contractStatus == '활성'}">
	                            <span class="badge badge-success">활성</span>
	                        </c:when>
	                        <c:when test="${contract.contractStatus == '만료'}">
	                            <span class="badge badge-warning">만료</span>
	                        </c:when>
	                        <c:when test="${contract.contractStatus == '해지'}">
	                            <span class="badge badge-danger">해지</span>
	                        </c:when>
	                        <c:when test="${contract.contractStatus == '대기'}">
	                            <span class="badge badge-danger">대기</span>
	                        </c:when>
	                    </c:choose>
	                </div>
	                <div class="card-body">
	                    <table class="payment-info-table">
	                        <tr>
	                            <th>계약 ID</th>
	                            <td colspan="3" data-contract-id="${contract.contractId }">${contract.contractId }</td>
	                        </tr>
	                        <tr>
	                        	<th>계약자 번호</th>
	                        	<td>${contract.customerId }</td>
	                            <th>계약자 이름</th>
	                            <td>${contract.customerName }</td>
	                        </tr>
	                        <tr>
	                            <th>피보험자 번호</th>
	                            <td>${contract.insuredId }</td>
	                            <th>피보험자 이름</th>
	                            <td>${contract.insuredName }</td>
	                        </tr>
	                        <tr>
	                            <th>보험 번호</th>
	                            <td>${contract.productId }</td>
	                            <th>보험 상품명</th>
	                            <td>${contract.productName }</td>
	                        </tr>
	                        <tr>
	                            <th>보장내역</th>
	                            <td colspan="5" class = "currentCoverage">${contract.contractCoverage }</td>
	                        </tr>
	                        <tr>
	                            <th>계약일</th>
	                            <td><fmt:formatDate value="${contract.regDate }" pattern="yyyy-MM-dd"/></td>
	                            <th>만료일</th>
	                            <td><fmt:formatDate value="${contract.expiredDate }" pattern="yyyy-MM-dd"/></td>
	                        </tr>
	                        <tr>
	                        	<th>보험료</th>
	                        	<td>${contract.premiumAmount }</td>
	                        	<th>납입주기</th>
	                        	<td>${contract.paymentCycle }</td>
	                        </tr>
	                        <tr>
	                        	<th>관리자 번호</th>
	                        	<td>${contract.adminIdx }</td>
	                        	<th>관리자 이름</th>
	                        	<td>${contract.adminName }</td>
	                        </tr>
	                        <tr>
	                        	<th>수정일자</th>
	                        	<td><fmt:formatDate value="${contract.updateDate }" pattern="yyyy-MM-dd"/></td>
	                        	<th>계약서</th>
	                        	<td> <button class="btn btn-primary downDocument">다운로드</button> </td>
	                        </tr>
	                    </table>
	                </div>
	            </div>
	            <!-- 모달 -->
	            <div class="modal-overlay" id="contractModalOverlay"></div>
		        <div class="modal modal-lg" id="contractModal">
		            <div class="modal-header">
		                <h3 class="modal-title">계약 수정</h3>
		                <button class="modal-close" id="closeContractModal">&times;</button>
		            </div>
		            <div class="modal-body">
		                <form id="contractForm" class="modal-form">
		                	<input type="hidden" name="contractId" value="${contract.contractId }"/>
		                    <div class="modal-grid">
		                        <div class="form-group">
		                            <label class="form-label">계약자명 <span>*</span></label>
		                            <input type="text" class="form-control" name="customerName" id="customerName" autocomplete="off" value="${contract.customerName }" readonly>
		                            <input type="hidden" id="customerId" name="customerId" value="${contract.customerId }">
		                        </div>
		                        <div class="form-group">
		                            <label class="form-label">피보험자명 <span>*</span></label>
		                            <input type="text" class="form-control" name="insuredName" id="insuredName" autocomplete="off" value="${contract.insuredName }" readonly>
		                            <input type="hidden" id="insuredId" name="insuredId" value="${contract.insuredId }">
		                        </div>
		                        <div class="form-group">
		                            <label class="form-label">상품명 <span>*</span></label>
		                            <input type="text" class="form-control"  name="productName" id="productName" autocomplete="off" value="${contract.productName }" readonly>
		                            <input type="hidden" id="productId" name="productId" value="${contract.productId }">
		                        </div>
		                        <div class="form-group">
		                        	<label class="form-label">보장내용 <span>*</span></label>
		                        	<input type="hidden" name="contractCoverage" value="주계약" />
		                        	<input type="checkbox" value="주계약" checked disabled/>주계약 <span>*</span>
		                        	<div class="riderList"></div>
	                        	</div>
		                        <div class="form-group">
		                            <label class="form-label">계약일 <span>*</span></label>
		                            <input type="date" class="form-control" name="regDate" id="regDate" value="<fmt:formatDate value="${contract.regDate }" pattern="yyyy-MM-dd"/>" readonly>
		                        </div>
		                        <div class="form-group">
		                            <label class="form-label">만료일 <span>*</span></label>
		                            <input type="date" class="form-control" name="expiredDate" id="expiredDate" value="<fmt:formatDate value="${contract.expiredDate }" pattern="yyyy-MM-dd"/>" required>
		                        </div>
		                        <div class="form-group">
		                        	<label class="form-label">보험료 <span>*</span></label>
		                        	<input type="number" class="form-control" name="premiumAmount" id="premiumAmount" value="${contract.premiumAmount }" required>
		                        </div>
		                        <div class="form-group">
		                        	<label class="form-label">납부주기 <span>*</span></label>
		                        	<select class="form-control" name="paymentCycle" id="paymentCycle" required>
		                                <option value="">주기 선택</option>
		                                <option value="월납" ${contract.paymentCycle=='월납' ? 'selected':'' }>월납</option>
		                                <option value="분기납" ${contract.paymentCycle=='분기납' ? 'selected':'' }>분기납</option>
		                                <option value="반기납" ${contract.paymentCycle=='반기납' ? 'selected':'' }>반기납</option>
		                                <option value="연납" ${contract.paymentCycle=='연납' ? 'selected':'' }>연납</option>
		                                <option value="일시납" ${contract.paymentCycle=='일시납' ? 'selected':'' }>일시납</option>
		                            </select>
		                        </div>
		                       	<div class="form-group">
		                            <label class="form-label">담당관리자 <span>*</span></label>
		                            <input type="text" class="form-control" name="adminName" id="adminName" autocomplete="off" value="${contract.adminName }" required>
		                            <input type="hidden" id="adminIdx" name="adminIdx" value="${contract.adminIdx }">
		                        </div>
		                        <div class="form-group">
		                        	<label class="form-label">계약상태 <span>*</span></label>
			                       	<select class="form-control" name="contractStatus" id="contractStatus" required>
		                                <option value="">상태변경</option>
		                                <option value="활성" ${contract.contractStatus == '활성' ? 'selected':''}>활성</option>
		                                <option value="만료" ${contract.contractStatus == '만료' ? 'selected':''}>만료</option>
		                                <option value="해지" ${contract.contractStatus == '해지' ? 'selected':''}>해지</option>
		                                <option value="대기" ${contract.contractStatus == '대기' ? 'selected':''}>대기</option>
		                            </select>
		                        </div>
		                    </div>
		                </form>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-outline" id="cancelContract">취소</button>
		                <button type="button" class="btn btn-primary" id="saveContract">
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
