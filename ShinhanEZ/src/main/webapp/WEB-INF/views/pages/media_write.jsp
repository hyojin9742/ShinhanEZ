<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
          <c:choose>
          	<c:when test="${mode=='write' }">
        	  <section class="page-title">
	            <div class="inner-wrap">
	              <h1 class="headline-lg">글쓰기</h1>
	            </div>
	          </section>
	          <section class="content-area">
	            <div class="inner-wrap">
	              <div class="write-form">
	                <form action="<%=ctx%>/shboardinsert" method="POST">
	                  <div class="form-group">
	                    <label for="title">제목 *</label>
	                    <input type="text" id="title" name="title" required maxlength="200" placeholder="제목을 입력하세요">
	                  </div>
	                  <div class="form-group">
	                  	<ul class = etcList>
	                  		<li>작성자 : ${id }</li>
	                  		<li>조회수 : 0</li>
	                  	</ul>
	                  </div>
	                  <div class="form-group">
	                    <label for="content">내용 *</label>
	                    <textarea id="textarea" name="textarea" required placeholder="내용을 입력하세요"></textarea>
	                     <div class="btn-group option-min space-mt-xxl">
	                       <button type="button" class="btn large grey-outline" onclick="history.back()">
	                         <span>목록</span>
	                       </button>
	                       <button type="submit" class="btn large primary">
	                         <span>등록하기</span>
	                       </button>
	                       <button type="reset" class="btn large blue-filled" onclick="return confirm('정말 취소하시겠습니까?');">
	                         <span>취소</span>
	                       </button>
	                     </div>
	                  </div>
	                </form>
	              </div>
	            </div>
	          </section>
          	</c:when>
          	
          	<c:otherwise>
          		<section class="page-title">
	            <div class="inner-wrap">
	              <h1 class="headline-lg">글 수정</h1>
	            </div>
	          </section>
	          <section class="content-area">
	            <div class="inner-wrap">
	              <div class="write-form">
	                <form action="<%=ctx%>/shboardupdate?idx=${bdto.idx }" method="POST">
	                  <div class="form-group">
	                    <label for="title">제목 *</label>
	                    <input type="text" id="title" name="title" required maxlength="200" value = "${bdto.title }">
	                  </div>
	                  <div class="form-group">
	                  	<ul class = etcList>
	                  		<li>작성자 : ${id }</li>
	                  		<li>조회수 : ${bdto.cnt }</li>
	                  		<li>작성일 : ${bdto.reg_date }</li>
	                  	</ul>
	                  </div>
	                  <div class="form-group">
	                    <label for="content">내용 *</label>
	                    <textarea id="textarea" name="textarea" required placeholder="내용을 입력하세요">${bdto.textarea }</textarea>
	                     <div class="btn-group option-min space-mt-xxl">
	                       <button type="button" class="btn large grey-outline" onclick="location.href='<%=ctx%>/shboardlist'">
	                         <span>목록</span>
	                       </button>
	                       <button type="submit" class="btn large primary">
	                         <span>수정하기</span>
	                       </button>
	                       <button type="reset" class="btn large blue-filled" onclick="if(confirm('정말 취소하시겠습니까?')) { 
	                       						location.href='<%=ctx%>/shboardupdate?idx=${bdto.idx}&&mode=update'; 
	                       						} return false;">
	                         <span>취소</span>
	                       </button>
	                     </div>
	                  </div>
	                </form>
	              </div>
	            </div>
	          </section>
          	</c:otherwise>
          </c:choose>
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