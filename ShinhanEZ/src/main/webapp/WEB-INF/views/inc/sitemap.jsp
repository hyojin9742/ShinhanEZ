<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!-- sitemap -->
<div class="sitemapHead">
  <div class="topWrap">
    <h1 class="logo"><a href="${ctx}/"><span class="sr-only">신한EZ손해보험</span></a></h1>
    <div class="srchBox">
      <div class="input w-100">
        <label for="menu_search" class="sr-only">메뉴명 검색</label>
        <input type="text" name="menu_search" id="menu_search" class="input-data" placeholder="메뉴명을 검색하세요."
          title="메뉴명을 검색하세요." maxlength="20" value="" aria-required="true">
        <button type="button" class="btn-clear" aria-hidden="true" tabindex="-1">
          <span class="sr-only">입력 내용 삭제</span></button>
      </div>
      <button type="button" class="ico-btn-search" id="btn_menu_search" aria-label="검색">검색</button>
    </div>
  </div>
</div>

<div class="sitemapBody">
  <div class="gnbArea">
    <nav class="gnb gnbWrap" role="navigation" aria-label="메인">
      <ul class="menu">
        <li class="menu1">
          <h2><a href="#"><span>멤버</span></a></h2>
          <div class="subArea">
            <ul class="depth2">
              <li class="subArea">
                <h3><a href="#"><span>회원메뉴</span></a></h3>
                <ul class="depth3">
                	<sec:authorize access="isAnonymous()">
                      <li><a href="${ctx}/member/login" class="links"><span>로그인</span></a></li>
                      <li><a href="${ctx}/member/join"><span>회원가입</span></a></li>
                      <li><a href="#"><span>아이디 찾기</span></a></li>
                      <li><a href="#"><span>비밀번호 찾기</span></a></li>
                	</sec:authorize>
 					<sec:authorize access="isAuthenticated()">
						<sec:authorize access="hasRole('ADMIN')">
							<a href="${ctx}/admin" class="links link-admin">관리자페이지</a>
						</sec:authorize>
						<li><a href="${ctx}/member/logout" class="links"><span>로그아웃</span></a></li>
 					</sec:authorize>
                </ul>
              </li>
            </ul>
          </div>
        </li>
        <li class="menu1">
          <h2><a href="#"><span>회사소개</span></a></h2>
          <div class="subArea">
            <ul class="depth2">
              <li class="subArea">
                <h3><a href="#"><span>신한이지</span></a></h3>
                <ul class="depth3">
                  <li><a href="${ctx}/pages/brand"><span>브랜드</span></a></li>
                  <li><a href="${ctx}/pages/social"><span>사회공헌</span></a></li>
                  <li><a href="#"><span>주주사소개</span></a></li>
                  <li><a href="#"><span>제휴문의</span></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>신한WAY2.0</span></a></h3>
                <ul class="depth3">
                  <li><a href="#"><span>미션</span></a></li>
                  <li><a href="#"><span>핵심가치</span></a></li>
                  <li><a href="#"><span>비전</span></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="${ctx}/pages/media_room"><span>미디어룸</span></a></h3>
                <ul class="depth3">
                  <li><a href="${ctx}/pages/media_room"><span>미디어룸</span></a></li>
                </ul>
              </li>
            </ul>
          </div>
        </li>
        <li class="menu2">
          <h2><a href="#"><span>상품안내</span></a></h2>
          <div class="subArea">
            <ul class="depth2">
              <li class="subArea allProduct">
                <h3><a href="${ctx}/product/list"><span>보험상품</span></a></h3>
                <ul class="depth3">
                  <li>
                    <a href="${ctx}/product/list">
                      <span>전체 보험상품</span><strong class="badge good best">추천</strong>
                    </a>
                  </li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>추천상품</span></a></h3>
                <ul class="depth3">
                  <li><a href="#"><span>신한 SOL 해외여행 <strong class="badge good best">Best</strong></span></a></li>
                  <li><a href="#"><span>신한 SOL 해외유학</span> <strong class="badge good new">New</strong></a></li>
                  <li><a href="#"><span>신한 SOL 주택화재</span> <strong class="badge good new">New</strong></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>여행케어</span></a></h3>
                <ul class="depth3">
                  <li><a href="#"><span>해외여행보험</span></a></li>
                  <li><a href="#"><span>해외장기체류보험</span></a></li>
                  <li><a href="#"><span>국내여행보험</span></a></li>
                  <li><a href="#"><span>일본여행보험</span></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>Auto케어</span></a></h3>
                <ul class="depth3">
                  <li><a href="#"><span>운전자보험</span></a></li>
                  <li><a href="#"><span>Auto케어서비스</span></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>메디케어</span></a></h3>
                <ul class="depth3">
                  <li><a href="#"><span>건강보험</span></a></li>
                  <li><a href="#"><span>뇌·심장보험</span></a></li>
                  <li><a href="#"><span>암보험</span></a></li>
                  <li><a href="#"><span>실손의료보험</span></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="${ctx}/pages/contents_travel"><span>화재보험</span></a></h3>
                <ul class="depth3">
                  <li><a href="${ctx}/pages/contents_travel"><span>화재보험</span></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>미니생활</span></a></h3>
                <ul class="depth3">
                  <li><a href="#"><span>금융안심보험</span></a></li>
                  <li><a href="#"><span>미니골프보험</span></a></li>
                  <li><a href="#"><span>미니아웃도어보험</span></a></li>
                  <li><a href="#"><span>미니자전거보험</span></a></li>
                  <li><a href="#"><span>미니운동보험</span></a></li>
                </ul>
              </li>
            </ul>
          </div>
        </li>
        <li class="menu3">
          <h2><a href="#"><span>고객센터</span></a></h2>
          <div class="subArea">
            <ul class="depth2">
              <li class="subArea">
                <h3><a href="#"><span>고객센터</span></a></h3>
                <ul class="depth3">
                  <li><a href="#"><span>고객센터</span></a></li>
                  <li><a href="#"><span>보험용어사전</span></a></li>
                  <li><a href="#"><span>고객의 소리</span></a></li>
                  <li><a href="#"><span>준법제보센터</span></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>보험금청구</span></a></h3>
                <ul class="depth3">
                  <li><a href="${ctx}/pages/insurance_claim"><span>보험금 청구안내</span></a></li>
                  <li><a href="#"><span>필요서류안내</span></a></li>
                  <li><a href="#"><span>보험범죄신고센터</span></a></li>
                  <li><a href="#"><span>보험사기 할증보험료 환급안내</span></a></li>
                  <li><a href="#"><span>실손의료비 청구대행</span></a></li>
                </ul>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>계약조회</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>공지사항</span></a></h3>
              </li>
            </ul>
          </div>
        </li>
        <li class="menu4">
          <h2><a href="#"><span>채용</span></a></h2>
        </li>
        <li class="menu5">
          <h2><a href="#"><span>소비자포털</span></a></h2>
          <div class="subArea">
            <ul class="depth2">
              <li class="subArea">
                <h3><a href="#"><span>금융소비자보호법</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>금융소비자보호체계</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>금융소비자 실태평가</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>민원건수 공시</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>소비자보호 공지사항</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>고객의 소리</span></a></h3>
              </li>
            </ul>
          </div>
        </li>
        <li class="menu6">
          <h2><a href="#"><span>공시실</span></a></h2>
          <div class="subArea">
            <ul class="depth2">
              <li class="subArea">
                <h3><a href="#"><span>경영공시</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>사회공헌활동공시</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>방카슈랑스 모집수수료율</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>직업 및 위험등급분류표</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>상품공시</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>가격공시</span></a></h3>
              </li>
              <li class="subArea">
                <h3><a href="#"><span>보호금융상품등록부</span></a></h3>
              </li>
            </ul>
          </div>
        </li>
        <li class="menuLink01">
          <h2>
            <a href="#" class="links">
              <span>기업고객<span class="sr-only">새창으로 열림</span>
                <em class="ico-arrow"></em></span>
            </a>
          </h2>
        </li>
        <li class="menuLink02">
          <h2>
            <a href="#" class="links">
              <span>신한 SOL 다이렉트보험<span class="sr-only">새창으로 열림</span>
                <em class="ico-arrow"></em></span></a>
          </h2>
        </li>
      </ul>
    </nav>
  </div>
  <div class="noData">
    <img src="${ctx}/images/result-pic.png" alt="결과 안내 이미지">
    <p>검색 결과가 없습니다.</p>
  </div>
</div>
<button type="button" class="ico-btn-close" onclick="icoBtnClose2()"><span class="sr-only">전체 메뉴
    닫기</span></button>

<!-- //sitemap -->