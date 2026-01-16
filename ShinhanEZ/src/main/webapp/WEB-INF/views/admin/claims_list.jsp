<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
	<style>
		.admin-table th {
		    text-align: center;
		}
	</style>
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
                        청구 목록 (총 <strong>${empty list ? 0 : list.size()}</strong>건)
                    </span>

                    <!-- 신규 청구 등록 (GET /admin/claims/insert) -->
                    <a href="${ctx}/admin/claims/insert" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg"></i> 청구 등록
                    </a>
                </div>

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
                        <c:forEach var="c" items="${list}">
                            <tr>
                                <!-- 청구 상세: GET /admin/claims/{claimId} -->
                                <td>
                                    <a href="${ctx}/admin/claims/${c.claimId}">
                                        <strong>${c.claimId}</strong>
                                    </a>
                                </td>

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
                                <td>
									${c.customerName}
								</td>
                                <td>
									${c.insuredName}
								</td>
                                <td>
                                    ${empty c.accidentDate ? '-' : c.accidentDate}
                                </td>
                                <td>
									${empty c.claimDate ? '-' : c.claimDate}
                                </td>
                                <td>
									${c.adminName}
                                </td>

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

                        <c:if test="${empty list}">
                            <tr>
                                <td colspan="7" class="text-center" style="padding:40px;">
                                    <i class="bi bi-inbox" style="font-size:48px;color:#ccc;"></i>
                                    <p style="margin-top:10px;color:#999;">등록된 청구가 없습니다.</p>
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            
        </main>
        
        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>
        
    </div>
</div>

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
</body>
</html>
