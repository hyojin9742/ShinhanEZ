$(function () {
    $(document).ready(function () {
      gnb_each_on();
    });

    var dep1;
    var dep2;
    var $gnb = $(".header #gnb");
    var $gnbBg = $(".gnbBg");
    var $gnbList = $(".header #gnb > ul");
    var $gnb_dep1 = $(".header #gnb > ul > li");
    var $gnb_dep2 = $(".header #gnb > ul > li .subArea");

    function gnb_each_on() {
      $gnbList.children("li").children("a").on("mouseenter focus", function () {
        if ($(this).parent('li').find('li').length == 0) {
          gnb_return();
          return false;
        }
        $(".header").addClass("over");
        $("#gnbBg").addClass("open");
        $gnbList.children("li").removeClass("on").children(".subArea").removeClass("show");
        $(this).parent("li").addClass("on").children(".subArea").addClass("show");
        $gnbBg.stop().fadeIn();
      })

      $gnbList.on("mouseleave", gnb_return);
      $gnbList.find("a").last().on("focusout", gnb_return);

      function gnb_return() {
        $(".header").removeClass("over");
        $("#gnbBg").removeClass("open");
        $gnbList.children("li").removeClass("on").children(".subArea").removeClass("show");
        $gnbBg.stop().hide();
        if (dep1 > 0 && dep2) {
          $gnbList.children("li").eq(dep1 - 1).addClass("active");
        }
      }
    }

    $gnb_dep2.hover(function () {
      $(this).parent("li").addClass("on");
    }, function () {
      $gnb_dep1.removeClass("on");
    });

    if (dep1 > 0 && dep2 > 0) {
      $gnbList.children("li").eq(dep1 - 1).addClass("active");
    }
  });