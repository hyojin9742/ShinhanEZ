$(function () {
  /* ========================================
     통신사 선택 드롭다운
     ======================================== */
  const $view = $("#telecomView");
  const $list = $(".tel_itemDiv");
  const $arrow = $("#telecomArrow");
  const DEFAULT_TEL_TEXT = "통신사 선택";
  let isTelToggling = false;

  function setTelPlaceholder() {
    if (!$("#telecomData").val()) {
      $view.val(DEFAULT_TEL_TEXT).addClass("is-placeholder");
    }
  }

  function openTel() {
    if (isTelToggling) return;
    isTelToggling = true;

    $list.stop(true, false).slideDown(200, function() {
      isTelToggling = false;
    });
    $view.addClass("open");
    $arrow.removeClass("down").addClass("up");
  }

  function closeTel() {
    if (isTelToggling) return;
    isTelToggling = true;

    $list.stop(true, false).slideUp(200, function() {
      isTelToggling = false;
    });
    $view.removeClass("open");
    $arrow.removeClass("up").addClass("down");
  }

  setTelPlaceholder();

  $view.on("click", function (e) {
    e.preventDefault();
    e.stopPropagation();

    if ($view.hasClass("open")) {
      closeTel();
    } else {
      openTel();
    }
  });

  // readonly이므로 focus/blur 이벤트 불필요 (placeholder는 클릭 시에만 관리)

  $(".tel_item_list button").on("click", function (e) {
    e.stopPropagation();
    const value = $(this).data("value");
    $("#telecomData").val(value);
    $view.val(value).removeClass("is-placeholder");
    closeTel();
  });

  $list.on("click", function (e) {
    e.stopPropagation();
  });

  $(document).on("click", function () {
    closeTel();
  });

  /* ========================================
     약관 전체동의 / 개별동의
     ======================================== */
  const $agreeAll = $("#agreeAll");
  const $subChecks = $(".term_item input[type='checkbox']");

  // 전체동의 체크 시 → 하위 항목 전체 체크/해제
  $agreeAll.on("change", function () {
    const isChecked = $(this).is(":checked");
    
    // 하위 체크박스 전체 체크/해제
    $subChecks.prop("checked", isChecked);
    
    // 스타일 변경
    if (isChecked) {
      $(this).next("label").removeClass("uncheck").addClass("all_check");
      $subChecks.each(function() {
        $(this).parent().removeClass("uncheck").addClass("check");
      });
    } else {
      $(this).next("label").removeClass("all_check").addClass("uncheck");
      $subChecks.each(function() {
        $(this).parent().removeClass("check").addClass("uncheck");
      });
    }
  });

  // 하위 항목 개별 체크 시 → 전체동의 상태 업데이트
  $subChecks.on("change", function () {
    const $this = $(this);
    
    // 개별 스타일 변경
    if ($this.is(":checked")) {
      $this.parent().removeClass("uncheck").addClass("check");
    } else {
      $this.parent().removeClass("check").addClass("uncheck");
    }
    
    // 모든 하위 항목이 체크되었는지 확인
    const allChecked = $subChecks.length === $subChecks.filter(":checked").length;
    
    // 전체동의 체크박스 상태 업데이트
    $agreeAll.prop("checked", allChecked);
    if (allChecked) {
      $agreeAll.next("label").removeClass("uncheck").addClass("all_check");
    } else {
      $agreeAll.next("label").removeClass("all_check").addClass("uncheck");
    }
  });


  // 약관 펼침/접힘
  let isTermToggling = false;

  $(".term_title button").on("click", function (e) {
    e.preventDefault();
    e.stopPropagation();

    if (isTermToggling) return; // 애니메이션 중이면 무시
    isTermToggling = true;

    const $termList = $(".term_list");
    const $arrow = $(this);
    const isVisible = $termList.is(":visible");

    if (isVisible) {
      // 현재 열려있으면 닫기
      $termList.stop(true, false).slideUp(300, function() {
        isTermToggling = false;
      });
      $arrow.removeClass("up").addClass("down");
    } else {
      // 현재 닫혀있으면 열기
      $termList.stop(true, false).slideDown(300, function() {
        isTermToggling = false;
      });
      $arrow.removeClass("down").addClass("up");
    }
  });

  /* ========================================
     인증요청 & 타이머
     ======================================== */
  let authTimer = null;
  let timeLeft = 180; // 3분 = 180초

  function formatTime(seconds) {
    const min = Math.floor(seconds / 60);
    const sec = seconds % 60;
    return min + ":" + (sec < 10 ? "0" : "") + sec;
  }

  function startTimer() {
    timeLeft = 180;
    $("#authTimer").text(formatTime(timeLeft)).show();
    $(".err_item.auth_fail").hide();
    
    authTimer = setInterval(function() {
      timeLeft--;
      $("#authTimer").text(formatTime(timeLeft));
      
      if (timeLeft <= 0) {
        clearInterval(authTimer);
        authTimer = null;
        $("#authTimer").text("0:00");
        $(".err_item.auth_fail").show();
        // 인증번호 입력 필드 비활성화
        $("#authCodeInput").prop("disabled", true);
      }
    }, 1000);
  }

  function stopTimer() {
    if (authTimer) {
      clearInterval(authTimer);
      authTimer = null;
    }
  }


  // 인증요청 버튼 클릭
  $(".authBtn").on("click", function () {
    const phoneNum = $("#phoneNum").val().trim();
    
    // 휴대전화번호 검증
    if (phoneNum === "") {
      $(".form_item.phone").addClass("errBorder");
      $(".err_item.phone").show();
      return;
    }
    
    // 기존 타이머 정지
    stopTimer();
    
    // 인증번호 입력 필드 표시 & 활성화
    $("#authCode").show();
    $("#authCodeInput").prop("disabled", false).val("");
    
    // 타이머 시작
    startTimer();
    
    // 버튼 변경 (인증요청 → 재전송)
    $(this).text("재전송");
    
    // 가입하기 버튼은 인증 완료 후 표시 (일단 숨김 유지)
    // $("#form_authBtn").hide();
    // $("#form_joinBtn").show();
  });

  // 인증번호 입력 완료 시 (6자리 입력되면)
  $("#authCodeInput").on("input", function() {
    const code = $(this).val().trim();
    
    if (code.length === 6) {
      // 여기서 실제로는 서버 검증 필요
      // 데모용으로 인증 성공 처리
      stopTimer();
      $("#authTimer").text("인증완료").addClass("complete");
      $(this).prop("disabled", true);
      
      // 가입하기 버튼 표시
      $("#form_authBtn").hide();
      $("#form_joinBtn").show();
    }
  });


  /* ========================================
     입력 필드 유효성 검사
     ======================================== */
  $(".form_item input").on("blur", function () {
    const $item = $(this).parent();

    // 이메일은 선택사항이므로 제외
    if ($item.hasClass("email")) return;
    // 인증번호도 별도 처리
    if ($item.hasClass("auth")) return;

    if ($(this).val().trim() === "") {
      $item.addClass("errBorder");

      if ($item.hasClass("id")) $(".err_item.id").show();
      else if ($item.hasClass("pw")) $(".err_item.pw").show();
      else if ($item.hasClass("name")) $(".err_item.name").show();
      else if ($item.hasClass("birth")) $(".err_item.birth").show();
      else if ($item.hasClass("phone")) $(".err_item.phone").show();
    }
  });

  $(".form_item input").on("focus", function () {
    const $item = $(this).parent();

    $item.removeClass("errBorder");

    if ($item.hasClass("id")) $(".err_item.id").hide();
    else if ($item.hasClass("pw")) $(".err_item.pw").hide();
    else if ($item.hasClass("name")) $(".err_item.name").hide();
    else if ($item.hasClass("birth")) $(".err_item.birth").hide();
    else if ($item.hasClass("phone")) {
      $(".err_item.phone").hide();
      $(".err_item.auth_fail").hide();
    }
  });
  /* 생년월일 포맷팅 */
  const birthInput = $('#birth');
  birthInput.on("blur", function () { 
    let digits = $(this).val().replace(/\D/g, "");
    if (/^\d{8}$/.test(digits)) {
      $(this).val(digits.replace(/(\d{4})(\d{2})(\d{2})/, "$1-$2-$3")); 
    }
  })
	/* 휴대전화 포맷팅 추가 */
	  const phoneInput = $("#phoneNum"); 
	  const phoneDiv = $(".form_item.phone"); 
	  const regex = /^(010|011|016|017|018|019)-[0-9]{3,4}-[0-9]{4}$/;
	
	  // blur 시 포맷팅
	  phoneInput.on("blur", function () { let digits = $(this).val().replace(/\D/g, "");
	  if (/^(010|011|016|017|018|019)\d{7,8}$/.test(digits)) { 
	    $(this).val(digits.replace(/(\d{3})(\d{3,4})(\d{4})/, "$1-$2-$3")); }
	  });

  /* ========================================
     폼 제출
     ======================================== */
  $("#join_form").on("submit", function(e) {
    e.preventDefault();
    
    // 필수 항목 검증
    let isValid = true;
    
    if ($("#id").val().trim() === "") {
      $(".form_item.id").addClass("errBorder");
      $(".err_item.id").show();
      isValid = false;
    }
    
    if ($("#pw").val().trim() === "") {
      $(".form_item.pw").addClass("errBorder");
      $(".err_item.pw").show();
      isValid = false;
    }
    
    if ($("#name").val().trim() === "") {
      $(".form_item.name").addClass("errBorder");
      $(".err_item.name").show();
      isValid = false;
    }
    
    if ($("#birth").val().trim() === "") {
      $(".form_item.birth").addClass("errBorder");
      $(".err_item.birth").show();
      isValid = false;
    }
    // 휴대전화 검증 추가
    if (!regex.test(phoneInput.val())) { 
        phoneDiv.addClass("errBorder");
        isValid = false;
    }

    if (!isValid) return;
    
    // 여기서 실제 가입 처리
    this.submit();
  });

  // 페이지 로드 시 초기 상태 설정
  $("#authTimer").hide();
  $("#form_joinBtn").hide();
  $("#authCode").hide(); // 인증번호 입력란 숨김
  $(".term_list").hide(); // 약관 리스트 초기 숨김
  $(".term_title button").addClass("down"); // 약관 화살표 초기 down 상태
  $(".tel_itemDiv").hide(); // 통신사 리스트 초기 숨김
  $("#telecomArrow").addClass("down"); // 통신사 화살표 초기 down 상태
});