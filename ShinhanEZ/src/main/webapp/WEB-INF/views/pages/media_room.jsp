<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
              <h1 class="headline-lg">미디어룸</h1>
            </div>
          </section>
          <!--// page-title -->

          <!-- content-area -->
          <section class="content-area">
            <div class="inner-wrap">
              <div style="text-align: right; margin-bottom: 15px;">
                <a href="<%=ctx%>/shboardinsert?mode=write" class="btn primary">글쓰기</a>
              </div>
              <!-- bbs-list -->
              <div class="bbs-list">

                <!-- bbs-table -->
                <div class="bbs-table">
                  <div class="bbs-caption sr-only">보도자료, 수상내역 게시판으로 번호, 제목, 첨부파일, 등록일 정보로 구성되어 있습니다.</div>
                <!-- bbs head -->
                <ul class="bbs-head">
                  <li class="bbs-column w-10">번호</li>
                  <li class="bbs-column w-55">제목</li>
                  <li class="bbs-column w-15">작성자</li>
                  <li class="bbs-column w-10">조회</li>
                  <li class="bbs-column w-10">등록일</li>
                </ul>
                <!--// bbs head -->

                <!-- bbs body -->
              	<ul class="bbs-body">
				<c:forEach var="list" items="${list }">
                  <li class="bbs-row">
                    <div class="bbs-column bbs-num">${list.idx }</div>
                    <div class="bbs-column bbs-tit">
                      <div class="badge-group">
                        <span class="badge bbs press">게시글</span>
                      </div>
                      <div class="subject-area">
                        <a href="<%=ctx%>/shboard?idx=${list.idx }">
                          <strong class="bbs-subject">${list.title }</strong>
                        </a>
                      </div>
                    </div>
                    <div class="bbs-column bbs-writer">${list.id }</div>
                    <div class="bbs-column bbs-view">${list.cnt }</div>
                    <div class="bbs-column bbs-date">${list.reg_date }</div>
                  </li>				
				</c:forEach>
                </ul>
                <!--// bbs body -->
                </div>
                <!--// bbs-table -->
                <div class="bbs-nodata" style="display: none;">
                  <p>등록된 내용이 없습니다.</p>
                </div>
                <!-- paging -->
                <!-- TODO 동적 페이징 처리 필요 -->
                <div class="paging" id="paging">
                  <div><button class="ico-btn-start" type="button" disabled="disabled"><span>처음</span></button><button
                      class="ico-btn-prev" type="button" disabled="disabled"><span>이전</span></button>
                    <ul>
                      <li class="on"><strong>1</strong><span class="blind">선택됨</span></li>
                      <li><a href="#">2</a></li>
                    </ul><button class="ico-btn-next" type="button"><span>다음</span></button><button class="ico-btn-end"
                      type="button"><span>마지막</span></button>
                  </div>
                </div>
                <!--// paging -->

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