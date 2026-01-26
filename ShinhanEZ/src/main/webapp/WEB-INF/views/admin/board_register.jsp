<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
                <h2>게시글 등록</h2>
                <p>새 게시글을 등록합니다. (프론트 미디어룸에 노출됩니다)</p>
            </div>

            <!-- 게시글 등록 폼 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-pencil-square"></i> 게시글 작성</span>
                </div>
                <div class="card-body">
                    <form action="${ctx}/admin/board/register" method="post">
                        <table class="detail-table">
                            <tr>
                                <th style="width:120px;"><label for="title">제목</label></th>
                                <td>
                                    <input type="text" id="title" name="title" class="form-control"
                                           placeholder="제목을 입력하세요" required>
                                </td>
                            </tr>
                            <tr>
                                <th><label for="textarea">내용</label></th>
                                <td>
                                    <textarea id="textarea" name="textarea" class="form-control"
                                              rows="15" placeholder="내용을 입력하세요" required></textarea>
                                </td>
                            </tr>
                        </table>

                        <!-- 버튼 영역 -->
                        <div class="btn-area center">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg"></i> 등록
                            </button>
                            <a href="${ctx}/admin/board/list" class="btn btn-secondary">
                                <i class="bi bi-x-lg"></i> 취소
                            </a>
                        </div>
                    </form>
                </div>
            </div>

        </main>

        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>

    </div>
</div>
</body>
</html>
