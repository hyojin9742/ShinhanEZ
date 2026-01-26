<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <style>
        #pagination { margin-top: 20px; text-align: center; }
        #pagination button { margin: 0 2px; padding: 5px 10px; border: 1px solid #ddd; background: #fff; cursor: pointer; border-radius: 4px; }
        #pagination button.active { background-color: #007bff; color: white; border-color: #007bff; }
        #pagination button:hover:not(.active) { background-color: #f1f1f1; }
        .search-toolbar { display: flex; justify-content: space-between; align-items: center; padding: 10px 15px; background-color: #f8f9fa; border-bottom: 1px solid #eee; }
        .search-group { display: flex; gap: 8px; align-items: center; }
        .btn-group-inline { display: flex; gap: 4px; justify-content: center; align-items: center; }
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
                <h2>공지사항 관리</h2>
                <p>미디어룸에 표시될 공지사항을 관리합니다.</p>
            </div>

            <div class="card">

                <div class="card-header">
                    <span><i class="bi bi-megaphone"></i> 공지사항 목록</span>
                </div>

                <div class="search-toolbar">
                    <div class="search-group">
                        <input type="text" id="searchKeyword" class="form-control" placeholder="제목/내용 검색" style="width: 250px;"
                               onkeyup="if(window.event.keyCode==13){loadBoard(1)}">

                        <button type="button" class="btn btn-primary" onclick="loadBoard(1)">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>

                    <div class="action-group">
                        <a href="${ctx}/admin/notice/write" class="btn btn-sm btn-primary">
                            <i class="bi bi-plus-lg"></i> 글쓰기
                        </a>
                    </div>
                </div>

                <div class="card-body" style="padding:0;">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th style="width:80px; text-align: center;">번호</th>
                            <th>제목</th>
                            <th style="width:100px; text-align: center;">작성자</th>
                            <th style="width:80px; text-align: center;">조회수</th>
                            <th style="width:120px; text-align: center;">등록일</th>
                            <th style="width:140px; text-align: center;">관리</th>
                        </tr>
                        </thead>

                        <tbody id="notice-board">
                        </tbody>
                    </table>
                </div>

                <div id="pagination"></div>
                <br>
            </div>

        </main>

        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        loadBoard(1);
    });

    function loadBoard(pageNum = 1) {
        const keyword = document.getElementById("searchKeyword").value;
        const url = `${ctx}/admin/notice/api/list?pageNum=\${pageNum}&keyword=\${encodeURIComponent(keyword)}`;

        fetch(url)
            .then(res => res.json())
            .then(data => {
                renderList(data.list);
                renderPaging(data.paging);
            })
            .catch(err => console.error("Error loading board:", err));
    }

    function renderList(list) {
        const tbody = document.getElementById("notice-board");
        let html = "";

        if (!list || list.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding: 40px;">등록된 공지사항이 없습니다.</td></tr>`;
            return;
        }

        list.forEach(item => {
            const dateStr = item.regDate ? new Date(item.regDate).toISOString().substring(0, 10) : '-';

            html += `
            <tr>
                <td style="text-align:center;"><strong>\${item.idx}</strong></td>
                <td style="text-align:left;"><a href="${ctx}/admin/notice/view?idx=\${item.idx}" style="color:#333; text-decoration:none;">\${item.title}</a></td>
                <td style="text-align:center;">\${item.id}</td>
                <td style="text-align:center;">\${item.cnt}</td>
                <td style="text-align:center;">\${dateStr}</td>
                <td>
                    <div class="btn-group-inline">
                        <a href="${ctx}/admin/notice/view?idx=\${item.idx}" class="btn btn-sm btn-outline" title="상세"><i class="bi bi-eye"></i></a>
                        <a href="${ctx}/admin/notice/edit?idx=\${item.idx}" class="btn btn-sm btn-outline" title="수정"><i class="bi bi-pencil"></i></a>
                        <button type="button" class="btn btn-sm btn-outline" title="삭제" onclick="deleteNotice(\${item.idx})" style="color:#dc3545;"><i class="bi bi-trash"></i></button>
                    </div>
                </td>
            </tr>`;
        });

        tbody.innerHTML = html;
    }

    function renderPaging(p) {
        const div = document.getElementById("pagination");
        let html = "";

        if (p.hasPrev) {
            html += `<button onclick="loadBoard(\${p.pageNum - 1})">&lt;</button> `;
        }

        for (let i = p.startPage; i <= p.endPage; i++) {
            if (i === p.pageNum) {
                html += `<button class="active" disabled>\${i}</button> `;
            } else {
                html += `<button onclick="loadBoard(\${i})">\${i}</button> `;
            }
        }

        if (p.hasNext) {
            html += `<button onclick="loadBoard(\${p.pageNum + 1})">&gt;</button>`;
        }

        div.innerHTML = html;
    }

    function deleteNotice(idx) {
        if (confirm('정말 삭제하시겠습니까?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${ctx}/admin/notice/delete';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'idx';
            input.value = idx;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

</body>
</html>
