<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <link rel="stylesheet" href="${ctx}/css/admin/payment.css"><!-- 기존 스타일 재사용 -->
</head>

<body class="admin-page">
<div class="admin-wrapper">

    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="Insurance"/>
    </jsp:include>

    <div class="admin-main">

        <jsp:include page="inc/header.jsp"/>

        <main class="admin-content">

            <div class="page-title-area">
                <h2 class="page-title">보험상품 등록</h2>
            </div>

            <div class="card">
                <div class="card-header">
                    <span>보험상품 정보 입력</span>
                </div>

                <div class="card-body">
                    <form action="${ctx}/admin/insurance/register" method="post">
                        <div class="payment-form">

                            <!-- 좌측 -->
                            <div>
                                <div class="form-group">
                                    <label class="form-label">상품명 *</label>
                                    <input type="text" class="form-control"
                                           name="productName" placeholder="상품명 입력" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">분류 *</label>
                                    <select class="form-select full-width" name="category" required>
                                        <option value="">선택</option>
                                        <option value="생명보험">생명보험</option>
                                        <option value="손해보험">손해보험</option>
                                        <option value="건강보험">건강보험</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">기본 보험료 *</label>
                                    <input type="number" class="form-control"
                                           name="basePremium" placeholder="보험료 입력" required>
                                </div>
                            </div>

                            <!-- 우측 -->
                            <div>
                                <div class="form-group">
                                    <label class="form-label">보장 범위</label>
                                    <input type="text" class="form-control"
                                           name="coverageRange" placeholder="보장 범위 입력">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">보장 기간 (개월) *</label>
                                    <input type="number" class="form-control"
                                           name="coveragePeriod" placeholder="개월 수 입력" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">상태</label>
                                    <div class="radio-group">
                                        <label>
                                            <input type="radio" name="status" value="ACTIVE" checked> 활성
                                        </label>
                                        <label>
                                            <input type="radio" name="status" value="INACTIVE"> 비활성
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                       	<sec:authentication property="principal.admin.adminName" var="adminName"/>
                        <input type="hidden" name="createdUser" value="${adminName}">
						<input type="hidden" name="updatedUser" value="${adminName}">
                        <div class="btn-area">
                        
                        
                            <button type="submit" class="btn btn-primary">등록</button>
                            <button type="reset" class="btn btn-outline">초기화</button>
                            <a href="${ctx}/admin/insurance/list" class="btn btn-secondary">목록</a>
                        </div>
                    </form>
                </div>
            </div>

        </main>

        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>
</body>
</html>
