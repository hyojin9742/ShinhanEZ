<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">

<head id="inc-head">
	<jsp:include page="/WEB-INF/views/inc/head.jsp"></jsp:include>
	<style>
		/* 게시판 리스트 스타일 */
		.bbs-top-area {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 20px;
			padding: 15px 0;
			border-bottom: 1px solid #e0e0e0;
		}
		.bbs-total {
			display: flex;
			align-items: center;
			gap: 8px;
		}
		.bbs-total .total-label {
			font-size: 14px;
			color: #666;
		}
		.bbs-total .total-count {
			font-size: 18px;
			font-weight: 700;
			color: #0066cc;
		}
		.bbs-search .search-form {
			display: flex;
			align-items: center;
			gap: 5px;
		}
		.bbs-search .search-select {
			padding: 8px 12px;
			border: 1px solid #ddd;
			border-radius: 4px;
			font-size: 14px;
			background: #fff;
		}
		.bbs-search .search-input {
			padding: 8px 12px;
			border: 1px solid #ddd;
			border-radius: 4px;
			font-size: 14px;
			width: 200px;
		}
		.bbs-search .search-btn {
			padding: 8px 15px;
			background: #0066cc;
			color: #fff;
			border: none;
			border-radius: 4px;
			cursor: pointer;
		}
		.bbs-search .search-btn:hover {
			background: #0052a3;
		}

		/* 파란색 헤더 */
		.bbs-head.blue-header {
			background: #0066cc !important;
			color: #fff !important;
		}
		.bbs-head.blue-header .bbs-column {
			color: #fff !important;
			font-weight: 600;
		}

		/* 새 글 N 배지 */
		.badge-new {
			display: inline-flex;
			align-items: center;
			justify-content: center;
			width: 18px;
			height: 18px;
			background: #ff3b30;
			color: #fff;
			font-size: 11px;
			font-weight: 700;
			border-radius: 3px;
			margin-left: 8px;
			vertical-align: middle;
		}

		/* 하단 버튼 영역 */
		.bbs-btn-area {
			display: flex;
			justify-content: center;
			gap: 15px;
			margin-top: 30px;
			padding-top: 20px;
		}
		.bbs-btn-area .btn {
			padding: 12px 30px;
			font-size: 15px;
			border-radius: 6px;
			text-decoration: none;
			display: inline-flex;
			align-items: center;
			gap: 8px;
		}
		.bbs-btn-area .btn.primary {
			background: #0066cc;
			color: #fff;
			border: none;
		}
		.bbs-btn-area .btn.primary:hover {
			background: #0052a3;
		}
		.bbs-btn-area .btn.blue-outline {
			background: #fff;
			color: #0066cc;
			border: 2px solid #0066cc;
		}
		.bbs-btn-area .btn.blue-outline:hover {
			background: #f0f7ff;
		}

		/* 제목 영역 */
		.bbs-column.bbs-tit .subject-area {
			display: flex;
			align-items: center;
		}
		.bbs-column.bbs-tit .subject-area a {
			color: #333;
			text-decoration: none;
		}
		.bbs-column.bbs-tit .subject-area a:hover {
			color: #0066cc;
			text-decoration: underline;
		}

		/* bbs-row 호버 효과 */
		.bbs-row:hover {
			background: #f8f9fa;
		}
	</style>
</head>
<c:if test="${param.error == 'permission'}">
	<script>alert('권한이 없습니다.');</script>
</c:if>
<body class="sub">

  <div id="wrap">
    <div id="skip">
      <div class="skip-menu">
        <a href="#">본문으로 건너뛰기</a>
      </div>
    </div>
    <!-- page -->
    <div id="page" data-page-main="true">
      <!-- header -->
      <header id="header" class="header">
      	<jsp:include page="/WEB-INF/views/inc/header.jsp"></jsp:include>
      </header>
      <!--//header-->
      <!--main-->
      <main id="main">
        <!-- content -->
        <article id="content">
          <!-- page-title -->
          <section class="page-title">
            <div class="inner-wrap">
              <h1 class="headline-lg">미디어룸</h1>
            </div>
          </section>
          <!--// page-title -->

          <!-- content-area -->
          <section class="content-area">
            <div class="inner-wrap">

              <!-- 상단 Total/검색 영역 -->
              <div class="bbs-top-area">
                <div class="bbs-total">
                  <span class="total-label">Total</span>
                  <span class="total-count">${totalCount != null ? totalCount : boardList.size()}</span>
                </div>
                <div class="bbs-search">
                  <form action="<%=ctx%>/board/list" method="get" class="search-form">
                    <select name="searchType" class="search-select">
                      <option value="title">제목</option>
                      <option value="content">내용</option>
                      <option value="writer">작성자</option>
                    </select>
                    <input type="text" name="keyword" class="search-input" placeholder="검색어를 입력하세요">
                    <button type="submit" class="search-btn"><i class="bi bi-search"></i></button>
                  </form>
                </div>
              </div>

              <!-- bbs-list -->
              <div class="bbs-list">

                <!-- bbs-table -->
                <div class="bbs-table">
                  <div class="bbs-caption sr-only">보도자료, 수상내역 게시판으로 번호, 제목, 첨부파일, 등록일 정보로 구성되어 있습니다.</div>
                <!-- bbs head -->
                <ul class="bbs-head blue-header">
                  <li class="bbs-column w-10">번호</li>
                  <li class="bbs-column w-55">제목</li>
                  <li class="bbs-column w-15">작성자</li>
                  <li class="bbs-column w-10">조회</li>
                  <li class="bbs-column w-10">등록일</li>
                </ul>
                <!--// bbs head -->

                <!-- bbs body -->
              	<ul class="bbs-body">
				<c:forEach var="board" items="${boardList}" varStatus="status">
                  <li class="bbs-row">
                    <div class="bbs-column bbs-num">${board.idx}</div>
                    <div class="bbs-column bbs-tit">
                      <div class="subject-area">
                        <a href="<%=ctx%>/board/view/${board.idx}">
                          <strong class="bbs-subject">${board.title}</strong>
                        </a>
                        <%-- 새 글 표시 (3일 이내) --%>
                        <c:set var="now" value="<%=new java.util.Date()%>"/>
                        <c:set var="diff" value="${(now.time - board.regDate.time) / (1000 * 60 * 60 * 24)}"/>
                        <c:if test="${diff <= 3}">
                          <span class="badge-new">N</span>
                        </c:if>
                      </div>
                    </div>
                    <div class="bbs-column bbs-writer">${board.id}</div>
                    <div class="bbs-column bbs-view">${board.cnt}</div>
                    <div class="bbs-column bbs-date"><fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd"/></div>
                  </li>
				</c:forEach>
                </ul>
                <!--// bbs body -->
                </div>
                <!--// bbs-table -->
                <c:if test="${empty boardList}">
                <div class="bbs-nodata">
                  <p>등록된 내용이 없습니다.</p>
                </div>
                </c:if>
                <!-- paging -->
                <div class="paging" id="paging">
				  <div>
				    <button class="ico-btn-start" type="button">
				    	<a href="/board/list?pageNum=1&keyword=${keyword}"><span>처음</span></a>
			    	</button>
				    <button class="ico-btn-prev" type="button"
				            ${paging.hasPrev ? "" : "disabled='disabled'"}>
				      <span>이전</span>
				    </button>
				
				    <ul>
				      <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
				        <c:choose>
				          <c:when test="${i == paging.pageNum}">
				            <li class="on"><strong>${i}</strong><span class="blind">선택됨</span></li>
				          </c:when>
				          <c:otherwise>
				            <li><a href="/board/list?pageNum=${i}&keyword=${keyword}">${i}</a></li>
				          </c:otherwise>
				        </c:choose>
				      </c:forEach>
				    </ul>
				
				    <button class="ico-btn-next" type="button"
				            ${paging.hasNext ? "" : "disabled='disabled'"}>
				      <span>다음</span>
				    </button>
				    <button class="ico-btn-end" type="button">
				      <a href="/board/list?pageNum=${paging.endPage}&keyword=${keyword}"><span>마지막</span></a>
				    </button>
				  </div>
				</div>
                <!--// paging -->

                <!-- 하단 버튼 영역 -->
                <div class="bbs-btn-area">
                  <a href="<%=ctx%>/board/write" class="btn large primary">
                    <i class="bi bi-pencil"></i> 글쓰기
                  </a>
                  <a href="<%=ctx%>/board/list" class="btn large blue-outline">
                    <i class="bi bi-chat-dots"></i> 고객문의
                  </a>
                </div>

              </div>
              <!--// bbs-list -->

            </div>
          </section>
          <!--// content-area -->
        </article>
        <!--// content -->

      </main>
      <!--//main-->
      <!--footer-->
      <footer id="footer" class="footer">
      	<jsp:include page="/WEB-INF/views/inc/footer.jsp"></jsp:include>
      </footer>
      <!--//footer-->
    </div>
    <!--// page -->
    <!-- icoBtn_goTop -->
    <button type="button" id="btn-page-top"><span class="sr-only">상단으로 이동</span></button>
    <!-- //icoBtn_goTop -->
  </div>

  <div id="sitemap" class="sitemapArea">
  	<jsp:include page="/WEB-INF/views/inc/sitemap.jsp"></jsp:include>
  </div>
</body>

</html>
