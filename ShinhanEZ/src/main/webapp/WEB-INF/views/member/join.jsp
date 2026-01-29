<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">

<head id="inc-head">
	<jsp:include page="/WEB-INF/views/inc/head.jsp"></jsp:include>
</head>
<c:if test="${param.msg=='0' }">
	<script type="text/javascript">
		alert('회원가입 실패! 다시 입력해주세요');	
	</script>
</c:if>
<c:if test="${param.msg=='oauth' }">
	<script type="text/javascript">
		alert('상세정보 입력이 필요합니다.');	
	</script>
</c:if>
<body class="sub">
	<sec:authentication property="principal" var="principal"/>
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
        <article id="content">
          <section class="page-title">
            <div class="inner-wrap">
              <h1 class="headline-lg">회원가입</h1>
            </div>
          </section>
          <section class="content-area join">
            <div class="inner-wrap">
              <div id="join_inner">
                <form action="<%=ctx%>/member/join" id="join_form" method="post">
                  <div class="join_content">
                    <!-- ID, 비밀번호, 이메일 -->
                    <div class="form_list" id="id_pw">
                      <div class="form_item id">
                      <c:choose>
						    <%-- 1. 이름이 있을 때 (값이 채워진 상태) --%>
						    <c:when test="${principal.attributes != null}">
						        <input type="text" name="id" id="id" placeholder="아이디" value="${principal.email}" required readonly="readonly">
						    </c:when>
						
						    <%-- 2. 그 외 (이름이 없을 때) --%>
						    <c:otherwise>
						        <input type="text" name="id" id="id" placeholder="아이디" required>
						    </c:otherwise>
						</c:choose>
                      
                      
                        
                      </div>
                      <div class="form_item pw">
                        <input type="password" name="pw" id="pw" placeholder="비밀번호" required>
                      </div>
                      <div class="form_item email">
                        <c:choose>
						    
						    <c:when test="${principal.attributes != null}">
						        <input type="text" name="email" id="email" placeholder="이메일" value="${principal.email}" required readonly="readonly">
						    </c:when>
						
						    <%-- 2. 그 외 (이름이 없을 때) --%>
						    <c:otherwise>
						        <input type="text" name="email" id="email" placeholder="이메일" required>
						    </c:otherwise>
						</c:choose>
                      </div>
                    </div>
                  			<c:choose>
							    <%-- 1. 이름이 있을 때 (값이 채워진 상태) --%>
							    <c:when test="${principal.attributes != null}">
							        <input type="hidden" name="provider" id="provider" placeholder="제공" value="${principal.sub}">
							    </c:when>    
							</c:choose>
                    
                    

                    <div class="errMsg">
                      <div class="err_item id">
                        <span>* ID는 필수 입력항목입니다</span>
                      </div>
                      <div class="err_item pw">
                        <span>* 비밀번호는 필수 입력항목입니다</span>
                      </div>
                    </div>

                    <!-- 이름, 생년월일, 통신사, 성별, 내외국인 -->
                    <div class="form_list" id="name_birth">
                      <div class="form_item name">
                        
                        
                        <c:choose>
						    
						    <c:when test="${principal.attributes != null}">
						        <input type="text" name="name" id="name" placeholder="이름" value="${principal.OAuthName}" required readonly="readonly">
						    </c:when>
						
						    <%-- 2. 그 외 (이름이 없을 때) --%>
						    <c:otherwise>
						        <input type="text" name="name" id="name" placeholder="이름" required>
						    </c:otherwise>
						</c:choose>
                        
                      </div>

                      <div class="form_item birth">
                        <input type="date" name="birth" id="birth" placeholder="생년월일 8자리" required>
                      </div>

                      <div class="form_item telecom">
                        <input type="hidden" name="telecom" id="telecomData" value="">
                        <input type="text" id="telecomView" class="telecom_view" placeholder="통신사 선택" readonly>

                        <span class="icon_arrow down" id="telecomArrow" aria-hidden="true"></span>

                        <div class="tel_itemDiv">
                          <ul class="tel_item">
                            <li class="tel_item_list"><button type="button" data-value="SKT">SKT</button></li>
                            <li class="tel_item_list"><button type="button" data-value="SKT알뜰폰">SKT 알뜰폰</button></li>
                            <li class="tel_item_list"><button type="button" data-value="KT">KT</button></li>
                            <li class="tel_item_list"><button type="button" data-value="KT알뜰폰">KT 알뜰폰</button></li>
                            <li class="tel_item_list"><button type="button" data-value="LGU+">LG U+</button></li>
                            <li class="tel_item_list"><button type="button" data-value="LGU+알뜰폰">LG U+ 알뜰폰</button></li>
                          </ul>
                        </div>
                      </div>

                      <div class="form_item">
                        <div class="gender_nation">
                          <ul class="gender">
                            <li>
                              <input type="radio" name="gender" id="gen_male" value="M" checked>
                              <label for="gen_male">남자</label>
                            </li>
                            <li>
                              <input type="radio" name="gender" id="gen_female" value="F">
                              <label for="gen_female">여자</label>
                            </li>
                          </ul>
                          <ul class="nation">
                            <li>
                              <input type="radio" name="nation" id="nation_local" value="K" checked>
                              <label for="nation_local">내국인</label>
                            </li>
                            <li>
                              <input type="radio" name="nation" id="nation_foreign" value="F">
                              <label for="nation_foreign">외국인</label>
                            </li>
                          </ul>
                        </div>
                      </div>
                    </div>

                    <div class="errMsg">
                      <div class="err_item name">
                        <span>* 이름은 필수 입력항목입니다</span>
                      </div>
                      <div class="err_item birth">
                        <span>* 생년월일을 입력해주세요</span>
                      </div>
                    </div>

                    <!-- 휴대전화 -->
                    <div class="form_list" id="phone">
                      <div class="form_item phone">
                        <input type="tel" name="phone" id="phoneNum" placeholder="휴대전화번호" required>
                        <span class="timer" id="authTimer"></span>
                      </div>
                    </div>

                    <div class="errMsg">
                      <div class="err_item phone">
                        <span>* 휴대전화를 입력해주세요</span>
                      </div>
                      <div class="err_item auth_fail">
                        <span>* 인증시간이 초과되었습니다. 다시 요청해주세요</span>
                      </div>
                    </div>

                    <!-- 인증번호 입력 (인증요청 후 표시) -->
                    <div class="form_list" id="authCode">
                      <div class="form_item auth">
                        <input type="text" name="authCode" id="authCodeInput" placeholder="인증번호 6자리 입력" maxlength="6">
                      </div>
                    </div>

                    <div class="errMsg">
                      <div class="err_item auth_code">
                        <span>* 인증번호를 입력해주세요</span>
                      </div>
                    </div>

                    <!-- 인증약관동의 -->
                    <div class="form_list" id="term">
                      <div class="form_item term">
                        <div class="term_title">
                          <input type="checkbox" name="agreeAll" id="agreeAll">
                          <label for="agreeAll" class="mainCheck uncheck">
                            <span>[필수]</span>&nbsp;인증 약관 전체동의</label>
                          <button type="button" class="icon_arrow down"></button>
                        </div>
                        <div class="term_list">
                          <ul class="term_item">
                            <li class="subCheck uncheck">
                              <input type="checkbox" id="agree01">
                              <label for="agree01">개인정보 이용</label>
                            </li>
                            <li class="subCheck uncheck">
                              <input type="checkbox" id="agree02">
                              <label for="agree02">고유식별정보 처리</label>
                            </li>
                            <li class="subCheck uncheck">
                              <input type="checkbox" id="agree03">
                              <label for="agree03">통신사 이용약관</label>
                            </li>
                            <li class="subCheck uncheck">
                              <input type="checkbox" id="agree04">
                              <label for="agree04">인증사 이용약관</label>
                            </li>
                            <li class="subCheck uncheck">
                              <input type="checkbox" id="agree05">
                              <label for="agree05">개인정보수집</label>
                            </li>
                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- 버튼 -->
                  <div class="form_list" id="form_authBtn">
                    <button type="button" class="authBtn">인증요청</button>
                  </div>

                  <div class="form_list" id="form_joinBtn">
                    <button type="submit" class="joinBtn">가입하기</button>
                  </div>
                </form>
              </div>
            </div>
          </section>
        </article>
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