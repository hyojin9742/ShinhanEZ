<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<%--
[관리자 > 청구 목록 화면]
- 데이터: Controller에서 list, paging, claimsCriteria, totalCount, startRow, endRow 제공
- 기능:
  1) 청구 목록 렌더링 + 상태 배지 표시
  2) 검색(keyword) 및 조건 유지(pageSize/status/fromDate/toDate/keyword)
  3) 페이징 링크 생성(c:url)
  4) 삭제는 JS에서 POST 폼 생성 방식으로 처리(CSRF/REST 정책에 따라 조정 가능)
  5) msg/msgType 기반 토스트 출력(Bootstrap Toast)
--%>
<html lang="ko">
<head>
	<!-- 토스트 표시 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <jsp:include page="inc/head.jsp"/>
	<link rel="stylesheet" href="${ctx}/css/admin/claims_list.css">
</head>
<body class="admin-page">
<div class="admin-wrapper">
    <!-- 사이드바 -->
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="claims"/>
    </jsp:include>
    <!-- 메인 영역 -->
    <div class="admin-main">
        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="청구관리"/>
        </jsp:include>
        <!-- 콘텐츠 -->
        <main class="admin-content">
            <!-- 페이지 타이틀 -->
            <div class="page-header">
                <h2>청구 목록</h2>
                <p>등록된 청구 정보를 관리합니다.</p>
            </div>
            <!-- 청구 목록 카드 -->
            <div class="card">
                <div class="card-header">
                    <span>
                        <i class="bi bi-receipt"></i>
							총 <strong>${totalCount}</strong>건 중
						    <strong>${startRow}</strong>~
						    <strong>${endRow}</strong>건
                    </span>
                    <!-- 신규 청구 등록 (GET /admin/claims/insert) -->
                    <a href="${ctx}/admin/claims/insert" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg"></i> 청구 등록
                    </a>
                </div>
				<!-- 청구 목록 테이블 -->
                <div class="card-body" style="padding:0;">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th style="width:120px;">청구ID</th>
                                <th style="width:120px;">상태</th>
                                <th style="width:120px;">보험가입자</th>
                                <th style="width:120px;">피보험자</th>
                                <th style="width:120px;">사고일</th>
                                <th style="width:120px;">청구일</th>
                                <th style="width:120px;">담당자</th>
                                <th style="width:120px;">관리</th>
                            </tr>
                        </thead>
                        <tbody>
						<!-- 목록 반복 출력 -->
                        <c:forEach var="c" items="${list}">
                            <tr>
                                <!-- 청구 상세: GET /admin/claims/{claimId} -->
                                <td>
                                    <a href="${ctx}/admin/claims/${c.claimId}">
                                        <strong>${c.claimId}</strong>
                                    </a>
                                </td>
								<!-- 상태 배지 표시 -->
                                <td>
                                    <c:choose>
                                        <c:when test="${c.status == 'PENDING'}">
                                            <span class="badge badge-primary">미처리</span>
                                        </c:when>
                                        <c:when test="${c.status == 'COMPLETED'}">
                                            <span class="badge badge-success">승인</span>
                                        </c:when>
                                        <c:when test="${c.status == 'REJECTED'}">
                                            <span class="badge badge-danger">반려</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">${c.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>		
								<!-- 가입자/피보험자/날짜/담당자 -->						
                                <td>${c.customerName}</td>
                                <td>${c.insuredName}</td>
                                <td>${empty c.accidentDate ? '-' : c.accidentDate}</td>
                                <td>${empty c.claimDate ? '-' : c.claimDate}</td>
                                <td>${c.adminName}</td>
								<!-- 관리 버튼: 상세보기 / 삭제 -->
                                <td>
                                    <!-- 상세보기 -->
                                    <a href="${ctx}/admin/claims/${c.claimId}" 
                                       class="btn btn-sm btn-outline" title="상세보기">
                                        <i class="bi bi-eye"></i>
                                    </a>

                                    <!-- 삭제: POST /admin/claims/{claimId}/delete 로 맞추는게 안전 -->
                                    <button type="button" class="btn btn-sm btn-outline-danger"
                                            onclick="deleteClaim('${c.claimId}')" title="삭제">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
						<!-- 목록이 비어 있을 때 -->
                        <c:if test="${empty list}">
                            <tr>
                                <td colspan="8" class="text-center" style="padding:40px;">
                                    <i class="bi bi-inbox" style="font-size:48px;color:#ccc;"></i>
                                    <p style="margin-top:10px;color:#999;">등록된 청구가 없습니다.</p>
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
			<!-- 검색/필터 파라미터 유지용 Criteria 변수 -->
			<c:set var="cri" value="${claimsCriteria}" />
			<!-- 페이징 URL 베이스(검색 조건 유지) -->
			<c:url var="baseUrl" value="${ctx}/admin/claims">
			  <c:param name="pageSize" value="${cri.pageSize}" />
			  <c:if test="${not empty cri.status}"><c:param name="status" value="${cri.status}" /></c:if>
			  <c:if test="${not empty cri.fromDate}"><c:param name="fromDate" value="${cri.fromDate}" /></c:if>
			  <c:if test="${not empty cri.toDate}"><c:param name="toDate" value="${cri.toDate}" /></c:if>
			  <c:if test="${not empty cri.keyword}"><c:param name="keyword" value="${cri.keyword}" /></c:if>
			</c:url>
			
			<!-- 페이징 + 검색 영역 -->
			<div class="paging-bar">
				<!-- 페이징 -->
				<nav aria-label="Page navigation">
					<ul class="pagination">
					    <!-- 이전 페이지 -->
					    <c:if test="${paging.hasPrev()}">
				        	<c:url var="prevUrl" value="${baseUrl}">
				            	<c:param name="pageNum" value="${paging.pageNum - 1}" />
				      		</c:url>
				      		<li class="page-item">
				        		<a class="page-link" href="${prevUrl}">이전</a>
				      		</li>
				    	</c:if>
					    <!-- 페이지 번호 -->
					    <c:forEach var="p" begin="${paging.startPage}" end="${paging.endPage}">
					      	<c:url var="pageUrl" value="${baseUrl}">
					        	<c:param name="pageNum" value="${p}" />
					      	</c:url>
	
					      	<li class="page-item ${p == paging.pageNum ? 'active' : ''}">
					        	<a class="page-link" href="${pageUrl}">${p}</a>
					      	</li>
					    </c:forEach>
					    <!-- 다음 페이지 -->
					    <c:if test="${paging.hasNext()}">
					      	<c:url var="nextUrl" value="${baseUrl}">
					        	<c:param name="pageNum" value="${paging.pageNum + 1}" />
					      	</c:url>
					      	<li class="page-item">
					        	<a class="page-link" href="${nextUrl}">다음</a>
					      	</li>
					    </c:if>
					</ul>
				</nav>
			  	<!-- 키워드 검색폼 -->
			  	<form method="get" action="${ctx}/admin/claims" class="search-row search-right">
			      	<input type="hidden" name="pageSize" value="${claimsCriteria.pageSize}" />
			      	<div class="form-group">
			          	<input type="text"
			                 name="keyword"
			                 class="form-control input-md"
			                 placeholder="키워드 검색"
			                 value="${claimsCriteria.keyword}" />
			      	</div>
			      	<button type="submit" class="btn btn-primary">
			          	<i class="bi bi-search"></i> 검색
			      	</button>
			      	<a href="${ctx}/admin/claims" class="btn btn-outline">
			          	초기화
			      	</a>
			  	</form>
			</div>
			<!-- 토스트 메시지 영역(msg 있을 때만 렌더링) -->
			<c:if test="${not empty msg}">
				<div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3"style="z-index:20000;">
					<div id="appToast" class="toast align-items-center text-bg-${msgType == 'success' ? 'success' : (msgType == 'error' ? 'danger' : 'secondary') } border-0" role="alert" aria-live="assertive" aria-atomic="true">
				    	<div class="d-flex">
				      		<div class="toast-body">${msg}</div>
				      		<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
				    	</div>
				  	</div>
				</div>
			</c:if>
        </main>
        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>
<!-- Bootstrap JS 번들(Toast 동작 필요) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 삭제 처리 스크립트: confirm 후 POST로 삭제 요청 -->
<script>
    function deleteClaim(claimId) {
        if(confirm('정말 삭제하시겠습니까?\n청구ID: ' + claimId+'번')) {
            const form = document.createElement('form');
            form.method = 'post';
            form.action = '${ctx}/admin/claims/' + claimId + '/delete';
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

<!-- 토스트 자동 표시 -->
<script>
  (function () {
    const el = document.getElementById("appToast");
    if (!el) return;

    const isError = "${msgType}" === "error";
    bootstrap.Toast.getOrCreateInstance(el, {
      delay: isError ? 4000 : 2200,
      autohide: true
    }).show();
  })();
</script>


</body>
</html>
