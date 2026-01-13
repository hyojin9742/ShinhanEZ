<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <link rel="stylesheet" href="${ctx}/css/admin/payment.css">
</head>
<body class="admin-page">
<div class="admin-wrapper">
    
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="payment"/>
    </jsp:include>
    
    <div class="admin-main">
        
        <jsp:include page="inc/header.jsp"/>
        
        <main class="admin-content">
            
            <!-- 페이지 타이틀 -->
            <div class="page-title-area">
                <h2 class="page-title">납입내역 리스트</h2>
                <a href="${ctx}/admin/payment/register" class="btn btn-primary">
                    <i class="bi bi-plus-lg"></i> 납입 등록
                </a>
            </div>
            
            <!-- 검색 영역 -->
            <div class="payment-search">
                <form class="search-row" action="${ctx}/admin/payment/list" method="get">
                    <div class="form-group">
                        <label class="form-label">검색조건</label>
                        <select class="form-select select-sm" name="searchType">
                            <option value="">전체</option>
                            <option value="paymentId" ${searchType == 'paymentId' ? 'selected' : ''}>납입ID</option>
                            <option value="contractId" ${searchType == 'contractId' ? 'selected' : ''}>계약ID</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">검색어</label>
                        <input type="text" class="form-control input-md" name="keyword" placeholder="검색어 입력" value="${keyword}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">납입상태</label>
                        <select class="form-select select-xs" name="status">
                            <option value="">전체</option>
                            <option value="PAID" ${status == 'PAID' ? 'selected' : ''}>완료</option>
                            <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>대기</option>
                            <option value="OVERDUE" ${status == 'OVERDUE' ? 'selected' : ''}>연체</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> 검색</button>
                        <a href="${ctx}/admin/payment/list" class="btn btn-outline">초기화</a>
                    </div>
                </form>
            </div>

            <!-- 테이블 -->
            <div class="card">
                <div class="card-header">
                    <span>납입내역 목록</span>
                    <span class="total-count">총 <strong>${totalCount}</strong>건</span>
                </div>
                <div class="card-body no-padding">
                    <table class="payment-table">
                        <thead>
                            <tr>
                                <th>납입ID</th>
                                <th>계약ID</th>
                                <th>납입일</th>
                                <th>납입기한</th>
                                <th>금액</th>
                                <th>납입방법</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="payment" items="${paymentList}">
                            <tr>
                                <td>${payment.paymentId}</td>
                                <td>${payment.contractId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${payment.paymentDate != null}">
                                            <fmt:formatDate value="${payment.paymentDate}" pattern="yyyy-MM-dd"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${payment.dueDate}" pattern="yyyy-MM-dd"/></td>
                                <td class="payment-amount"><fmt:formatNumber value="${payment.amount}" pattern="#,###"/>원</td>
                                <td>${payment.method}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${payment.status == 'PAID'}">
                                            <span class="badge badge-success">완료</span>
                                        </c:when>
                                        <c:when test="${payment.status == 'PENDING'}">
                                            <span class="badge badge-warning">대기</span>
                                        </c:when>
                                        <c:when test="${payment.status == 'OVERDUE'}">
                                            <span class="badge badge-danger">연체</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/payment/view/${payment.paymentId}" class="btn btn-sm btn-outline">상세</a>
                                    <a href="${ctx}/admin/payment/edit/${payment.paymentId}" class="btn btn-sm btn-warning">수정</a>
                                    <a href="${ctx}/admin/payment/delete/${payment.paymentId}" class="btn btn-sm btn-danger" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                                </td>
                            </tr>
                            </c:forEach>
                            <c:if test="${empty paymentList}">
                            <tr>
                                <td colspan="8" style="text-align:center; padding:30px;">등록된 납입내역이 없습니다.</td>
                            </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- 페이지네이션 -->
            <c:if test="${totalPages > 0}">
            <div class="payment-pagination">
                <!-- 이전 페이지 그룹 -->
                <c:if test="${startPage > 1}">
                    <a href="${ctx}/admin/payment/list?page=${startPage - 1}&status=${status}&searchType=${searchType}&keyword=${keyword}">&laquo;</a>
                </c:if>
                
                <!-- 페이지 번호 -->
                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span class="active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${ctx}/admin/payment/list?page=${i}&status=${status}&searchType=${searchType}&keyword=${keyword}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <!-- 다음 페이지 그룹 -->
                <c:if test="${endPage < totalPages}">
                    <a href="${ctx}/admin/payment/list?page=${endPage + 1}&status=${status}&searchType=${searchType}&keyword=${keyword}">&raquo;</a>
                </c:if>
            </div>
            </c:if>
            
        </main>
        
        <jsp:include page="inc/footer.jsp"/>
        
    </div>
</div>
</body>
</html>
