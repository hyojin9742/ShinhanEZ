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
        <jsp:param name="menu" value="customer"/>
    </jsp:include>
    
    <!-- 메인 영역 -->
    <div class="admin-main">
        
        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="고객 상세"/>
        </jsp:include>
        
        <!-- 콘텐츠 -->
        <main class="admin-content">
            
            <!-- 페이지 타이틀 -->
            <div class="page-header">
                <h2>고객 상세정보</h2>
                <p>고객(보험자) ${customer.name}님의 상세 정보입니다.</p>
            </div>

            <!-- 상세 정보 카드 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-person-vcard"></i> 고객 정보</span>
                </div>
                <div class="card-body">
                    <div class="detail-grid">
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>고객 ID</label>
                                <span><strong>${customer.customerId}</strong></span>
                            </div>
                            <div class="detail-item">
                                <label>이름</label>
                                <span>${customer.name}</span>
                            </div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>생년월일</label>
                                <span><fmt:formatDate value="${customer.birthDate}" pattern="yyyy-MM-dd"/></span>
                            </div>
                            <div class="detail-item">
                                <label>성별</label>
                                <span>
                                    <c:choose>
                                        <c:when test="${customer.gender == 'M'}">
                                            <span class="badge badge-primary">남성</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">여성</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>연락처</label>
                                <span>${customer.phone}</span>
                            </div>
                            <div class="detail-item">
                                <label>이메일</label>
                                <span>${customer.email}</span>
                            </div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-item full">
                                <label>주소</label>
                                <span>${customer.address}</span>
                            </div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-item">
                                <label>등록일</label>
                                <span><fmt:formatDate value="${customer.regDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                            </div>
                            <div class="detail-item">
                                <label>권한</label>
                                <span>${customer.role}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 버튼 영역 -->
            <div class="btn-area">
                <a href="${ctx}/admin/customer/list" class="btn btn-outline">
                    <i class="bi bi-list"></i> 목록
                </a>
                <div>
                    <a href="${ctx}/admin/customer/edit?id=${customer.customerId}" class="btn btn-warning">
                        <i class="bi bi-pencil"></i> 수정
                    </a>
                    <button type="button" class="btn btn-danger" onclick="deleteCustomer('${customer.customerId}')">
                        <i class="bi bi-trash"></i> 삭제
                    </button>
                </div>
            </div>
            
        </main>
        
        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>
        
    </div>
</div>

<script>
    function deleteCustomer(id) {
        if(confirm('정말 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.')) {
            location.href = '${ctx}/admin/customer/delete?id=' + id;
        }
    }
</script>
</body>
</html>
