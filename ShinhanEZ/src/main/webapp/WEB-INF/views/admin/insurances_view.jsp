<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <link rel="stylesheet" href="${ctx}/css/admin/insurance.css">
</head>

<body class="admin-page">
<div class="admin-wrapper">

    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="Insurance"/>
    </jsp:include>

    <div class="admin-main">
        <jsp:include page="inc/header.jsp"/>

        <main class="admin-content">

            <!-- 페이지 타이틀 -->
            <div class="page-title-area">
                <h2 class="page-title">보험 상품 상세</h2>
                <div class="btn-group">
                    <a href="${ctx}/admin/insurance/edit?productNo=${insurance.productNo}" class="btn btn-warning">수정</a>
                    <a href="${ctx}/admin/insurance/delete/${insurance.productNo}"
                       class="btn btn-danger"
                       onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                    <a href="${ctx}/admin/insurance/list" class="btn btn-secondary">목록</a>
                </div>
            </div>

            <!-- 상품 정보 카드 -->
            <div class="card">
                <div class="card-body">

                    <table class="table table-bordered detail-table">
                        <tbody>
                        <tr>
                            <th>상품번호</th>
                            <td>${insurance.productNo}</td>
                        </tr>

                        <tr>
                            <th>상품명</th>
                            <td>${insurance.productName}</td>
                        </tr>

                        <tr>
                            <th>분류</th>
                            <td>${insurance.category}</td>
                        </tr>

                        <tr>
                            <th>기본 보험료</th>
                            <td>
                                <fmt:formatNumber value="${insurance.basePremium}" type="number"/> 원
                            </td>
                        </tr>

                        <tr>
                            <th>보장 범위</th>
                            <td>${insurance.coverageRange}</td>
                        </tr>

                        <tr>
                            <th>보장 기간</th>
                            <td>${insurance.coveragePeriod} 개월</td>
                        </tr>

                        <tr>
                            <th>상태</th>
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
                        </tr>

                        <tr>
                            <th>등록일</th>
                            <td>
                                <fmt:formatDate value="${insurance.createdDate}" pattern="yyyy-MM-dd"/>
                            </td>
                        </tr>

                        <tr>
                            <th>수정일</th>
                            <td>
                                <fmt:formatDate value="${insurance.updatedDate}" pattern="yyyy-MM-dd"/>
                            </td>
                        </tr>

                        <tr>
                            <th>등록자</th>
                            <td>${insurance.createdUser}</td>
                        </tr>

                        <tr>
                            <th>수정자</th>
                            <td>${insurance.updatedUser}</td>
                        </tr>
                        </tbody>
                    </table>

                </div>
            </div>

        </main>

        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>
</body>
</html>
