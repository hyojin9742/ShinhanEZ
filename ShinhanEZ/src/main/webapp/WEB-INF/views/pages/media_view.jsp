<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">

<head id="inc-head">
	<jsp:include page="/WEB-INF/views/inc/head.jsp"></jsp:include>
</head>

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
							<h1 class="headline-lg">미디어룸 상세</h1>
						</div>
					</section>
					<!--// page-title -->
					<!-- content-area -->
					<section class="content-area">
						<div class="inner-wrap">
							<!-- bbs-view -->
							<div class="mView bbs-view">
								<div class="bbs-caption sr-only">보도자료, 수상내역 게시판으로 제목, 등록일, 내용, 첨부파일 정보로 구성되어 있습니다.</div>
								<!-- bbs head -->
			                	<div class="bbs-view-head">
                  					<div class="mView_title">
	                  					<div class="badge-group"><span class="badge bbs press">게시글</span></div>
                  						<h2 class="bbs-subject">${board.title}</h2>
                  					</div>
									<!-- bbs-info -->
              						<div class="bbs-info">
	              						<ul class="etcList">
	              							<li><span>작성자: ${board.id}</span></li>
	                  						<li><span>등록일: <fmt:formatDate value="${board.regDate}" pattern="yyyy-MM-dd"/></span></li>
	                  						<li><span>조회: ${board.cnt}</span></li>
	               						</ul>
               						</div>
                			</div>
                			<!--// bbs head -->
                			<!-- bbs body -->
               				<div class="bbs-body">
                  				<!-- bbs editer content -->
                  				<div class="bbs-content">
                    				<div class="bbs-img"></div>
	                    			<p class="bbs-txt" style="white-space: pre-wrap; line-height: 1.8;">
	                    				${board.textarea}
	                    			</p>
                  				</div>
                  			<!--// bbs editer content -->
                			</div>
                			<!--// bbs body -->
                			<!-- bbs-view-foot -->
                			<div class="bbs-view-foot">
                  				<div class="btn-group option-min space-mt-xxl">
				                    <button type="button" class="btn large grey-outline" onclick="location.href='<%=ctx%>/board/list'">
				                      	<span>목록</span>
				                    </button>
                  				</div>
                			</div>
                			<!--// bbs-view-foot -->
              			</div>
              			<!--// bbs-view -->
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
