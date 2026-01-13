<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head id="inc-head">
	<%@ include file="/WEB-INF/views/inc/head.jsp" %>
</head>
<body class="main">
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
      	<%@ include file="/WEB-INF/views/inc/header.jsp" %>
      </header>
      <!--//header-->
      <!--main-->
      <main id="main">
        <article id="content">
          <section class="full">
            <div class="main-visual">
              <div class="inner-wrap">
                <div class="visual-title">
                  <h2 class="word-split-JS" data-splitting data-css-property="animation" data-speed="0.03"
                    data-speed-delay="0.3">이제 모두의 안심<br>디지털 신한이지</h2>
                  <p>신한SOL에서 쉽고 편리한<br>일상의 안심</p>
                  <button type="button" class="visual-btn" title="새창으로 열림">더 알아보기</button>
                </div>
                <div class="visual-img">
                  <span class="icon-01"></span>
                  <span class="icon-02"></span>
                  <span class="icon-03"></span>
                  <span class="icon-04"></span>
                  <span class="sol-img"></span>
                  <span class="bg-img"></span>
                </div>
              </div>
            </div>
          </section>

          <div class="direct-info">
            <div class="inner-wrap">
              <div class="txt-cont">
                <p>수수료가 없어 더욱 저렴한</p>
                <h2><span>신한SOL 다이렉트 보험</span></h2>
              </div>
              <div class="direct-wrap">
                <div class="direct-list">
                  <div class="direct-item type1">
                    <a href="#" class="link">
                      <span class="icon"><img src="${ctx}/images/icon/direct-icon1.png" alt="금융안심보험 아이콘"></span>
                      <strong class="subject">금융안심보험</strong>
                      <span class="description">비대면 금융사고 피해</span>
                    </a>
                  </div>
                  <div class="direct-item type2">
                    <a href="#" class="link">
                      <span class="icon"><img src="${ctx}/images/icon/direct-icon2.png" alt="해외여행보험 아이콘"></span>
                      <strong class="subject">해외여행보험</strong>
                      <span class="description">해외여행은 신한이지로</span>
                    </a>
                  </div>
                  <div class="direct-item type3">
                    <a href="#" class="link">
                      <span class="icon"><img src="${ctx}/images/icon/direct-icon3.png" alt="해외장기체류보험 아이콘"></span>
                      <strong class="subject">해외장기체류보험</strong>
                      <span class="description">유학, 주재원 계획이라면</span>
                    </a>
                  </div>
                  <div class="direct-item type4">
                    <a href="#" class="link">
                      <span class="icon"><img src="${ctx}/images/icon/direct-icon4.png" alt="처음운전자보험 아이콘"></span>
                      <strong class="subject">처음운전자보험</strong>
                      <span class="description">운전자를 든든하게</span>
                    </a>
                  </div>
                  <div class="direct-item type5">
                    <a href="#" class="link">
                      <span class="icon"><img src="${ctx}/images/icon/direct-icon5.png" alt="처음건강보험 아이콘"></span>
                      <strong class="subject">처음건강보험</strong>
                      <span class="description">꼼꼼하게 준비하는</span>
                    </a>
                  </div>
                  <div class="direct-item type6">
                    <a href="#" class="link">
                      <span class="icon"><img src="${ctx}/images/icon/direct-icon6.png" alt="실손의료보험 아이콘"></span>
                      <strong class="subject">실손의료보험</strong>
                      <span class="description">의료비 걱정 덜어주는</span>
                    </a>
                  </div>
                  <div class="direct-item type7">
                    <a href="#" class="link">
                      <span class="icon"><img src="${ctx}/images/icon/direct-icon7.png" alt="주택화재보험 아이콘"></span>
                      <strong class="subject">주택화재보험</strong>
                      <span class="description">누구나 쉽고 편리하게</span>
                    </a>
                  </div>
                  <div class="direct-item type8">
                    <a href="#" class="link">
                      <span class="icon"><img src="${ctx}/images/icon/direct-icon8.png" alt="미니생활보험 아이콘"></span>
                      <strong class="subject">미니생활보험</strong>
                      <span class="description">일상을 보다 안전하게</span>
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="product-banner">
            <div class="swiper product-banner-wrap">
              <ul class="swiper-wrapper product-banner-list">
                <li class="swiper-slide product-banner-item banner1">
                  <div class="inner-wrap">
                    <div class="product-banner-item-cont">
                      <strong class="subject">서류없이 청구 가능한 <span class="MbBlock">실손 청구 시스템</span></strong>
                      <span class="description">실손24에서 실손의료보험 청구를 더욱 간편하게!</span>
                      <a href="#" class="btn large grey-outline">실손24 홈페이지 바로가기</a>
                    </div>
                    <div class="product-banner-item-img"><img src="${ctx}/images/product-banner1.png" alt="실손 청구 시스템"></div>
                  </div>
                </li>
                <li class="swiper-slide product-banner-item banner2">
                  <div class="inner-wrap">
                    <div class="product-banner-item-cont">
                      <strong class="subject">가입부터 청구까지 <span class="MbBlock">모바일로 편리하게</span></strong>
                      <span class="description">의료비 걱정을 덜어주는 신한 SOL 처음실손의료보험</span>
                      <a href="#" class="btn large grey-outline">상품 알아보기</a>
                    </div>
                    <div class="product-banner-item-img"><img src="${ctx}/images/product-banner2.png" alt="처음실손의료보험"></div>
                  </div>
                </li>
              </ul>
              <div class="product-banner-control">
                <div class="product-banner-page swiper-pagination"></div>
                <button type="button" class="btn-pause" id="productBannerControl"><span class="sr-only">자동재생 멈추기</span></button>
              </div>
            </div>
          </div>

          <section class="video-info">
            <div class="inner-wrap">
              <div class="txt-cont cssAnimate fadeInUp">
                <h2><span>신한 SOL EZ손보에서</span> <span>상상은 현실이 된다</span></h2>
                <p>두근두근 설렘 가득한 해외에서도<br>예상치 못한 질병으로 힘들 때에도</p>
              </div>
              <div class="video-cont">
                <iframe src="https://www.youtube.com/embed/q5_fOQTyOrU?autoplay=0&mute=1&playsinline=1&loop=1&playlist=q5_fOQTyOrU&rel=0"
                  frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
              </div>
            </div>
          </section>

          <section class="ez-info">
            <div class="inner-wrap">
              <div class="txt-cont">
                <h2 class="cssAnimate fadeInUp"><span>보험, 언제 어디서든</span> <span>나를 지켜주는 금융</span></h2>
                <p class="cssAnimate fadeInUp">보험이 필요한 순간,<br>늘 곁에서 함께 하겠습니다.</p>
              </div>
            </div>
            <div class="img-cont img-ani" id="imgAni1">
              <div class="img-ani-bg left-bg"></div>
              <div class="img-ani-bg right-bg"></div>
            </div>
          </section>

          <section class="digital-info space-pb-100">
            <div class="inner-wrap">
              <div class="txt-cont">
                <h2 class="cssAnimate fadeInUp">
                  <span>기술과 데이터로</span>
                  새로운 보험을 만듭니다.
                  <strong>디지털 신한이지</strong>
                </h2>
              </div>
              <div class="chart-cont cssAnimate fadeIn">
                <ul>
                  <li class="cssAnimate fadeInLeft"><span>Digital Product</span></li>
                  <li class="cssAnimate fadeInLeft"><span>Digital Process</span></li>
                  <li class="cssAnimate fadeInLeft"><span>Digital Solution</span></li>
                  <li class="cssAnimate fadeInLeft"><span>Digital Channel</span></li>
                </ul>
                <div class="chart-plus cssAnimate fadeIn"><span class="sr-only">더하기</span></div>
                <div class="cssAnimate fadeInRight"><span>데이터 + IT기술</span></div>
              </div>
            </div>
          </section>

        </article>
      </main>
      <!--//main-->
      <!--footer-->
      <footer id="footer" class="footer">
      	<%@ include file="/WEB-INF/views/inc/footer.jsp" %>
      </footer>
      <!--//footer-->
    </div>
    <!--// page -->
    <button type="button" id="btn-page-top"><span class="sr-only">상단으로 이동</span></button>
  </div>

  <div id="sitemap" class="sitemapArea">
  	<%@ include file="/WEB-INF/views/inc/sitemap.jsp" %>
  </div>
</body>
</html>
