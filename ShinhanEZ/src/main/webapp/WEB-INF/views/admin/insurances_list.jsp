<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <style>
        /* 페이징 버튼 스타일 추가 */
        #pagination { margin-top: 20px; text-align: center; }
        #pagination button { margin: 0 2px; padding: 5px 10px; border: 1px solid #ddd; background: #fff; cursor: pointer; border-radius: 4px; }
        #pagination button.active { background-color: #007bff; color: white; border-color: #007bff; }
        #pagination button:hover:not(.active) { background-color: #f1f1f1; }
        
        /* 검색바 스타일 */
        .search-toolbar { display: flex; justify-content: space-between; align-items: center; padding: 10px 15px; background-color: #f8f9fa; border-bottom: 1px solid #eee; }
        .search-group { display: flex; gap: 8px; align-items: center; }
    </style>
</head>

<body class="admin-page">
<div class="admin-wrapper">

    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="Insurance"/>
    </jsp:include>

    <div class="admin-main">

        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="상품관리"/>
        </jsp:include>

        <main class="admin-content">

            <div class="page-header">
                <h2>상품 목록</h2>
                <p>등록된 보험상품 정보를 관리합니다.</p>
            </div>

            <div class="card">
                
                <div class="card-header">
                    <span><i class="bi bi-box-seam"></i> 상품 목록</span>
                </div>

                <div class="search-toolbar">
                    <div class="search-group">
                        <select id="searchStatus" class="form-control" style="width: 130px;" onchange="loadBoard(1)">
                            <option value="all">전체 상태</option>
                            <option value="ACTIVE">활성 (ACTIVE)</option>
                            <option value="INACTIVE">비활성 (INACTIVE)</option>
                        </select>
                        
                        <input type="text" id="searchKeyword" class="form-control" placeholder="상품명 검색" style="width: 250px;" 
                               onkeyup="if(window.event.keyCode==13){loadBoard(1)}">
                        
                        <button type="button" class="btn btn-primary" onclick="loadBoard(1)">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>

                    <div class="action-group">
                        <a href="${ctx}/admin/insurance/register" class="btn btn-sm btn-primary">
                            <i class="bi bi-plus-lg"></i> 상품 등록
                        </a>
                    </div>
                </div>

                <div class="card-body" style="padding:0;">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th style="width:80px; text-align: center;">번호</th>
                            <th>상품명</th>
                            <th style="width:100px; text-align: center;">분류</th>
                            <th style="width:120px; text-align: center;">기본 보험료</th>
                            <th style="text-align: center;">보장 범위</th>
                            <th style="width:90px; text-align: center;">기간</th>
                            <th style="width:90px; text-align: center;">상태</th>
                            <th style="width:120px; text-align: center;">등록일</th>
                            <th style="width:140px; text-align: center;">관리</th>
                        </tr>
                        </thead>

                        <tbody id="plan-board">
                        </tbody>
                    </table>
                </div>
                
                <div id="pagination"></div>
                <br> </div>

        </main>

        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 페이지 로드 시 자동으로 1페이지 요청
    document.addEventListener("DOMContentLoaded", () => {
        loadBoard(1);
    });

    
	// 게시판 로드
    function loadBoard(pageNum = 1) {
        // 검색 값 가져오기
        const status = document.getElementById("searchStatus").value;
        const keyword = document.getElementById("searchKeyword").value;

        // API 주소 구성 (문자열 인코딩 처리)
        const url = `${ctx}/admin/insurance/api/list?pageNum=\${pageNum}&status=\${status}&keyword=\${encodeURIComponent(keyword)}`;

        fetch(url)
            .then(res => res.json())
            .then(data => {
                renderList(data.list);     // 리스트 그리기
                renderPaging(data.paging); // 페이징 버튼 그리기
            })
            .catch(err => console.error("Error loading board:", err));
    }

    
	// 리스트 렌더링 함수
    function renderList(list) {
        const tbody = document.getElementById("plan-board");
        let html = "";

        if (!list || list.length === 0) {
            tbody.innerHTML = `<tr><td colspan="9" style="text-align:center; padding: 40px;">검색된 상품이 없습니다.</td></tr>`;
            return;
        }

        list.forEach(item => {
            // 숫자 3자리 콤마
            const premium = item.basePremium ? item.basePremium.toLocaleString() : 0;
            // 날짜 포맷 (YYYY-MM-DD)
            const dateStr = item.createdDate ? new Date(item.createdDate).toISOString().substring(0, 10) : '-';
            // 상태 뱃지 스타일
            const statusBadge = item.status === 'ACTIVE' 
                ? '<span class="badge badge-success" style="color:green; font-weight:bold;">ACTIVE</span>' 
                : '<span class="badge badge-secondary" style="color:gray;">INACTIVE</span>';

            html += `
            <tr>
                <td><strong>\${item.productNo}</strong></td>
                <td style="text-align:left;">\${item.productName}</td>
                <td>\${item.category}</td>
                <td style="text-align:right;">\${premium} 원</td>
                <td>\${item.coverageRange}</td>
                <td>\${item.coveragePeriod}개월</td>
                <td>\${statusBadge}</td>
                <td>\${dateStr}</td>
                <td>
                    <a href="${ctx}/admin/insurance/get?productNo=\${item.productNo}" class="btn btn-sm btn-outline" title="상세"><i class="bi bi-eye"></i></a>
                    <a href="${ctx}/admin/insurance/edit?productNo=\${item.productNo}" class="btn btn-sm btn-outline" title="수정"><i class="bi bi-pencil"></i></a>
                </td>
            </tr>`;
        });

        tbody.innerHTML = html;
    }

    
	//페이징 렌더링 함수
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

    
	
</script>

</body>
</html>