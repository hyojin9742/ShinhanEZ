<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">

<head id="inc-head">
    <jsp:include page="/WEB-INF/views/inc/head.jsp"></jsp:include>
    <link rel="stylesheet" href="${ctx}/css/user_claims.css">
    <script src="${ctx}/js/user_claims.js" defer></script>
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
                            <button type="button" class="btn large primary" id="btnClaimStart" title="새창으로 열림">
                                <span>보험금 청구하기</span>
                            </button>
                        </div>
                        <!--// btn-group -->

                        <h2 class="title-h2"><span class="txt">필요서류</span></h2>

                        <ul class="list depth-u1">
                            <li>청구 정보와 필요서류를 함께 제출하셔야 신속한 심사와 지급절차가 진행됩니다.</li>
                            <li>서류를 미리 찍어두면 더 간편하게 청구할 수 있습니다.</li>
                        </ul>

                        <!-- btn-group -->
                        <div class="btn-group option-min space-mt-xxl">
                            <button type="button" class="btn large grey-filled" data-id="CUS50000P02"
                                    title="새창으로 열림"><span>필요서류
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
                                    <a href="https://www.silson24.or.kr" target="_blank" title="실손24"
                                       class="txt-underline">실손24</a>에서
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

<div id="contractModalBackdrop" class="contract-modal-backdrop"></div>

<div id="contractModal" class="contract-modal">
  <div class="contract-modal-header">
    <div class="contract-modal-title">보험금 청구</div>
    <button type="button" class="contract-modal-close" id="btnCloseContractModal" aria-label="닫기">×</button>
  </div>
<<<<<<< HEAD

  <div class="contract-modal-body">

    <!-- ✅ STEP 1: 계약 선택 영역 -->
    <section id="stepContract" class="modal-step">
      <div id="contractModalMsg" class="contract-modal-msg" style="display:none;"></div>

      <table class="contract-table">
        <thead>
          <tr>
            <th>계약번호</th>
            <th>가입자</th>
            <th>피보험자</th>
            <th>상품명</th>
            <th>보장내용</th>
            <th>가입날짜</th>
            <th>상태</th>
          </tr>
        </thead>
        <tbody id="contractTbody"></tbody>
      </table>
    </section>

    <!-- STEP 2: 청구 등록 폼 영역 (처음엔 숨김) -->
    <section id="stepClaimForm" class="modal-step" style="display:none;">
      <form id="claimForm" action="${ctx}/user/claims/insert" method="post">
        <div class="payment-form">
          <div>
            <div class="form-group">
              <label class="form-label">청구인</label>
              <input type="text" class="form-control" id="claimCustomerName" disabled>
            </div>
            <div class="form-group">
              <label class="form-label">피보험자</label>
              <input type="text" class="form-control" id="claimInsuredName" disabled>
            </div>
			<div class="form-group">
			              <label class="form-label">계약ID</label>
			              <input type="text" class="form-control" id="claimContractId" readonly>
            </div>
          </div>

          <div>
			<div class="form-group">
			  <label class="form-label">청구금액</label>
			  <input type="number" class="form-control" name="claimAmount" placeholder="청구금액" required>
			</div>
			            
            <div class="form-group">
              <label class="form-label">사고일</label>
              <input type="date" class="form-control" name="accidentDate" value="${today}" required>
            </div>
			
			<div class="form-group form-wide">
              <label class="form-label">제출 서류</label>
              <textarea class="form-control" name="documentList" rows="4"
                        placeholder="예: 진단서, 입원확인서, 신분증 사본, 특이사항"></textarea>
            </div>

          </div>

          <!--  INSERT용 hidden -->
          <input type="hidden" name="customerId" id="claimCustomerId">
          <input type="hidden" name="insuredId" id="claimInsuredId">
          <input type="hidden" name="contractId" id="claimContractIdHidden">
        </div>
      </form>
    </section>
  </div>

  <!--  footer는 항상 보이게 sticky -->
  <div class="contract-modal-footer contract-modal-footer-sticky">
    <!-- STEP1 버튼 -->
    <button type="button" class="btn btn-secondary" id="btnConfirmContract" disabled>계약선택</button>

    <!-- STEP2 버튼 -->
    <button type="button" class="btn btn-outline" id="btnBackToList" style="display:none;">계약 다시 선택</button>
    <button type="submit" class="btn btn-primary" id="btnSubmitClaim" style="display:none;"
            form="claimForm">등록</button>
  </div>
</div>


=======
  
  <div id="sitemap" class="sitemapArea">
  	<jsp:include page="/WEB-INF/views/inc/sitemap.jsp"></jsp:include>
  </div>
>>>>>>> refs/heads/security
</body>

</html>