<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">

<head id="inc-head">
   <jsp:include page="/WEB-INF/views/inc/head.jsp"></jsp:include>
   <link rel="stylesheet" href="<%=ctx%>/css/contents.css">
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

          <!-- visual-wrap -->
          <section class="visual-wrap option-visual8">
            <div class="visual-body">
              <div class="visu-text-area">
                <div class="txt-cont">
                  <span>누구나 쉽고 편리하게</span><br>
                  <strong>
                    신한 SOL 주택화재보험<em class="title-lg">(무배당)</em>
                  </strong>
                </div>
                <ul class="prd-list">
                  <li>주택화재</li>
                  <li>소화설비 할인</li>
                </ul>

                <button
                  type="button"
                  class="btn large grey-outline"
                  id="btnMoreInfo"
                  title="새창으로 열림">보험료 알아보기</button>
              </div>

              <img
                src="<%=ctx%>/images/fire-bg.png"
                alt="신한 SOL 주택화재보험"
                class="visual-prd device-pc">
            </div>
          </section>
          <!--// visual-wrap -->

          <!-- content-area -->
          <section class="content-area">
            <div class="inner-wrap">
              <div class="prd-info-wrap">
                <!-- event-wrap -->
                <div class="event-wrap naver" id="naverPayEventInfo">
                  <div class="event-badge">
                    <span class="sr-only"><img src="<%=ctx%>/images/npay-event-badge.png" alt=""></span>
                  </div>
                  <div class="noto-center">
                    <h4 class="event-title">보험 가입하고 네이버페이 받자!</h4>
                    <p class="event-date">* 월 납입 보험료 기준<br>** 2025년 10월 1일 부터 12월 31일 까지</p>
                  </div>

                  <div class="event-info">
                    <ul class="note-list">
                      <li>
                        <strong>네이버페이 5천원 혜택</strong>
                        <span class="block">5천원 이상 ~ 1만원 미만 가입 시</span>
                      </li>
                      <li>
                        <strong>네이버페이 1만원 혜택</strong>
                        <span class="block">1만원 이상 ~ 2만원 미만 가입 시</span>
                      </li>
                      <li>
                        <strong>네이버페이 2만원 혜택</strong>
                        <span class="block">2만원 이상 ~ 3만원 미만 가입 시</span>
                      </li>
                      <li>
                        <strong>네이버페이 3만원 혜택</strong>
                        <span class="block">3만원 이상 가입 시</span>
                      </li>
                    </ul>
                  </div>
                </div>
                <!--// event-wrap -->

                <!-- white-note-wrap -->
                <div class="white-note-wrap">
                  <div class="white-note">
                    <div class="info">
                      <div class="note-icon" style="background-image: url(<%=ctx%>/images/icon/ico-60-60.svg);"></div>
                      <div class="noto-text">
                        <h4 class="info-title">
                          <em class="block">신한 SOL 주택화재보험으로</em><br>
                          <em class="block">우리집 재산목록 1호를 지켜드려요</em>
                        </h4>
                        <span class="txt">
                          <span class="block">화재로 인한 손해는 물론, 상해/생활/가전 위험도 든든하게</span><br>
                          <span class="block">우리집 보장받고 소화설비 월 보험료 5% 할인으로 쏠쏠한 혜택까지</span>
                        </span>
                        <br>
                        <span class="dblock txt03 fs-xs">* 해당 특약 가입시</span>
                      </div>
                    </div>
                  </div>
                  <div class="white-note">
                    <div class="info">
                      <div class="note-icon" style="background-image: url(<%=ctx%>/images/icon/ico-80-80.svg);"></div>
                      <div class="noto-text">
                        <h4 class="info-title">
                          <em class="block">은행 대출 (질권 설정 시) 화재/의무보험도</em><br>
                          <em class="block">합리적인 가격으로 만나보세요</em>
                        </h4>
                        <span class="txt">
                          <span class="block">주택/아파트 소유주 및 세입자에게</span><br>
                          <span class="block">화재, 층간소음, 배상책임 위험을 보장해 드립니다.</span>
                        </span>
                        <br>
                        <span class="dblock txt03 fs-xs">* 해당 특약 가입시</span>
                      </div>
                    </div>
                  </div>
                </div>
                <!--// white-note-wrap -->
              </div>

              <p class="txt03 fs-xs space-mt-sm">* 가전, 배상책임은 다수계약(공제계약포함)이 체결되어 있는 경우, 약관에 따라 실손비례 보상됩니다.</p>

              <!-- 준법감시인 확인필 번호 -->
              <div class="compliance-number-wrap">
                <p>준법감시인 확인필 제2025-1100237호 (2025.09.26~2026.09.25)</p>
              </div>
              <!--// 준법감시인 확인필 번호 -->

              <div class="prd-note-wrap">
                <h4 class="title-h2">
                  <span class="txt"><img src="<%=ctx%>/images/icon/icon-note.svg" alt=""> 가입 전 확인해 주세요</span>
                </h4>
                <!-- btn-group -->
                <div class="btn-group">
                  <button type="button" class="btn medium grey-outline" id="btnNoticeInsurance">
                    <span>보험 가입 시 알아두실 사항</span>
                  </button>
                  <button type="button" class="btn medium grey-outline" id="btnNoticeEvent">
                    <span>이벤트 가입 시 알아두실 사항</span>
                  </button>
                </div>
                <!--// btn-group -->
              </div>
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