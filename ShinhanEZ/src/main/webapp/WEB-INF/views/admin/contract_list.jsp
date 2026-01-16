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
    <script src="${ctx}/js/admin/contract.js"></script>
</head>
<body class="admin-page">
	<div class="admin-wrapper">
	    
	    <jsp:include page="inc/sidebar.jsp">
	        <jsp:param name="menu" value="contract"/>
	    </jsp:include>
	    
	    <div class="admin-main">
	        
	        <jsp:include page="inc/header.jsp"/>
	        
	        <main class="admin-content">
	            
	            <!-- 페이지 타이틀 -->
	            <div class="page-title-area">
	                <h2 class="page-title">계약 리스트</h2>
	                <a href="#" class="btn btn-primary">
	                    <i class="bi bi-plus-lg"></i>&nbsp;계약등록
	                </a>
	            </div>
	            
	            <!-- 검색 영역 -->
	            <div class="payment-search">
	                <form class="search-row" action="#" method="get">
	                	<div class="form-group searchCondition">
		                	
		                	<div class="form-group contractSearchType">
			                    <div class="form-group">
			                        <label class="form-label">검색조건</label>
			                        <select class="form-select select-sm" name="searchType">
			                            <option value="allType" ${searchType == 'contractId' ? 'selected' : ''}>전체</option>
			                            <option value="contractId" ${searchType == 'contractId' ? 'selected' : ''}>계약번호</option>
			                            <option value="contractName" ${searchType == 'contractName' ? 'selected' : ''}>계약자명</option>
			                            <option value="productName" ${searchType == 'productName' ? 'selected' : ''}>상품명</option>
			                            <option value="adminName" ${searchType == 'adminName' ? 'selected' : ''}>담당관리자</option>
			                        </select>
			                    </div>
			                    <div class="form-group">
			                        <label class="form-label">검색어</label>
			                        <input type="text" class="form-control input-md" name="" placeholder="검색어 입력" value="">
			                    </div>
		                	</div>
		                	<div class="form-group searchContractDate">
			                    <div class="form-group">
			                        <label class="form-label">검색기간</label>
			                        <select class="form-select select-sm" name="contractDate">
			                            <option value="" ${contractDate == '' ? 'selected' : ''}>검색기준일</option>
			                            <option value="regDate" ${contractDate == 'regDate' ? 'selected' : ''}>계약일</option>
			                            <option value="expiredDate" ${contractDate == 'expiredDate' ? 'selected' : ''}>만료일</option>
			                        </select>
			                    </div>
			                    <div class="form-group">
			                        <label class="form-label">일자</label>
			                        <input type="date" class="form-control input-md" name="stardDate" value="">
			                        <span>&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;</span>
			                        <input type="date" class="form-control input-md" name="endDate" value="">
			                    </div>
		                	</div>
		                    <div class="form-group searchContractStatus">
			                    <div class="form-group">
			                        <label class="form-label">계약상태</label>
			                        <select class="form-select select-xs" name="contractStatus">
			                            <option value="">전체</option>
			                            <option value="활성" ${contractStatus == '활성' ? 'selected' : ''}>활성</option>
			                            <option value="만료" ${contractStatus == '만료' ? 'selected' : ''}>만료</option>
			                            <option value="해지" ${contractStatus == '해지' ? 'selected' : ''}>해지</option>
			                        </select>
			                    </div>
		                	</div>
	                	</div>
	                    <div class="form-group searchBtn">
		                    <div class="form-group">
		                        <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> 검색</button>
		                        <button type="reset" class="btn btn-outline"> 초기화 </button>
		                    </div>
	                	</div>
	                </form>
	            </div>
	
	            <!-- 테이블 -->
	            <div class="card">
	                <div class="card-header">
	                    <span>계약 목록</span>
	                    <span class="total-contract">총 <strong class="totalContractInner"></strong>건</span>
	                </div>
	                <div class="card-body no-padding">
	                    <table class="payment-table">
	                        <thead>
	                            <tr>
	                                <th>계약번호</th>
	                                <th>계약자명</th>
	                                <th>피보험자명</th>
	                                <th>상품명</th>
	                                <th>계약일</th>
	                                <th>만료일</th>
	                                <th>계약상태</th>
	                                <th>최근수정일</th>
	                                <th>담당관리자</th>
	                            </tr>
	                        </thead>
	                        <tbody class="contractContent">
								<tr>
									<th>계약번호</th>
	                                <th>계약자명</th>
	                                <th>피보험자명</th>
	                                <th>상품명</th>
	                                <th>계약일</th>
	                                <th>만료일</th>
	                                <th>계약상태</th>
	                                <th>최근수정일</th>
	                                <th>담당관리자</th>
								</tr>
	                        </tbody>
	                    </table>
	                </div>
	            </div>
	            
	            <!-- 페이지네이션 -->
	            <div class="paginationWrap">
	            	<ul class="contract-pagination">
	            		<!-- 이전 페이지 그룹 -->
	            		<li><a href="#">&laquo;</a></li>
	            		<!-- 페이지 번호 -->
	            		<li><a href="#" class="active">활성 페이지</a></li>
	            		<li><a href="#">비활성 페이지</a></li>
	            		<!-- 다음 페이지 그룹 -->
	            		<li><a href="#">&raquo;</a></li>
	            	</ul>
	            	<div class="pageSize">
            			<select class="form-select select-sm" name="pageSize">
                            <option value="10" ${pageSize == '20' ? 'selected' : ''}>10개씩 보기</option>
                            <option value="20" ${pageSize == '20' ? 'selected' : ''}>20개씩 보기</option>
                            <option value="30" ${pageSize == '30' ? 'selected' : ''}>30개씩 보기</option>
           				</select>
	            	</div>
	            </div>
	            	            
	        </main>
	        
	        <jsp:include page="inc/footer.jsp"/>
	        
	    </div>
	</div>
</body>
</html>
