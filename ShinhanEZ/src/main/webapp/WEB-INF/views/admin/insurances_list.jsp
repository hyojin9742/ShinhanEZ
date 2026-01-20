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
        <jsp:param name="menu" value="Insurance"/>
    </jsp:include>

    <!-- 메인 영역 -->
    <div class="admin-main">

        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="상품관리"/>
        </jsp:include>

        <!-- 콘텐츠 -->
        <main class="admin-content">

            <!-- 페이지 타이틀 -->
            <div class="page-header">
                <h2>상품 목록</h2>
                <p>등록된 보험상품 정보를 관리합니다.</p>
            </div>
            
            <button id="aa">aaa</button>

            <!-- 상품 목록 카드 -->
            <div class="card">
                <div class="card-header">
                    <span>
                        <i class="bi bi-box-seam"></i>
                        상품 목록 (총 <strong>${insurances.size()}</strong>건)
                    </span>
                    <a href="${ctx}/admin/insurance/register" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg"></i> 상품 등록
                    </a>
                     <a href="${ctx}/admin/insurance/register" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg"></i> 활성
                    </a>
                     <a href="${ctx}/admin/insurance/register" class="btn btn-sm btn-primary">
                        <i class="bi bi-plus-lg"></i> 비활성
                    </a>
                </div>
                        
                
				
                <button onclick="statustChange()">상태변경버튼</button>
                입력: <input type="text" id="input"/>
				

                <div class="card-body" style="padding:0;">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th style="width:90px;">상품번호</th>
                            <th>상품명</th>
                            <th style="width:120px;">분류</th>
                            <th style="width:110px;">기본 보험료</th>
                            <th>보장 범위</th>
                            <th style="width:90px;">기간</th>
                            <th style="width:90px;">상태
                            	<select id="statusOption">
                            		<option value="all">ALL</option>
                            		<option value="ACTIVE">ACTIVE</option>
                            		<option value="INACTIVE">INACTIVE</option>
                            	
                            	</select>
                            </th>
                            <th style="width:120px;">등록일</th>
                            <th style="width:140px;">관리</th>
                        </tr>
                        </thead>

                        <tbody id="plan-board">
                        <c:forEach var="insurance" items="${insurances}">
                            <tr>
                                <td><strong>${insurance.productNo}</strong></td>
                                <td>${insurance.productName}</td>
                                <td>${insurance.category}</td>
                                <td>
                                    <fmt:formatNumber value="${insurance.basePremium}" type="number"/> 원
                                </td>
                                <td>${insurance.coverageRange}</td>
                                <td>${insurance.coveragePeriod}개월</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${insurance.status eq 'ACTIVE'}">
                                            <span class="badge badge-success">ACTIVE</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">INACTIVE</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${insurance.createdDate}" pattern="yyyy-MM-dd"/>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/insurance/get?productNo=${insurance.productNo}"
                                       class="btn btn-sm btn-outline" title="상세">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="${ctx}/admin/insurance/edit?productNo=${insurance.productNo}"
                                       class="btn btn-sm btn-outline" title="수정">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <button type="button"
                                            class="btn btn-sm btn-outline-danger"
                                            onclick="deleteInsurance('${insurance.productNo}')"
                                            title="삭제">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="filter-box" style="margin-bottom: 10px; display: flex; gap: 10px; align-items: center;">
    <select id="statusOption" class="form-control" style="width: 120px;" onchange="loadBoard(1)">
        <option value="all">전체 상태</option>
        <option value="ACTIVE">활성 (ACTIVE)</option>
        <option value="INACTIVE">비활성 (INACTIVE)</option>
    </select>
    
    <input type="text" id="searchInput" class="form-control" placeholder="상품명 검색" style="width: 200px;" 
           onkeyup="if(window.event.keyCode==13){loadBoard(1)}">
    
    <button type="button" class="btn btn-primary" onclick="loadBoard(1)">
        <i class="bi bi-search"></i> 검색
    </button>
</div>
            

        </main>

        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function deleteInsurance(productNo) {
        if (confirm('정말 삭제하시겠습니까?\n상품번호: ' + productNo)) {
            location.href = '${ctx}/admin/insurance/delete?productNo=' + productNo;
        }
    }
    
    
    let statusOption= document.getElementById("statusOption");
    // 리스트 만들기
    function statustChange() {
    	let statusOptions= document.getElementById("statusOption").value;
	    fetch("/admin/insurance/list2", { method: "POST", headers:{"Content-Type": "application/x-www-form-urlencoded"},body:"status="+statusOptions })
	        .then(res => res.json())
	        .then(data =>{
	        	console.log(data);
	        	const tbody=document.getElementById("plan-board");
	        	tbody.innerHTML="";
	        	let html="";
	        	data.forEach(insurance=>{
	        		html+=`<tr>
                        <td><strong>\${insurance.productNo}</strong></td>
                        <td>\${insurance.productName}</td>
                        <td>\${insurance.category}</td>
                        <td>
                            \${Number(insurance.basePremium).toLocaleString()}원
                        </td>
                        <td>\${insurance.coverageRange}</td>
                        <td>\${insurance.coveragePeriod}개월</td>
                        <td>
                        	\${insurance.status=='ACTIVE'
                        		?	'<span class="badge badge-success">ACTIVE</span>'
								:	'<span class="badge badge-secondary">INACTIVE</span>'                                				
                        	}    
                        </td>
                        <td>
                        	\${insurance.createdDate.substring(0,10)}
                        </td>
                        <td>
                            <a href="/admin/insurance/get?productNo=\${insurance.productNo}"
                               class="btn btn-sm btn-outline" title="상세">
                                <i class="bi bi-eye"></i>
                            </a>
                            <a href="/admin/insurance/edit?productNo=\${insurance.productNo}""
                               class="btn btn-sm btn-outline" title="수정">
                                <i class="bi bi-pencil"></i>
                            </a>
                            <button type="button"
                                    class="btn btn-sm btn-outline-danger"
                                    onclick="deleteInsurance('${insurance.productNo}')"
                                    title="삭제">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>`
	        	});
	        	tbody.innerHTML = html;
	        });
	}
    statusOption.addEventListener("change", statustChange);
      
</script>




<script>
// 전역 변수 (필요시 사용)
let currentPage = 1;

/**
 * 게시판 데이터 로드 (AJAX)
 * @param pageNum : 불러올 페이지 번호 (기본값 1)
 */
function loadBoard(pageNum = 1) {
    currentPage = pageNum;

    // 1. 검색 조건 가져오기
    const status = document.getElementById("statusOption").value;
    const keyword = document.getElementById("searchInput").value; // 검색어 추가

    // 2. Fetch API 호출 (Query String에 검색어 포함)
    // encodeURIComponent를 사용하여 한글이나 특수문자 깨짐 방지
    const url = `/admin/insurance/list?pageNum=\${pageNum}&status=\${status}&keyword=\${encodeURIComponent(keyword)}`;

    fetch(url)
        .then(res => res.json())
        .then(data => {
            renderList(data.list);     // 리스트 그리기
            renderPaging(data.paging); // 페이징 버튼 그리기
        })
        .catch(err => console.error("Error loading board:", err));
}

// 리스트 렌더링
function renderList(list) {
    const tbody = document.getElementById("plan-board");
    let html = "";

    if (!list || list.length === 0) {
        tbody.innerHTML = `<tr><td colspan="9" style="text-align:center; padding: 20px;">검색된 상품이 없습니다.</td></tr>`;
        return;
    }

    list.forEach(i => {
        // 숫자 3자리 콤마
        const premium = i.basePremium ? i.basePremium.toLocaleString() : 0;
        // 날짜 포맷 (YYYY-MM-DD)
        const dateStr = i.createdDate ? new Date(i.createdDate).toISOString().substring(0, 10) : '-';
        // 상태 뱃지
        const statusBadge = i.status === 'ACTIVE' 
            ? '<span class="badge badge-success" style="color:green; font-weight:bold;">ACTIVE</span>' 
            : '<span class="badge badge-secondary" style="color:gray;">INACTIVE</span>';

        html += `
        <tr>
            <td><strong>\${i.productNo}</strong></td>
            <td>\${i.productName}</td>
            <td>\${i.category}</td>
            <td>\${premium} 원</td>
            <td>\${i.coverageRange}</td>
            <td>\${i.coveragePeriod}개월</td>
            <td>\${statusBadge}</td>
            <td>\${dateStr}</td>
            <td>
                <a href="/admin/insurance/get?productNo=\${i.productNo}" class="btn btn-sm btn-outline"><i class="bi bi-eye"></i></a>
                <a href="/admin/insurance/edit?productNo=\${i.productNo}" class="btn btn-sm btn-outline"><i class="bi bi-pencil"></i></a>
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteInsurance('\${i.productNo}')"><i class="bi bi-trash"></i></button>
            </td>
        </tr>`;
    });

    tbody.innerHTML = html;
}

// 페이징 렌더링
function renderPaging(p) {
    const div = document.getElementById("pagination"); // JSP에 <div id="pagination"></div> 필요
    if(!div) return;

    let html = "";

    // [이전] 버튼 (prev가 있을 때만)
    if (p.hasPrev) { // Paging 클래스의 hasPrev() 로직에 따름
        html += `<button onclick="loadBoard(\${p.startPage - 1})" class="btn btn-sm btn-outline-secondary">&lt;</button> `;
    }

    // [페이지 번호]
    for (let i = p.startPage; i <= p.endPage; i++) {
        if (i === p.pageNum) {
            html += `<button class="btn btn-sm btn-primary active" disabled>\${i}</button> `;
        } else {
            html += `<button onclick="loadBoard(\${i})" class="btn btn-sm btn-outline-primary">\${i}</button> `;
        }
    }

    // [다음] 버튼 (next가 있을 때만)
    if (p.hasNext) { // Paging 클래스의 hasNext() 로직에 따름
        html += `<button onclick="loadBoard(\${p.endPage + 1})" class="btn btn-sm btn-outline-secondary">&gt;</button>`;
    }

    div.innerHTML = html;
}

// 페이지 로드 시 초기화
document.addEventListener("DOMContentLoaded", () => {
    loadBoard(1);
});

// 삭제 함수 유지
function deleteInsurance(productNo) {
    if (confirm('정말 삭제하시겠습니까?\n상품번호: ' + productNo)) {
        location.href = '${ctx}/admin/insurance/delete?productNo=' + productNo;
    }
}
</script>

</body>
</html>
