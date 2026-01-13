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
          <!-- page-title -->
          <section class="page-title">
            <div class="inner-wrap">
              <h1 class="headline-lg">보험금청구</h1>
            </div>
          </section>
          <!--// page-title -->
          <!-- content-area -->
          <section class="content-area insuranceClaim">
            <div class="inner-wrap">
              <h2 class="title-h2"><span class="txt">보험금청구 절차</span></h2>
              <!-- card -->
              <div class="card option-data option-step">
                <!-- card-list -->
                <ul class="card-list">
                  <li class="card-item step-type1 icon-80-xmax">
                    <h3 class="card-title">
                      <span class="txt"><em>STEP 01</em></span>
                      <strong class="key"><em>보험금청구</em></strong>
                    </h3>
                  </li>
                  <li class="card-item step-type2 icon-80-xmax">
                    <h3 class="card-title">
                      <span class="txt"><em>STEP 02</em></span>
                      <strong class="key"><em>담당자 지정</em></strong>
                    </h3>
                  </li>
                  <li class="card-item step-type3 icon-80-xmax">
                    <h3 class="card-title">
                      <span class="txt"><em>STEP 03</em></span>
                      <strong class="key"><em>사고조사 또는 심사</em></strong>
                    </h3>
                  </li>
                  <li class="card-item step-type4 icon-80-xmax">
                    <h3 class="card-title">
                      <span class="txt"><em>STEP 04</em></span>
                      <strong class="key"><em>보험금 확정 및 지급</em></strong>
                    </h3>
                  </li>
                </ul>
                <!-- card-list -->
              </div>
              <!-- card -->

              <h2 class="title-h2"><span class="txt">보험금청구 방법</span></h2>

              <!-- card -->
              <div class="card option-data option-step2">
                <!-- card-list -->
                <ul class="card-list">
                  <li class="card-item step-type5 icon-60-max">
                    <h3 class="card-title">
                      <span class="txt"><em>모바일 청구</em></span>
                      <strong class="key"><em>상해/질병 보험금청구</em></strong>
                    </h3>
                  </li>
                  <li class="card-item step-type6 icon-60-max">
                    <h3 class="card-title">
                      <span class="txt"><em>전화 청구</em></span>
                      <strong class="key"><em>고객센터(1544-2580) 상담원을 통해 접수</em></strong>
                    </h3>
                  </li>
                  <li class="card-item step-type7 icon-60-max">
                    <h3 class="card-title">
                      <span class="txt"><em>우편 청구</em></span>
                      <strong class="key"><em>보험금청구서 등 필요서류 우편으로 발송하여 청구 가능</em></strong>
                      <p class="ico-bullet body-txt">접수처: (04522) 서울시 중구 남대문로 113 DB다동빌딩 4층 신한EZ손해보험
                        손해사정팀</p>
                    </h3>
                  </li>
                </ul>
                <!-- card-list -->
              </div>
              <!-- card -->

              <!-- btn-group -->
              <div class="btn-group option-min space-mt-xxl">
                <button type="button" class="btn large primary" onclick="javascript:commView.goQrLk('3002');"
                  title="새창으로 열림"><span>보험금
                    청구하기</span></button>
              </div>
              <!--// btn-group -->

              <h2 class="title-h2"><span class="txt">필요서류</span></h2>

              <ul class="list depth-u1">
                <li>청구 정보와 필요서류를 함께 제출하셔야 신속한 심사와 지급절차가 진행됩니다.</li>
                <li>서류를 미리 찍어두면 더 간편하게 청구할 수 있습니다.</li>
              </ul>

              <!-- btn-group -->
              <div class="btn-group option-min space-mt-xxl">
                <button type="button" class="btn large grey-filled" data-id="CUS50000P02" title="새창으로 열림"><span>필요서류
                    안내</span></button>
              </div>
              <!--// btn-group -->

              <!-- note -->
              <div class="note hp-note space-mt-45-xxl">
                <ul class="note-list">
                  <li>보험금은 사고발생일로부터 3년 이내에 신청할 수 있습니다.</li>
                  <li><a href="https://www.silson24.or.kr/claim/web/serviceHospitalList" target="_blank"
                      title="실손24연계병원" class="txt-underline">실손24 연계병원</a>에서 2025년 10월 25일 이후 수납하셨다면,
                    종이서류 없이
                    <a href="https://www.silson24.or.kr" target="_blank" title="실손24" class="txt-underline">실손24</a>에서
                    청구가
                    가능합니다.
                  </li>
                  <li>궁금하신 사항은 신한EZ손해보험 고객센터(1544-2580) 또는 보상담당자에게 문의해 주세요.</li>
                </ul>
              </div>
              <!--// note -->

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

  <div id="sitemap" class="sitemapArea"></div>

</body>

</html>