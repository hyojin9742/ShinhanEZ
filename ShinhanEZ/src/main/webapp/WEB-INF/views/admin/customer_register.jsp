<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
</head>
<body class="admin-page">
<div class="admin-wrapper">

    <!-- 사이드바 -->
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="customer"/>
    </jsp:include>

    <!-- 메인 영역 -->
    <div class="admin-main">

        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="고객 등록"/>
        </jsp:include>

        <!-- 콘텐츠 -->
        <main class="admin-content">

            <!-- 페이지 타이틀 -->
            <div class="page-header">
                <h2>고객 등록</h2>
                <p>새로운 고객(보험자) 정보를 등록합니다.</p>
            </div>

            <!-- 에러 메시지 -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <!-- 등록 폼 카드 -->
            <div class="card">
                <div class="card-header">
                    <span><i class="bi bi-person-plus"></i> 고객 정보 입력</span>
                </div>
                <div class="card-body">
                    <form action="${ctx}/admin/customer/register" method="post" class="admin-form" onsubmit="return validateForm()">

                        <div class="form-row">
                            <div class="form-group">
                                <label>고객 ID <span class="required">*</span></label>
                                <div class="input-group">
                                    <input type="text" name="customerId" id="customerId"
                                           value="${customer.customerId}" class="form-control"
                                           placeholder="영문, 숫자 조합" required>
                                    <button type="button" class="btn btn-outline" onclick="checkId()">
                                        중복확인
                                    </button>
                                </div>
                                <small id="idCheckMsg" class="form-text"></small>
                            </div>
                            <div class="form-group">
                                <label>이름 <span class="required">*</span></label>
                                <input type="text" name="name" value="${customer.name}"
                                       class="form-control" placeholder="이름 입력" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>비밀번호 <span class="required">*</span></label>
                                <input type="password" name="password" id="password"
                                       class="form-control" placeholder="비밀번호 입력" required>
                            </div>
                            <div class="form-group">
                                <label>비밀번호 확인 <span class="required">*</span></label>
                                <input type="password" name="passwordConfirm" id="passwordConfirm"
                                       class="form-control" placeholder="비밀번호 재입력" required>
                                <small id="pwCheckMsg" class="form-text"></small>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>생년월일 <span class="required">*</span></label>
                                <input type="date" name="birthDate" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>성별 <span class="required">*</span></label>
                                <div class="radio-group">
                                    <label class="radio-label">
                                        <input type="radio" name="gender" value="M"
                                               <c:if test="${customer.gender == 'M' || empty customer.gender}">checked</c:if>>
                                        <span>남성</span>
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="gender" value="F"
                                               <c:if test="${customer.gender == 'F'}">checked</c:if>>
                                        <span>여성</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>연락처 <span class="required">*</span></label>
                                <input type="text" name="phone" value="${customer.phone}"
                                       class="form-control" placeholder="010-0000-0000" required>
                            </div>
                            <div class="form-group">
                                <label>이메일</label>
                                <input type="email" name="email" value="${customer.email}"
                                       class="form-control" placeholder="email@example.com">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group full">
                                <label>주소</label>
                                <input type="text" name="address" value="${customer.address}"
                                       class="form-control" placeholder="주소를 입력하세요">
                            </div>
                        </div>

                        <!-- 버튼 영역 -->
                        <div class="btn-area">
                            <a href="${ctx}/admin/customer/list" class="btn btn-outline">
                                <i class="bi bi-x-lg"></i> 취소
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg"></i> 등록
                            </button>
                        </div>

                    </form>
                </div>
            </div>

        </main>

        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>

    </div>
</div>

<script>
    var idChecked = false;

    // 고객 ID 중복 체크 (AJAX)
    function checkId() {
        var customerId = document.getElementById('customerId').value.trim();
        var msgEl = document.getElementById('idCheckMsg');

        if(!customerId) {
            msgEl.textContent = '고객 ID를 입력하세요.';
            msgEl.style.color = 'red';
            return;
        }

        fetch('${ctx}/admin/customer/checkId?customerId=' + encodeURIComponent(customerId))
            .then(response => response.json())
            .then(data => {
                if(data.exists) {
                    msgEl.textContent = data.message;
                    msgEl.style.color = 'red';
                    idChecked = false;
                } else {
                    msgEl.textContent = data.message;
                    msgEl.style.color = 'green';
                    idChecked = true;
                }
            })
            .catch(error => {
                msgEl.textContent = '중복 확인 중 오류가 발생했습니다.';
                msgEl.style.color = 'red';
            });
    }

    // ID 입력 시 중복확인 초기화
    document.getElementById('customerId').addEventListener('input', function() {
        idChecked = false;
        document.getElementById('idCheckMsg').textContent = '';
    });

    // 비밀번호 확인 체크
    document.getElementById('passwordConfirm').addEventListener('input', function() {
        var pw = document.getElementById('password').value;
        var pwConfirm = this.value;
        var msgEl = document.getElementById('pwCheckMsg');

        if(pwConfirm && pw !== pwConfirm) {
            msgEl.textContent = '비밀번호가 일치하지 않습니다.';
            msgEl.style.color = 'red';
        } else if(pwConfirm && pw === pwConfirm) {
            msgEl.textContent = '비밀번호가 일치합니다.';
            msgEl.style.color = 'green';
        } else {
            msgEl.textContent = '';
        }
    });

    // 폼 유효성 검사
    function validateForm() {
        if(!idChecked) {
            alert('고객 ID 중복확인을 해주세요.');
            return false;
        }

        var pw = document.getElementById('password').value;
        var pwConfirm = document.getElementById('passwordConfirm').value;
        if(pw !== pwConfirm) {
            alert('비밀번호가 일치하지 않습니다.');
            return false;
        }

        return true;
    }
</script>
</body>
</html>
