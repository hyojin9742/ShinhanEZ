<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <style>
        .view-table { width: 100%; border-collapse: collapse; }
        .view-table th { width: 140px; background: var(--bg-light); padding: 15px 20px; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 500; color: var(--text-dark); }
        .view-table td { padding: 15px 20px; border-bottom: 1px solid var(--border-color); }
        .view-content { min-height: 200px; white-space: pre-wrap; line-height: 1.8; background: #fafafa; padding: 20px; border-radius: 8px; }
        .btn-area {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
        }
        .btn-area .btn-group-left { display: flex; gap: 8px; }
        .btn-area .btn-group-right { display: flex; gap: 8px; }
        .btn { padding: 10px 20px; font-size: 14px; }
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
                <h2>공지사항 상세</h2>
            </div>

            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-file-text"></i> 상세보기</span>
                </div>

                <div class="card-body">
                    <table class="view-table">
                        <tr>
                            <th>번호</th>
                            <td>${board.idx}</td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td>${board.title}</td>
                        </tr>
                        <tr>
                            <th>작성자</th>
                            <td>${board.id}</td>
                        </tr>
                        <tr>
                            <th>등록일</th>
                            <td><fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd"/></td>
                        </tr>
                        <tr>
                            <th>조회수</th>
                            <td>${board.cnt}</td>
                        </tr>
                        <tr>
                            <th>상태</th>
                            <c:choose>
                            	<c:when test="${board.status == 'Y' }">
                            		<td>활성</td>
                            	</c:when>
                            	<c:otherwise>
                            		<td>비활성</td>
                            	</c:otherwise>
                            </c:choose>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td class="view-content">${board.textarea}</td>
                        </tr>
                    </table>

                    <div class="btn-area">
                        <a href="${ctx}/admin/notice/list" class="btn btn-secondary">목록</a>
                        <form action="${ctx}/admin/notice/delete" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                            <input type="hidden" name="idx" value="${board.idx}">
                            <button type="submit" class="btn btn-danger">삭제</button>
                        </form>
						<a href="${ctx}/admin/notice/edit?idx=${board.idx}" class="btn btn-primary">수정</a>
                    </div>
                </div>
            </div>

        </main>

        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>
</body>
</html>
