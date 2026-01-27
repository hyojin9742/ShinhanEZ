<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head id="inc-head">
	<%@ include file="/WEB-INF/views/inc/head.jsp" %>
</head>
<c:if test="${param.join == 'success'}">
	<script>alert('회원가입 성공! 로그인 해주세요.');</script>
</c:if>
<c:if test="${param.error == 'auth'}">
	<script>alert('관리자 권한이 필요합니다.');</script>
</c:if>
<body class="sub">
  <div id="wrap">
    <div id="skip">
      <div class="skip-menu"><a href="#">본문으로 건너뛰기</a></div>
    </div>
    <div id="page" data-page-main="true">
      <header id="header" class="header">
      	<%@ include file="/WEB-INF/views/inc/header.jsp" %>
      </header>

      <main id="main">
      <article id="content">
        <section class="page-title">
          <div class="inner-wrap">
            <h1 class="headline-lg">로그인</h1>
          </div>
        </section>
        <div class="login_inner">
          <div class="login_wrap">
            <input type="radio" name="menu_radio" id="chk_id" class="menu_chk" checked>
            <input type="radio" name="menu_radio" id="chk_num" class="menu_chk">
            <input type="radio" name="menu_radio" id="chk_qr" class="menu_chk">
        
            <ul class="menu_wrap">
              <li><label for="chk_id" class="menu_tab menu_id">ID/전화번호</label></li>
              <li><label for="chk_num" class="menu_tab menu_num">일회용 번호</label></li>
              <li><label for="chk_qr" class="menu_tab menu_qr">QR코드</label></li>
            </ul>
        
            <div class="panel_area">
              <!-- 패널1: ID 로그인 -->
              <form action="${ctx}/member/login" class="panel panel_id" id="panel_id" method="post">
                <div class="panel_inner">
                  <c:if test="${not empty error}">
                    <div class="error_msg" style="color:red; text-align:center; margin-bottom:15px;">${error}</div>
                  </c:if>
                  <div class="input_item id">
                    <input type="text" name="id" id="id" placeholder=" " autocomplete="username">
                    <label for="id">아이디 또는 전화번호</label>
                    <button type="button" class="btn_clear" aria-label="입력 지우기"></button>
                  </div>
        
                  <div class="input_item pw">
                    <input type="password" name="pw" id="pw" placeholder=" " autocomplete="current-password">
                    <label for="pw">비밀번호</label>
                    <button type="button" class="btn_clear" aria-label="입력 지우기"></button>
                  </div>
        
                  <div class="login_option">
                    <label class="keep_check">
                      <input type="checkbox" name="keepLogin" checked>
                      <span class="check_icon"></span>
                      <span class="keep_text">로그인 상태 유지</span>
                    </label>
                  </div>
        
                  <div class="login_btn_wrap">
                    <button type="submit" class="btn_login" id="btnLoginId">로그인</button>
                  </div>
                </div>
              </form>
        
              <!-- 패널2: 일회용 번호 (데모용) -->
              <form action="#" class="panel panel_num" id="panel_num" novalidate>
                <div class="panel_inner">
                  <p class="guide_text">
                    신한EZ보험 앱의 <strong>메뉴 &gt; 설정 &gt; 로그인 아이디 관리 &gt; 더보기</strong>에서<br>
                    <strong>일회용 로그인 번호</strong>에 보이는 번호를 입력해 주세요.
                  </p>
                  <div class="input_item single">
                    <input type="text" name="once" id="once" placeholder=" " inputmode="numeric" maxlength="8">
                    <label for="once">번호를 입력하세요.</label>
                  </div>
                  <div class="login_btn_wrap">
                    <button type="submit" class="btn_login" disabled>로그인</button>
                  </div>
                </div>
              </form>
        
              <!-- 패널3: QR코드 (데모용) -->
              <div class="panel panel_qr" id="panel_qr">
                <div class="panel_inner qr_inner">
                  <div class="qr_box" id="qrBox">
                    <img class="qr_img" src="${ctx}/images/qr-code.png" alt="QR코드">
                  </div>
                  <div class="qr_guide">
                    <p>공용 네트워크 · 공용 PC라면 안전을 위해<br>QR코드로 로그인해 주세요.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        
          <div class="find_wrap">
            <ul class="find_text">
              <li><a href="#">비밀번호 찾기</a></li>
              <li><a href="#">아이디 찾기</a></li>
              <li><a href="${ctx}/member/join">회원가입</a></li>
            </ul>
          </div>

          <!-- 소셜 로그인 -->
          <div class="social_login_wrap">
            <p class="social_title">간편 로그인</p>
            <div class="social_btn_group">
              <a href="${ctx}/oauth/naver" class="social_btn naver" title="네이버 로그인">
                <span class="social_icon naver_icon"></span>
                <span class="social_text">네이버</span>
              </a>
              <a href="${ctx}/oauth/kakao" class="social_btn kakao" title="카카오 로그인">
                <span class="social_icon kakao_icon"></span>
                <span class="social_text">카카오</span>
              </a>
              <a href="/oauth2/authorization/google" class="social_btn google" title="구글 로그인">
                <span class="social_icon google_icon"></span>
                <span class="social_text">구글</span>
              </a>
            </div>
          </div>
        </div>
      </article>
      </main>

      <footer id="footer" class="footer">
      	<%@ include file="/WEB-INF/views/inc/footer.jsp" %>
      </footer>
    </div>
    <button type="button" id="btn-page-top"><span class="sr-only">상단으로 이동</span></button>
  </div>

  <div id="sitemap" class="sitemapArea">
  	<%@ include file="/WEB-INF/views/inc/sitemap.jsp" %>
  </div>
  <script src="${ctx}/js/login.js"></script>
</body>
</html>
