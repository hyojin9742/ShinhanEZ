<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!--footer-->
<nav class="footNav" role="navigation" aria-label="고객서비스 Navigation">
  <ul class="sectionList">
    <li>
      <button type="button" class="ico-btn-open">사이트 이용안내</button>
      <ul>
        <li><a href="#">사이트 이용약관</a></li>
        <li><a href="#"><strong class="bold bb-line-1px space-pb-1px">개인정보처리방침</strong></a></li>
        <li><a href="#">고객정보취급방침</a></li>
        <li><a href="#">영상정보처리기기운영방침</a></li>
      </ul>
    </li>
    <li>
      <button type="button" class="ico-btn-open">소비자보호</button>
      <ul>
        <li><a href="#">과오납보험료 환급안내</a></li>
        <li><a href="#">서민금융 1332</a></li>
      </ul>
    </li>
    <li>
      <button type="button" class="ico-btn-open">고객이 알아야할 사항</button>
      <ul>
        <li><a href="#">보험계약 청약시 유의사항</a></li>
        <li><a href="#">전자금융거래 유의사항</a></li>
        <li><a href="#">전자금융거래 이용약관</a></li>
      </ul>
    </li>
    <li>
      <button type="button" class="ico-btn-open">신한금융그룹</button>
      <ul>
        <li><a href="#" target="_blank">신한은행</a></li>
        <li><a href="#" target="_blank">신한카드</a></li>
        <li><a href="#" target="_blank">신한투자증권</a></li>
        <li><a href="#" target="_blank">신한라이프</a></li>
      </ul>
    </li>
  </ul>
</nav>

<div class="companyInfo">
  <div class="infoArea">
    <p class="logo">신한EZ손해보험</p>
    <div class="linkGroup">
      <a href="#" class="links">상품공시</a>
      <a href="#" class="links">가격공시</a>
      <a href="#" class="links bold">개인정보처리방침</a>
    </div>
    <div class="phoneGroup">
      <span class="customer-tel">고객센터 <a href="tel:1544-2580">1544-2580</a></span>
    </div>
    <address class="hiddenMb">
      <span>04522 서울특별시 중구 남대문로 113 DB다동빌딩 5층 신한EZ손해보험 주식회사</span>
      <span>대표이사 강병관</span>
      <span>사업자등록번호 220-86-65241</span>
    </address>
    <div class="copyright">ⓒ Shinhan EZ General Insurance Co., Ltd.</div>
  </div>
  <div class="markInfo hiddenMb">
    <a href="#" target="_blank">
      <img src="${ctx}/images/Web_Mark2.svg" alt="WEB접근성 품질인증 마크">
    </a>
  </div>
</div>

<script>
  $(function () {
    var footerBtnOpen = $('footer .sectionList .ico-btn-open');
    $(footerBtnOpen).each(function () {
      $(this).append(' <span class="blind"> 메뉴</span><span class="waTxt">펼치기</span>');
    });
    $(footerBtnOpen).click(function (e) {
      if ($('.footNav').hasClass('on') == false) {
        $('.footNav').addClass('on');
        $('footer .sectionList ul').stop().slideDown(300, 'easeInOutExpo');
        $('footer .sectionList .ico-btn-open .waTxt').text('접기');
      } else {
        $('.footNav').removeClass('on');
        $('footer .sectionList ul').stop().slideUp(300, 'easeInOutExpo');
        $('footer .sectionList .ico-btn-open .waTxt').text('펼치기');
      }
      e.preventDefault();
    });
  });
</script>
<!--//footer-->
