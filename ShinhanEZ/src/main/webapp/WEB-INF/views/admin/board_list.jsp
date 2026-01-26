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
                <h2>게시판 목록</h2>
                <p>미디어룸 게시글을 관리합니다.</p>
            </div>

            <!-- 알림 메시지 -->
            <c:if test="${not empty message}">
                <div class="alert alert-success" style="margin-bottom:20px;">
                    <i class="bi bi-check-circle"></i> ${message}
                </div>
            </c:if>
            <c:if test="${param.error == 'permission'}">
                <div class="alert alert-danger" style="margin-bottom:20px;">
                    <i class="bi bi-exclamation-circle"></i> 권한이 없습니다. (super/manager 권한 필요)
                </div>
            </c:if>

            <!-- 게시판 목록 카드 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-file-text"></i> 게시글 목록 (총 <strong>${totalCount}</strong>건)</span>
                    <c:if test="${canModify}">
                        <a href="${ctx}/admin/board/register" class="btn btn-sm btn-primary">
                            <i class="bi bi-plus-lg"></i> 글쓰기
                        </a>
                    </c:if>
                </div>
                <div class="card-body" style="padding:0;">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th style="width:80px;">번호</th>
                                <th>제목</th>
                                <th style="width:100px;">작성자</th>
                                <th style="width:80px;">조회수</th>
                                <th style="width:120px;">등록일</th>
                                <th style="width:150px;">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="board" items="${boardList}">
                            <tr>
                                <td><strong>${board.idx}</strong></td>
                                <td style="text-align:left;">
                                    <a href="${ctx}/admin/board/view/${board.idx}">${board.title}</a>
                                </td>
                                <td>${board.id}</td>
                                <td>${board.cnt}</td>
                                <td><fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <a href="${ctx}/admin/board/view/${board.idx}"
                                       class="btn btn-sm btn-outline" title="상세보기">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <c:if test="${canModify}">
                                        <a href="${ctx}/admin/board/edit/${board.idx}"
                                           class="btn btn-sm btn-outline" title="수정">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button" class="btn btn-sm btn-outline-danger"
                                                onclick="deleteBoard(${board.idx})" title="삭제">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty boardList}">
                            <tr>
                                <td colspan="6" class="text-center" style="padding:40px;">
                                    <i class="bi bi-inbox" style="font-size:48px;color:#ccc;"></i>
                                    <p style="margin-top:10px;color:#999;">등록된 게시글이 없습니다.</p>
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
    function deleteBoard(idx) {
        if(confirm('정말 삭제하시겠습니까?\n게시글 번호: ' + idx)) {
            location.href = '${ctx}/admin/board/delete/' + idx;
        }
    }
</script>
</body>
</html>
