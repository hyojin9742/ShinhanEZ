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
        <jsp:param name="menu" value="Insurance"/>
    </jsp:include>

    <!-- 메인 영역 -->
    <div class="admin-main">

        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="상품관리"/>
        </jsp:include>

        <!-- 콘텐츠 -->
        <main class="admin-content">

            <!-- 페이지 타이틀 -->
            <div class="page-header">
                <h2>상품 목록</h2>
                <p>등록된 보험상품 정보를 관리합니다.</p>
            </div>

            <!-- 상품 목록 카드 -->
            <div class="card">
                <div class="card-header">
                    <span>
                        <i class="bi bi-box-seam"></i>
                        상품 목록 (총 <strong>${insurances.size()}</strong>건)
                    </span>
                    <a href="${ctx}/admin/insurance/register" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg"></i> 상품 등록
                    </a>
                </div>

                <div class="card-body" style="padding:0;">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th style="width:90px;">상품번호</th>
                            <th>상품명</th>
                            <th style="width:120px;">분류</th>
                            <th style="width:110px;">기본 보험료</th>
                            <th>보장 범위</th>
                            <th style="width:90px;">기간</th>
                            <th style="width:90px;">상태</th>
                            <th style="width:120px;">등록일</th>
                            <th style="width:140px;">관리</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach var="insurance" items="${insurances}">
                            <tr>
                                <td><strong>${insurance.productNo}</strong></td>
                                <td>${insurance.productName}</td>
                                <td>${insurance.category}</td>
                                <td>
                                    <fmt:formatNumber value="${insurance.basePremium}" type="number"/> 원
                                </td>
                                <td>${insurance.coverageRange}</td>
                                <td>${insurance.coveragePeriod}개월</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${insurance.status eq 'ACTIVE'}">
                                            <span class="badge badge-success">ACTIVE</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">INACTIVE</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${insurance.createdDate}" pattern="yyyy-MM-dd"/>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/insurance/get?productNo=${insurance.productNo}"
                                       class="btn btn-sm btn-outline" title="상세">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="${ctx}/admin/insurance/edit?productNo=${insurance.productNo}"
                                       class="btn btn-sm btn-outline" title="수정">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <button type="button"
                                            class="btn btn-sm btn-outline-danger"
                                            onclick="deleteInsurance('${insurance.productNo}')"
                                            title="삭제">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
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
    function deleteInsurance(productNo) {
        if (confirm('정말 삭제하시겠습니까?\n상품번호: ' + productNo)) {
            location.href = '${ctx}/admin/insurance/delete?productNo=' + productNo;
        }
    }
</script>
</body>
</html>
