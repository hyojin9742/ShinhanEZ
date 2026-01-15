if (typeof Splitting !== "undefined") {
  Splitting();
}

if (typeof commUiResultAnimation !== "undefined") {
  commUiResultAnimation.set();
  commUiResultAnimation.loading();
}
$(document).ready(function () {
	/* 링크 기본 이벤트 막기 */
	$("a[href='#']").on("click",function(e){
	  e.preventDefault();
	});
  // 스크롤 애니메이션 - cssAnimate 클래스 처리
  function checkAnimation() {
    var scrollTop = $(window).scrollTop();
    var windowHeight = $(window).height();

    $(".cssAnimate").each(function (index) {
      var $this = $(this);
      var elementTop = $this.offset().top;
      var elementHeight = $this.outerHeight();
      var elementBottom = elementTop + elementHeight;

      // 뷰포트 범위
      var viewportTop = scrollTop;
      var viewportBottom = scrollTop + windowHeight;

      // 요소가 뷰포트 안에 있는지 체크 (일부라도 보이면)
      var isInViewport = (elementTop < viewportBottom - 100) && (elementBottom > viewportTop + 100);

      if (isInViewport) {
        // 뷰포트 안에 들어오면 active 추가 (순차 딜레이)
        if (!$this.hasClass("active") && !$this.hasClass("animating")) {
          $this.addClass("animating");
          setTimeout(function() {
            $this.addClass("active").removeClass("animating");
          }, index * 100); // 각 요소마다 100ms 딜레이
        }
      } else {
        // 뷰포트 밖으로 나가면 active 제거 (다시 들어오면 애니메이션 재실행)
        if ($this.hasClass("active")) {
          $this.removeClass("active");
        }
      }
    });
  }

  // 페이지 로드 후 약간 딜레이 주고 체크 (CSS가 먼저 적용되도록)
  setTimeout(function() {
    checkAnimation();
  }, 100);

  // 스크롤 시 체크
  $(window).on("scroll", function () {
    checkAnimation();
  });
});

$(function () {
  var cookiedata = document.cookie || "";

  if (cookiedata.indexOf("mainPopup=ok") < 0) {
    getPopup();
  }

  async function getPopup() {
    if (window.commUtil && typeof commUtil.getPopupCnt === "function") {
      await commUtil.getPopupCnt();
    }
  }

  // 이미지 패럴랙스 애니메이션
  let lastScroll = 0;
  $(window).scroll(function () {
    let nowScroll = $(this).scrollTop();

    let $img1 = $("#imgAni1");
    let $img2 = $("#imgAni2");

    if ($img1.length) {
      let offTop1 = $img1.offset().top;
      let width1 = (nowScroll - offTop1) / 100 + 10;
      if (width1 > 1 && width1 < 11) {
        $img1.children("div").width((9 - width1) * 2 + "%");
      }
    }

    if ($img2.length) {
      let offTop2 = $img2.offset().top;
      let width2 = (nowScroll - offTop2) / 100 + 10;
      if (width2 > 1 && width2 < 11) {
        $img2.children("div").width((9 - width2) * 2 + "%");
      }
    }

    lastScroll = nowScroll;
  });

  // Swiper 슬라이더
  if (typeof Swiper !== "undefined") {
    const directInfoSwiper = new Swiper(".direct-info .swiper-container", {
      speed: 500,
      slidesPerView: "auto",
      spaceBetween: 60,
      loop: true,
      loopAdditionalSlides: 1,
      loopedSlides: 1,
      autoplay: {
        delay: 3000,
        disableOnInteraction: true,
        pauseOnMouseEnter: true,
      },
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
      breakpoints: {
        360: { slidesPerView: 2.5, spaceBetween: 4 },
        768: { slidesPerView: 4.5, spaceBetween: 30 },
        1200: { slidesPerView: 5, spaceBetween: 60 },
      },
    });

    const productBannerSwiper = new Swiper(".product-banner > .swiper", {
      speed: 1000,
      spaceBetween: 0,
      slidesPerView: 1,
      loop: true,
      loopAdditionalSlides: 1,
      loopedSlides: 1,
      autoplay: {
        delay: 6000,
        disableOnInteraction: true,
        pauseOnMouseEnter: true,
      },
      pagination: {
        el: ".swiper-pagination",
        type: "fraction",
      },
      a11y: {
        slideLabelMessage:
          "총 {{slidesLength}}장의 슬라이드 중 {{index}}번 슬라이드",
      },
    });

    const productBannerControl = document.querySelector(
      "#productBannerControl"
    );
    if (productBannerControl) {
      productBannerControl.addEventListener("click", function () {
        if (this.classList.contains("is-stop")) {
          this.classList.remove("is-stop");
          this.querySelector(".sr-only").innerHTML = "자동재생 멈추기";
          productBannerSwiper.autoplay.start();
        } else {
          this.classList.add("is-stop");
          this.querySelector(".sr-only").innerHTML = "자동재생 시작하기";
          productBannerSwiper.autoplay.stop();
        }
      });
    }

    (function () {
      const elements = document.querySelectorAll(
        ".product-banner .product-banner-item-cont > a"
      );

      elements.forEach((_this) => {
        _this.addEventListener("click", (e) => {
          let linkURL;

          if (
            window.commUtil &&
            typeof commUtil.isMobile === "function" &&
            commUtil.isMobile()
          ) {
            linkURL = _this.dataset.urlMobile;
          } else {
            linkURL = _this.dataset.urlPc;
          }

          const isLink = !!linkURL;

          if (isLink) {
            e.preventDefault();
            linkURL = linkURL || _this.getAttribute("href");

            if (linkURL === "qrCode") {
              if (
                typeof commView !== "undefined" &&
                typeof commView.goQrLk === "function"
              ) {
                commView.goQrLk(_this.dataset.qrCode);
              }
            } else {
              window.open(linkURL);
            }
          } else {
            return false;
          }
        });
      });
    })();
  }
});