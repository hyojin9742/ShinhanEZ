<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!-- header -->
<div class="topWrap">
  <div class="inner-wrap">
    <h1 class="logo">
      <a href="${ctx}/">
        <span class="sr-only">신한EZ손해보험</span>
      </a>
    </h1>
    <nav class="utilList" role="navigation" aria-label="관련 사이트 선택">
      <div class="linkGroup">
      <c:choose>
      	<c:when test="${empty sessionScope.loginUser}">
        	<a href="${ctx}/member/login" class="links">로그인</a>      	
      	</c:when>
      	<c:otherwise>
      		<c:if test="${sessionScope.userRole == 'ROLE_ADMIN'}">
                <a href="${ctx}/admin" class="links link-admin">관리자페이지</a>
            </c:if>
      		<span class="links user-name">
      			<c:choose>
      				<c:when test="${sessionScope.userRole == 'ROLE_ADMIN'}">
      					<c:choose>
			                <c:when test="${sessionScope.adminRole == 'super'}">
			                    <span><a href="/mypage/payments">${sessionScope.adminName}(관리자)님</a></span>
			                </c:when>
			                <c:when test="${sessionScope.adminRole == 'manager'}">
			                    <span><a href="/mypage/payments">${sessionScope.adminName}(매니저)님</a></span>
			                </c:when>
			                <c:otherwise>
			                    <span><a href="/mypage/payments">${sessionScope.adminName}(스태프)님</a></span>
			                </c:otherwise>
			            </c:choose>
     				</c:when>
      				<c:otherwise><a href="/mypage/payments">${sessionScope.userName}님</a></c:otherwise>
      			</c:choose>
      		</span>
        	<a href="${ctx}/member/logout" class="links">로그아웃</a>   		
      	</c:otherwise>
      </c:choose>
        <a href="#" class="links">소비자포털</a>
        <a href="#" class="links">공시실</a>
        <a href="#" class="links">기업고객
          <span class="sr-only">새창으로 열림</span>
          <em class="ico-arrow"></em>
        </a>
        <a href="#" class="links">신한 SOL 다이렉트보험
          <span class="sr-only">새창으로 열림</span>
          <em class="ico-arrow"></em>
        </a>
      </div>
    </nav>
  </div>
</div>

<div class="gnbArea">
  <nav class="gnb gnbWrap" id="gnb" role="navigation" aria-label="주메뉴">
    <ul class="menu" id="headerMenu">
      <li>
        <a href="#"><span>회사소개</span></a>
        <div class="subArea">
          <div class="subWrap">
            <ul class="depth2">
              <li><a href="#"><span>신한이지</span></a>
                <ul class="depth3">
                  <li class="point"><a href="${ctx}/pages/brand"><span>브랜드</span></a></li>
                  <li class="point"><a href="${ctx}/pages/social"><span>사회공헌</span></a></li>
                  <li><a href="#"><span>주주사소개</span></a></li>
                  <li><a href="#"><span>제휴문의</span></a></li>
                </ul>
              </li>
              <li><a href="#"><span>신한WAY2.0</span></a>
                <ul class="depth3">
                  <li><a href="#"><span>미션</span></a></li>
                  <li><a href="#"><span>핵심가치</span></a></li>
                  <li><a href="#"><span>비전</span></a></li>
                </ul>
              </li>
              <li class="point"><a href="${ctx}/board/list"><span>미디어룸</span></a>
                <ul class="depth3">
                  <li><a href="${ctx}/board/list"><span>미디어룸</span></a></li>
                </ul>
              </li>
              <li>
                <a href="#" class="links">
                  <span>신한금융그룹
                    <span class="sr-only">새창으로 열림</span>
                    <em class="ico-arrow"></em>
                  </span>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </li>
      <li><a href="${ctx}/product/list"><span>상품안내</span></a>
        <div class="subArea">
          <div class="subWrap">
            <ul class="depth2">
              <li class="point"><a href="${ctx}/product/list"><span>보험상품</span></a>
                <ul class="depth3">
                  <li>
                    <a href="${ctx}/product/list">
                      <span>전체 보험상품</span><strong class="badge good best">추천</strong>
                    </a>
                  </li>
                </ul>
              </li>
              <li><a href="#"><span>추천상품</span></a>
                <ul class="depth3">
                  <li>
                    <a href="#">
                      <span>신한 SOL 해외여행</span><strong class="badge good best">베스트상품</strong>
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <span>신한 SOL 해외유학</span><strong class="badge good new">신규상품</strong>
                    </a>
                  </li>
                </ul>
              </li>
              <li>
                <a href="#"><span>여행케어</span></a>
                <ul class="depth3">
                  <li><a href="#"><span>해외여행보험</span></a></li>
                  <li><a href="#"><span>해외장기체류보험</span></a></li>
                  <li><a href="#"><span>국내여행보험</span></a></li>
                </ul>
              </li>
              <li>
                <a href="#"><span>Auto케어</span></a>
                <ul class="depth3">
                  <li><a href="#"><span>운전자보험</span></a></li>
                </ul>
              </li>
              <li>
                <a href="#"><span>메디케어</span></a>
                <ul class="depth3">
                  <li><a href="#"><span>건강보험</span></a></li>
                  <li><a href="#"><span>암보험</span></a></li>
                </ul>
              </li>
              <li class="point">
                <a href="${ctx}/pages/contents_travel"><span>화재보험</span></a>
                <ul class="depth3">
                  <li><a href="${ctx}/pages/contents_travel"><span>화재보험</span></a></li>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      </li>
      <li>
        <a href="#"><span>고객센터</span></a>
        <div class="subArea">
          <div class="subWrap">
            <ul class="depth2">
              <li><a href="#"><span>고객센터</span></a>
                <ul class="depth3">
                  <li><a href="#"><span>고객센터</span></a></li>
                  <li><a href="#"><span>보험용어사전</span></a></li>
                </ul>
              </li>
              <li class="point"><a href="${ctx}/pages/user_claim"><span>보험금청구</span></a>
                <ul class="depth3">
                  <li><a href="${ctx}/pages/user_claim"><span>보험금 청구안내</span></a></li>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      </li>
      <li>
        <a href="#"><span>채용</span></a>
        <div class="subArea">
          <div class="subWrap">
            <ul class="depth2"></ul>
          </div>
        </div>
      </li>
    </ul>
    <div class="utilApp">
      <button type="button" class="ico-btn-appMenu" aria-label="전체 메뉴" onclick="icoBtnAppMenu()">
        <span class="sr-only">전체 메뉴 열기</span>
      </button>
    </div>
  </nav>
</div>
<div id="gnbBg"></div>
<div class="hiddenPC visibleMb">
  <div class="bg"></div>
  <h1 class="logo">
    <span class="sr-only">신한EZ손해보험 홈</span>
  </h1>
  <button type="button" class="ico-btn-appMenu" aria-label="전체 메뉴" onclick="icoBtnAppMenu()"></button>
</div>
<!--//header-->
