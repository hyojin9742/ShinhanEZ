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

    <div id="page" data-page-main="true">
      <!-- header -->
      <header id="header" class="header">
      	<jsp:include page="/WEB-INF/views/inc/header.jsp"></jsp:include>
      </header>
      <!--// header -->

      <!--main-->
      <main id="main">
        <div id="content">
          <!-- 페이지 타이틀 -->
          <div class="page-title">
            <div class="inner-wrap">
              <h1 class="headline-lg">브랜드</h1>
            </div>
          </div>

          <!-- 서브 비주얼 -->
          <div class="sub-visual brand"></div>

          <!-- 브랜드 콘텐츠 -->
          <div class="brand">
            <!-- 인트로 섹션 -->
            <section class="brand-intro">
              <div class="inner-wrap">
                <div class="intro-wrap">
                  <div class="intro-title">
                    <h2 class="headline-md">우리의 삶을<br>더욱 안전하게 해줄<br>디지털 신한이지</h2>
                  </div>
                  <div class="intro-content">
                    <div class="intro-text">
                      <p>금융으로 세상을 이롭게 한, 늘 새롭고자 한 '신한 40년'</p>
                      <p>그 시간을 채운 건 신한의 진심이 담긴 약속과 올바른 실천이었습니다.<br>
                        이제 새 가족이 된 신한EZ손해보험은 국민의 삶을 이롭게 하겠다는<br>
                        비전을 가진 디지털 손해보험사로서 새로운 보험을 준비하고 있습니다.</p>
                      <p>작지만 내실있는 디지털 손해보험회사로서 신한금융그룹이 가진 연결자산을 통해<br>
                        고객의 일상생활을 온전히 케어하고 시대를 앞장서서 도전해 나가는<br>
                        새로운 보험의 가치를 전달해 나아가려 합니다.</p>
                      <p>고객의 입장에서 더 쉽고 편안한 더 새로운 보험을 선보이며<br>
                        보험시장에 새로운 가치를 열어가겠습니다.</p>
                    </div>
                    <div class="brand-box">
                      <h3>보험은 <br>신한이지</h3>
                      <p>미래 보험시장 변화를 선도하고 차별화된 고객경험을 제공하는 디지털 손해보험사로서<br>
                        신한금융그룹의 비전인 '더 쉽고 편안한, 더 새로운 금융'을 실천하기 위해 EZ(Easy)라는<br> 단어를 사명에 담았습니다.</p>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            <!-- 비전 섹션 -->
            <section class="brand-vision">
              <div class="inner-wrap">
                <div class="vision-wrap">
                  <div class="vision-title">
                    <h2 class="headline-sm"><strong>신한EZ손해보험은</strong><br>디지털 혁신을 통해 고객과 시장에<br>새로운 보험 가치를 제시할 수
                      있는<br>디지털
                      보험사로 성장해 나가겠습니다.</h2>
                  </div>
                  <div class="vision-content">
                    <dl class="strategy-list">
                      <div class="strategy-item">
                        <dt>전략목표</dt>
                        <dd>금융과 생활을 쉽고 빠르게 연결하는 일상생활 리스크 관리 플랫폼</dd>
                      </div>
                      <div class="strategy-item">
                        <dt>전략방향</dt>
                        <dd>
                          <ul>
                            <li>디지털 손해보험 사업모델 구현</li>
                            <li>미래 신시장 개척 및 선점</li>
                            <li>그룹/제휴 시너지 극대화</li>
                          </ul>
                        </dd>
                      </div>
                    </dl>
                  </div>
                </div>
              </div>
            </section>

            <!-- History 섹션 -->
            <section class="brand-history">
              <div class="inner-wrap">
                <div class="history-wrap">
                  <div class="history-title">
                    <h2 class="headline-md">History</h2>
                  </div>
                  <div class="history-content">
                    <p class="history-intro">2022년 7월 1일 신한EZ손해보험은 신한금융그룹의 New Vision인 '더 쉽고 편안한, 더 새로운 금융'의<br>가치 아래
                      그룹의
                      15번째 자회사로 공식 출범하였습니다.</p>
                    <ul class="timeline">
                      <li>
                        <div class="year">2025<span>년</span></div>
                        <ul class="events">
                          <li>
                            <span class="month">09<em>월</em></span>
                            <span class="desc">업계 최초 착오송금 회수비용 보장보험 배타적 사용권 획득</span>
                          </li>
                        </ul>
                      </li>
                      <li>
                        <div class="year">2023<span>년</span></div>
                        <ul class="events">
                          <li>
                            <span class="month">03<em>월</em></span>
                            <span class="desc">종합손해보험사로 도약</span>
                          </li>
                        </ul>
                      </li>
                      <li>
                        <div class="year">2022<span>년</span></div>
                        <ul class="events">
                          <li>
                            <span class="month">11<em>월</em></span>
                            <span class="desc">KT/더존비즈온 전략적 투자 유치</span>
                          </li>
                          <li>
                            <span class="month">07<em>월</em></span>
                            <span class="desc">신한EZ손해보험㈜ 출범</span>
                          </li>
                        </ul>
                      </li>
                      <li>
                        <div class="year">2014<span>년</span></div>
                        <ul class="events">
                          <li>
                            <span class="month">09<em>월</em></span>
                            <span class="desc">BNP파리바 카디프손해보험㈜ 출범</span>
                          </li>
                        </ul>
                      </li>
                      <li>
                        <div class="year">2004<span>년</span></div>
                        <ul class="events">
                          <li>
                            <span class="month">01<em>월</em></span>
                            <span class="desc">다음다이렉트 자동차보험㈜ 출범</span>
                          </li>
                        </ul>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </section>

            <!-- 주요 Business 섹션 -->
            <section class="brand-business">
              <div class="inner-wrap">
                <div class="business-wrap">
                  <div class="business-title">
                    <h2 class="headline-md"><strong>주요</strong><br>Business</h2>
                  </div>
                  <div class="business-content">
                    <!-- 신한 SOL 디지털보험 -->
                    <div class="business-item">
                      <div class="item-header">
                        <h3>신한 SOL 디지털보험</h3>
                        <p>신한 SOL 플랫폼을 통해 해외여행보험, 해외장기체류보험, 주택화재보험, 실손의료보험 등<br>일상생활에 꼭 필요한 상품을 더 쉽고 빠르게 제공하고 있습니다.</p>
                      </div>
                      <div class="item-body">
                        <div class="sol-info">
                          <div class="sol-app">
                            <img src="<%=ctx%>/images/icon/ico-brand1.png" alt="신한SOL EZ손보 앱">
                          </div>
                          <div class="sol-desc">
                            <h4>신한 SOL</h4>
                            <p>
                              "Speedy, Optimized, Leading" 앞 글자를 딴 명칭으로<br>
                              "빠르게 고객에게 최적화된 선도적 금융 애플리케이션"이라는 뜻을 담은 신한금융그룹의 새로운<br>
                              모바일 통합 플랫폼을 말합니다. 신한 SOL EZ손보 앱에서 디지털 생활밀착형 보험을 만나보세요.</p>
                          </div>
                        </div>
                        <ul class="product-list sol-products">
                          <li>
                            <span class="ico"><img src="<%=ctx%>/images/icon/ico-brand2.png" alt="해외여행보험 아이콘"></span>
                            <span class="txt">신한 SOL<br>해외여행보험</span>
                          </li>
                          <li>
                            <span class="ico"><img src="<%=ctx%>/images/icon/ico-brand3.png" alt="장기체류보험 아이콘"></span>
                            <span class="txt">신한 SOL<br>장기체류보험</span>
                          </li>
                          <li>
                            <span class="ico"><img src="<%=ctx%>/images/icon/ico-brand4.png" alt="주택화재보험 아이콘"></span>
                            <span class="txt">신한 SOL<br>주택화재보험</span>
                          </li>
                          <li>
                            <span class="ico"><img src="<%=ctx%>/images/icon/ico-brand5.png" alt="실손의료보험 아이콘"></span>
                            <span class="txt">신한 SOL<br>실손의료보험</span>
                          </li>
                        </ul>
                      </div>
                    </div>

                    <!-- 장기보험 -->
                    <div class="business-item">
                      <div class="item-header">
                        <h3>장기보험</h3>
                        <p>2023년 1월 '운전자보험'출시로 장기보험 시장에 새롭게 진출한 신한EZ는 디지털 컨설팅을 통해<br>'일상 생활 위험으로부터 안심' 이라는 고객 경험을 제공하는
                          플랫폼으로 진화해 나가고 있습니다.</p>
                      </div>
                      <div class="item-body">
                        <div class="easyro-info">
                          <h4>신한 이지로운 보험</h4>
                          <p>'이지(理智)로운'은 고객에게 '이롭고 지혜로운' 장기상품과 서비스를 제공하겠다는<br>
                            신한EZ손해보험의 마음을 담아 표현한 브랜드로 합리적인 가격과 빠른 보상서비스를 제공할 것을 약속합니다.</p>
                        </div>
                      </div>
                    </div>

                    <!-- 일반보험 -->
                    <div class="business-item">
                      <div class="item-header">
                        <h3>일반보험</h3>
                        <p>신한EZ는 손해보험 전종목 라이선스를 보유한 종합손해보험사로 일반보험을 통한 다양한 B2B 기업보험을 취급하고 있습니다.</p>
                      </div>
                      <div class="item-body">
                        <ul class="product-list general-products">
                          <li>
                            <span class="ico"><img src="<%=ctx%>/images/icon/ico-brand6.png" alt="화재보험 아이콘"></span>
                            <span class="txt">화재보험</span>
                          </li>
                          <li>
                            <span class="ico"><img src="<%=ctx%>/images/icon/ico-brand7.png" alt="특종보험 아이콘"></span>
                            <span class="txt">특종보험</span>
                          </li>
                          <li>
                            <span class="ico"><img src="<%=ctx%>/images/icon/ico-brand8.png" alt="기술보험 아이콘"></span>
                            <span class="txt">기술보험</span>
                          </li>
                          <li>
                            <span class="ico"><img src="<%=ctx%>/images/icon/ico-brand9.png" alt="품질연장보증 아이콘"></span>
                            <span class="txt">품질연장보증(EW)</span>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            <!-- BI 다운로드 섹션 -->
            <section class="brand-bi">
              <div class="inner-wrap">
                <div class="bi-wrap">
                  <div class="bi-title">
                    <h2 class="headline-md">BI 소개 및 다운로드</h2>
                  </div>
                  <div class="bi-content">
                    <div class="bi-logo">
                      <img src="<%=ctx%>/images/logo-shez.svg" alt="신한EZ손해보험 로고">
                    </div>
                    <button type="button" class="btn-download">
                      <span>BI 다운로드 <img src="<%=ctx%>/images/icon/down.png" alt="다운" style=" width: 1.4rem;"></span>
                    </button>
                  </div>
                </div>
              </div>
            </section>
          </div>
        </div>
      </main>
      <!--//main-->

      <!--footer-->
      <footer id="footer" class="footer">
      	<jsp:include page="/WEB-INF/views/inc/footer.jsp"></jsp:include>
      </footer>
      <!--//footer-->
    </div>
    <!-- icoBtn_goTop -->
    <button type="button" id="btn-page-top"><span class="sr-only">상단으로 이동</span></button>
    <!-- //icoBtn_goTop -->
  </div>

  <div id="sitemap" class="sitemapArea">
  	<jsp:include page="/WEB-INF/views/inc/sitemap.jsp"></jsp:include>
  </div>
  
</body>

</html>