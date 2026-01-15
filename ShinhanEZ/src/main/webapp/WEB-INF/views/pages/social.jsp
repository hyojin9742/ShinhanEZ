<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
          <section class="page-title">
            <div class="inner-wrap">
              <h1 class="headline-lg">사회공헌</h1>
            </div>
          </section>
          <section class="content-area social">
            <div class="inner-wrap">
              <!-- Section1 -->
              <section>
                <h2 class="headline-xs">
                  함께, 멀리! 멋진 세상을 향한 올바른 실천
                </h2>
                <p class="txt18">
                  신한EZ손해보험은 서로 돕는 보험의 본질을 생각합니다.<br>
                  기업의 사회적 책임을 다하고 사회공헌 문화 확산을 위해 전 임직원들이 다양한 사회공헌 프로그램에 함께 참여하고 있습니다.<br>
                  환경에 기여하고, 고객과 함께 상생하는 신뢰받는 보험사로 함께 하겠습니다.
                </p>
              </section>
              <!-- /Section1 -->
              <!-- Section2 -->
              <section>
                <h2 class="headline-xs primary-dark">
                  <strong>Do the Right Thing for a </strong>Wonderful World<br>
                  멋진 세상을 향한 올바른 실천
                </h2>

                <ul class="line-box-wrap option-row">
                  <li class="line-box">
                    <img src="<%=ctx%>/images/icon/ico-contribution-01.svg" alt="친환경">
                    <h3 class="title-h4">
                      <span class="txt">친환경</span>
                      <span class="txt16">
                        <span>Do the <strong class="green">Green</strong> Thing</span>
                        for a Wonderful World
                      </span>
                    </h3>
                  </li>

                  <li class="line-box">
                    <img src="<%=ctx%>/images/icon/ico-contribution-02.svg" alt="상생">
                    <h3 class="title-h4">
                      <span class="txt">상생</span>
                      <span class="txt16">
                        <span>Do the <strong class="orange">Brave</strong> Thing</span>
                        for a Wonderful World
                      </span>
                    </h3>
                  </li>

                  <li class="line-box">
                    <img src="<%=ctx%>/images/icon/ico-contribution-03.svg" alt="신뢰">
                    <h3 class="title-h4">
                      <span class="txt">신뢰</span>
                      <span class="txt16">
                        <span>Do the <strong class="skyblue">Fair</strong> Thing</span>
                        for a Wonderful World
                      </span>
                    </h3>
                  </li>
                </ul>
              </section>
              <!-- /Section2 -->

              <!-- Section3 -->
              <section>
                <h2 class="headline-xs">
                  서울숲 쓰담쓰담 “지구를 건강하게, 몸과 마음도 건강하게”
                </h2>

                <p class="txt18">
                  신한EZ손해보험 임직원은 서울숲 쓰담쓰담 환경정화 운동에 참여합니다.<br>
                  쓰담쓰담은 달리기 운동을 하면서 쓰레기를 줍는 환경정화운동인 플로깅의 순우리말 입니다.<br>
                  ‘쓰레기 담기’의 뜻과 함께 ‘쓰담쓰담하다’ 처럼 환경을 보듬는 의미도 함께 담겨 있어요.<br>
                  함께 하실래요?
                </p>

                <ul class="pic-list">
                  <li>
                    <img src="<%=ctx%>/images/sub-contribution-01-pic.png" alt="서울숲 쓰담쓰담 환경정화 운동 단체사진 이미지">
                  </li>
                  <li class="pic-half">
                    <img src="<%=ctx%>/images/sub-contribution-02-pic.png" alt="서울숲 쓰담쓰담 환경정화 운동 활동 이미지 1">
                    <img src="<%=ctx%>/images/sub-contribution-05-pic.png" alt="서울숲 쓰담쓰담 환경정화 운동 활동 이미지 2">
                  </li>
                </ul>
              </section>
              <!-- /Section3 -->
              <!-- Section4 -->
              <section>
                <h2 class="headline-xs">
                  아름다운 하루, 물품기부 및 기부금 전달
                </h2>

                <p class="txt18">
                  아름다운 가게와 함께 신한EZ손해보험 임직원은 나눔과 순환의 세상만들기에 동참하고자 아름다운하루 행사를 진행했어요.<br>
                  알뜰구매와 이웃 사랑을 실천하는 시간을 가졌는데요, 대표님과 임직원이 함께하는 봉사여서 더 친해지고 가까워지는 날이기도 했답니다.<br>
                  신한EZ손해보험 임직원은 매월 1회 다양한 봉사활동에 참여하고 있어요.
                </p>

                <ul class="pic-list">
                  <li>
                    <img src="<%=ctx%>/images/sub-contribution-03-pic.png" alt="밥퍼나눔운동본부 봉사활동 이미지">
                  </li>
                  <li>
                    <img src="<%=ctx%>/images/sub-contribution-04-pic.png" alt="아름다운가게 기부 기념사진 이미지">
                  </li>
                </ul>
              </section>
              <!-- /Section4 -->
            </div>
          </section>
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