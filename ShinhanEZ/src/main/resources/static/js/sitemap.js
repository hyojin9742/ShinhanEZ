$(function () {
  $("div.sitemapHead").on(
    "click",
    "#btn_menu_search, .btn-clear",
    function (e) {
      goSearch();
    }
  );
  $("#menu_search").on("keyup", function (key) {
    if (key.keyCode == 13) {
      goSearch();
    }
  });
});

function goSearch() {
  var search = $("#menu_search").val();
  if (search?.trim() != "") {
    $("div.sitemapBody span:contains('" + search + "')").each(function () {
      var regex = new RegExp(search, "gi");
      if ($(this).children().length) {
        let $child = $(this).children().not(".primary").detach();
        $(this).html(
          $(this)
            .text()
            .replace(regex, "<span class='primary'>" + search + "</span>")
        );
        $(this).append($child);
      } else {
        $(this).html(
          $(this)
            .text()
            .replace(regex, "<span class='primary'>" + search + "</span>")
        );
      }
    });
    $(".sitemapBody").find(".noData").hide();
    $("div.sitemapBody li").hide();
    var temp = $("div.sitemapBody li:contains('" + search + "')");
    temp?.length ? $(temp).show() : $(".sitemapBody").find(".noData").show();
  }
}

function icoBtnClose2() {
  var search = $("#menu_search").val();
  $("div.sitemapBody span:contains('" + search + "')").each(function () {
    var regex = new RegExp(search, "gi");
    if ($(this).children().length) {
      let $child = $(this).children().not(".primary").detach();
      $(this).html($(this).text().replace(regex, search));
      $(this).append($child);
    } else {
      $(this).html($(this).text().replace(regex, search));
    }
  });
  $("div.sitemapBody li").show();
  $("#menu_search").val("");
  $("#wrap").show();
  $("#sitemap").hide().find(".noData").hide();
}
