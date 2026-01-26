<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <style>
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        textarea.form-control { min-height: 300px; resize: vertical; }
        .btn-area { margin-top: 30px; text-align: center; }
        .btn-area .btn { margin: 0 5px; }
    </style>
</head>

<body class="admin-page">
<div class="admin-wrapper">

    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="notice"/>
    </jsp:include>

    <div class="admin-main">

        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="공지사항"/>
        </jsp:include>

        <main class="admin-content">

            <div class="page-header">
                <h2>공지사항 작성</h2>
                <p>새로운 공지사항을 작성합니다.</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-pencil"></i> 글쓰기</span>
                </div>

                <div class="card-body">
                    <form action="${ctx}/admin/notice/write" method="post">

                        <div class="form-group">
                            <label class="form-label">제목 *</label>
                            <input type="text" class="form-control" name="title" placeholder="제목을 입력하세요" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">내용 *</label>
                            <textarea class="form-control" name="textarea" placeholder="내용을 입력하세요" required></textarea>
                        </div>

                        <div class="btn-area">
                            <button type="submit" class="btn btn-primary">등록</button>
                            <button type="reset" class="btn btn-outline">초기화</button>
                            <a href="${ctx}/admin/notice/list" class="btn btn-secondary">목록</a>
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
