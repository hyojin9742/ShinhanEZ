package com.shinhanez.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.shinhanez.admin.domain.Board;
import com.shinhanez.admin.service.BoardService;

/**
 * 메인 페이지 컨트롤러
 */
@Controller
public class HomeController {

    @Autowired
    private BoardService boardService;

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
    @GetMapping("/pages/insurance_claim")
    public String insuranceClaim() {
        return "pages/insurance_claim";
    }

    // 소셜 페이지
    @GetMapping("/pages/social")
    public String social() {
        return "pages/social";
    }

    // 미디어룸 페이지 (읽기 전용)
    @GetMapping({"/pages/media_room", "/board/list"})
    public String mediaRoom(@RequestParam(defaultValue = "1") int pageNum, Model model) {
        Map<String, Object> result = boardService.getBoardList(pageNum, "");
        model.addAttribute("list", result.get("list"));
        model.addAttribute("paging", result.get("paging"));
        return "pages/media_room";
    }

    // 미디어 상세보기 (읽기 전용)
    @GetMapping("/board/view")
    public String mediaView(@RequestParam Long idx, Model model) {
        Board board = boardService.getBoardWithCnt(idx);
        model.addAttribute("board", board);
        return "pages/media_view";
    }
}
