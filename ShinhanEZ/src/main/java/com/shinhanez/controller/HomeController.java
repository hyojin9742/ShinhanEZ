package com.shinhanez.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 메인 페이지 컨트롤러
 */
@Controller
public class HomeController {

    // 메인 페이지
    @GetMapping("/")
    public String index() {
        return "index";
    }

    // 브랜드 페이지
    @GetMapping("/pages/brand")
    public String brand() {
        return "pages/brand";
    }

    // 여행 컨텐츠 페이지
    @GetMapping("/pages/contents_travel")
    public String contentsTravel() {
        return "pages/contents_travel";
    }

    // 보험금 청구 페이지
    @GetMapping("/pages/user_claim")
    public String insuranceClaim() {
        return "pages/user_claim";
    }

    // 소셜 페이지
    @GetMapping("/pages/social")
    public String social() {
        return "pages/social";
    }

    // 미디어룸 페이지 (레거시 경로 - BoardController로 리다이렉트)
    @GetMapping("/pages/media_room")
    public String mediaRoom() {
        return "redirect:/board/list";
    }
}
