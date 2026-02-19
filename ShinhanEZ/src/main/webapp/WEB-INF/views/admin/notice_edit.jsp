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
        .form-group.titleStatusWrap {display: flex;}
        .titleStatusWrap .form-group:first-child{width: 80%;margin-bottom: 0;}
        .titleStatusWrap .form-group:last-child{width: 19%; margin-left: 1%;margin-bottom: 0;}
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
                <h2>공지사항 수정</h2>
            </div>

            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-pencil-square"></i> 수정하기</span>
                </div>

                <div class="card-body">
                    <form action="${ctx}/admin/notice/edit" method="post">
                        <input type="hidden" name="idx" value="${board.idx}">
						<div class="form-group titleStatusWrap">
	                        <div class="form-group">
	                            <label class="form-label">제목 *</label>
	                            <input type="text" class="form-control" name="title" value="${board.title}" required>
	                        </div>
	                        <div class="form-group">
	                            <label class="form-label">상태</label>
	                            <select class="form-control" name="status" required>
	                                <option ${board.status=="Y"? "selected":""} value="Y">활성</option>
	                                <option ${board.status=="N"? "selected":""} value="N">비활성</option>
		                        </select>
	                        </div>
						</div>
                        <div class="form-group">
                            <label class="form-label">내용 *</label>
                            <textarea class="form-control" name="textarea" required>${board.textarea}</textarea>
                        </div>

                        <div class="btn-area">
                            <a href="${ctx}/admin/notice/list" class="btn btn-secondary">목록</a>
                            <a href="${ctx}/admin/notice/view?idx=${board.idx}" class="btn btn-outline">취소</a>
							<button type="submit" class="btn btn-primary">수정</button>
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
