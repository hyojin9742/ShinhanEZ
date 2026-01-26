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
        <jsp:param name="menu" value="board"/>
    </jsp:include>

    <!-- 메인 영역 -->
    <div class="admin-main">

        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="게시판관리"/>
        </jsp:include>

        <!-- 콘텐츠 -->
        <main class="admin-content">

            <!-- 페이지 타이틀 -->
            <div class="page-header">
                <h2>게시글 상세</h2>
                <p>게시글 상세 정보입니다.</p>
            </div>

            <!-- 알림 메시지 -->
            <c:if test="${not empty message}">
                <div class="alert alert-success" style="margin-bottom:20px;">
                    <i class="bi bi-check-circle"></i> ${message}
                </div>
            </c:if>

            <!-- 게시글 상세 카드 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-file-text"></i> 게시글 정보</span>
                    <c:if test="${canModify}">
                        <div>
                            <a href="${ctx}/admin/board/edit/${board.idx}" class="btn btn-sm btn-primary">
                                <i class="bi bi-pencil"></i> 수정
                            </a>
                            <button type="button" class="btn btn-sm btn-danger" onclick="deleteBoard(${board.idx})">
                                <i class="bi bi-trash"></i> 삭제
                            </button>
                        </div>
                    </c:if>
                </div>
                <div class="card-body">
                    <table class="detail-table">
                        <tr>
                            <th style="width:120px;">번호</th>
                            <td style="width:200px;">${board.idx}</td>
                            <th style="width:120px;">작성자</th>
                            <td>${board.id}</td>
                        </tr>
                        <tr>
                            <th>등록일</th>
                            <td><fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            <th>조회수</th>
                            <td>${board.cnt}</td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td colspan="3">${board.title}</td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td colspan="3">
                                <div style="min-height:200px; white-space:pre-wrap;">${board.textarea}</div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <!-- 버튼 영역 -->
            <div class="btn-area" style="margin-top:20px; text-align:center;">
                <a href="${ctx}/admin/board/list" class="btn btn-secondary">
                    <i class="bi bi-list"></i> 목록으로
                </a>
            </div>

        </main>

        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>

    </div>
</div>

<script>
    function deleteBoard(idx) {
        if(confirm('정말 삭제하시겠습니까?\n게시글 번호: ' + idx)) {
            location.href = '${ctx}/admin/board/delete/' + idx;
        }
    }
</script>
</body>
</html>
