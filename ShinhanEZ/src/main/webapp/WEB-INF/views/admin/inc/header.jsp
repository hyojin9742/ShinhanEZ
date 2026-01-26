<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctx = request.getContextPath(); %>

<style>
/* 검색 드롭다운 스타일 */
.header-search-wrap { position: relative; }
.search-dropdown {
    position: absolute;
    top: 100%;
    left: 0;
    width: 350px;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    display: none;
    z-index: 1001;
    margin-top: 5px;
    max-height: 400px;
    overflow-y: auto;
}
.search-dropdown.show { display: block; }
.search-section { padding: 10px 0; border-bottom: 1px solid #eee; }
.search-section:last-child { border-bottom: none; }
.search-section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 15px;
    font-size: 12px;
    color: #666;
    font-weight: 600;
}
.search-section-header i { margin-right: 5px; }
.clear-btn {
    background: none;
    border: none;
    color: #999;
    font-size: 11px;
    cursor: pointer;
}
.clear-btn:hover { color: #dc3545; }
.search-list { list-style: none; padding: 0; margin: 0; }
.search-list li {
    padding: 10px 15px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 10px;
    transition: background 0.2s;
}
.search-list li:hover { background: #f8f9fa; }
.search-list li i { color: #999; font-size: 14px; }
.search-list li .text { flex: 1; font-size: 14px; color: #333; }
.search-list li .remove-btn {
    color: #ccc;
    font-size: 12px;
    padding: 2px;
}
.search-list li .remove-btn:hover { color: #dc3545; }
.search-category {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 10px;
    font-size: 11px;
    margin-right: 8px;
}
.search-category.customer { background: #e7f1ff; color: #0d6efd; }
.search-category.contract { background: #d1e7dd; color: #198754; }
.search-category.product { background: #fff3cd; color: #856404; }
.search-category.notice { background: #f8d7da; color: #842029; }
.search-category.menu { background: #e2d9f3; color: #6f42c1; }
.no-result { padding: 20px; text-align: center; color: #999; font-size: 13px; }
</style>

<!-- 상단 헤더 -->
<header class="admin-header">
    <div class="header-search-wrap">
        <form action="<%=ctx%>/admin/search" method="get" class="header-search" onsubmit="saveRecentSearch()">
            <i class="bi bi-search"></i>
            <input type="text" id="globalSearchInput" name="keyword" placeholder="검색어를 입력하세요" autocomplete="off">
        </form>
        <!-- 검색 드롭다운 -->
        <div class="search-dropdown" id="searchDropdown">
            <!-- 최근 검색어 -->
            <div class="search-section" id="recentSearchSection">
                <div class="search-section-header">
                    <span><i class="bi bi-clock-history"></i> 최근 검색어</span>
                    <button type="button" onclick="clearRecentSearch()" class="clear-btn">전체삭제</button>
                </div>
                <ul class="search-list" id="recentSearchList"></ul>
            </div>
            <!-- 연관 검색 / 메뉴 -->
            <div class="search-section" id="suggestSection" style="display:none;">
                <div class="search-section-header">
                    <span><i class="bi bi-lightning"></i> 연관 검색</span>
                </div>
                <ul class="search-list" id="suggestList"></ul>
            </div>
        </div>
    </div>

    <div class="header-right">
        <div class="header-icons">
            <a href="#" title="설정"><i class="bi bi-gear"></i></a>
            <a href="#" title="알림"><i class="bi bi-bell"></i></a>
            <a href="<%=ctx%>/index.jsp" title="사이트 이동"><i class="bi bi-house"></i></a>
        </div>
        <div class="header-user">
            <i class="bi bi-person-circle"></i>
            <c:choose>
                <c:when test="${sessionScope.adminRole == 'super'}">
                    <span>${sessionScope.adminName}(관리자)님</span>
                </c:when>
                <c:when test="${sessionScope.adminRole == 'manager'}">
                    <span>${sessionScope.adminName}(매니저)님</span>
                </c:when>
                <c:otherwise>
                    <span>${sessionScope.adminName}(스태프)님</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- 검색 및 세션 관리 스크립트 -->
<script>
(function() {
    var ctx = '<%=ctx%>';

    // ====== 통합 검색 기능 ======
    var searchInput = document.getElementById('globalSearchInput');
    var dropdown = document.getElementById('searchDropdown');
    var recentList = document.getElementById('recentSearchList');
    var suggestSection = document.getElementById('suggestSection');
    var suggestList = document.getElementById('suggestList');

    // 관리자 메뉴 목록
    var adminMenus = [
        { name: '대시보드', url: ctx + '/admin/index', category: 'menu' },
        { name: '고객관리', url: ctx + '/admin/customer/list', category: 'menu' },
        { name: '고객등록', url: ctx + '/admin/customer/register', category: 'menu' },
        { name: '계약관리', url: ctx + '/admin/contract', category: 'menu' },
        { name: '계약등록', url: ctx + '/admin/contract/register', category: 'menu' },
        { name: '보험상품관리', url: ctx + '/admin/insurance/list', category: 'menu' },
        { name: '상품등록', url: ctx + '/admin/insurance/register', category: 'menu' },
        { name: '납입내역', url: ctx + '/admin/payment/list', category: 'menu' },
        { name: '보험금청구', url: ctx + '/admin/claims/list', category: 'menu' },
        { name: '공지사항', url: ctx + '/admin/notice/list', category: 'menu' },
        { name: '공지사항작성', url: ctx + '/admin/notice/write', category: 'menu' },
        { name: '게시판관리', url: ctx + '/admin/board', category: 'menu' },
        { name: '관리자설정', url: ctx + '/admin/settings', category: 'menu' }
    ];

    // 최근 검색어 로드
    function loadRecentSearch() {
        var recent = JSON.parse(localStorage.getItem('adminRecentSearch') || '[]');
        if (recent.length === 0) {
            recentList.innerHTML = '<li class="no-result">최근 검색어가 없습니다.</li>';
            return;
        }
        recentList.innerHTML = recent.map(function(item, idx) {
            return '<li onclick="goSearch(\'' + item + '\')">' +
                   '<i class="bi bi-clock"></i>' +
                   '<span class="text">' + item + '</span>' +
                   '<span class="remove-btn" onclick="event.stopPropagation();removeRecent(' + idx + ')"><i class="bi bi-x"></i></span>' +
                   '</li>';
        }).join('');
    }

    // 연관 검색 (메뉴 + 키워드)
    function showSuggestions(keyword) {
        if (!keyword || keyword.length < 1) {
            suggestSection.style.display = 'none';
            return;
        }

        var matches = adminMenus.filter(function(m) {
            return m.name.toLowerCase().includes(keyword.toLowerCase());
        });

        if (matches.length === 0) {
            suggestSection.style.display = 'none';
            return;
        }

        suggestSection.style.display = 'block';
        suggestList.innerHTML = matches.slice(0, 6).map(function(item) {
            return '<li onclick="location.href=\'' + item.url + '\'">' +
                   '<span class="search-category menu">메뉴</span>' +
                   '<span class="text">' + item.name + '</span>' +
                   '</li>';
        }).join('');
    }

    // 이벤트 바인딩
    if (searchInput) {
        searchInput.addEventListener('focus', function() {
            loadRecentSearch();
            dropdown.classList.add('show');
        });

        searchInput.addEventListener('input', function() {
            showSuggestions(this.value);
        });

        searchInput.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                dropdown.classList.remove('show');
                this.blur();
            }
        });
    }

    // 외부 클릭 시 드롭다운 닫기
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.header-search-wrap')) {
            dropdown.classList.remove('show');
        }
    });

    // 전역 함수들
    window.goSearch = function(keyword) {
        searchInput.value = keyword;
        saveRecentSearch();
        location.href = ctx + '/admin/search?keyword=' + encodeURIComponent(keyword);
    };

    window.saveRecentSearch = function() {
        var keyword = searchInput.value.trim();
        if (!keyword) return;

        var recent = JSON.parse(localStorage.getItem('adminRecentSearch') || '[]');
        recent = recent.filter(function(item) { return item !== keyword; });
        recent.unshift(keyword);
        recent = recent.slice(0, 10);
        localStorage.setItem('adminRecentSearch', JSON.stringify(recent));
    };

    window.removeRecent = function(idx) {
        var recent = JSON.parse(localStorage.getItem('adminRecentSearch') || '[]');
        recent.splice(idx, 1);
        localStorage.setItem('adminRecentSearch', JSON.stringify(recent));
        loadRecentSearch();
    };

    window.clearRecentSearch = function() {
        localStorage.removeItem('adminRecentSearch');
        loadRecentSearch();
    };

    // ====== 세션 타임아웃 ======
    var sessionTimeout = 10 * 60 * 1000;
    var logoutTimer;

    function resetTimer() {
        clearTimeout(logoutTimer);
        logoutTimer = setTimeout(function() {
            alert('10분간 입력이 없어 세션이 종료됩니다.');
            window.location.href = ctx + '/member/logout';
        }, sessionTimeout);
    }

    document.addEventListener('keydown', resetTimer);
    document.addEventListener('click', resetTimer);
    resetTimer();
})();
</script>
