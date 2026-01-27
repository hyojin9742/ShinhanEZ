package com.shinhanez.admin.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.domain.Board;
import com.shinhanez.admin.service.BoardService;

@Controller
@RequestMapping("/admin/notice")
public class BoardController {

    @Autowired
    private BoardService boardService;

    // 목록 페이지
    @GetMapping("/list")
    public String listPage() {
        return "admin/notice_list";
    }

    // 목록 데이터 (AJAX)
    @GetMapping("/api/list")
    @ResponseBody
    public Map<String, Object> getNoticeList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "") String keyword) {
        return boardService.getBoardList(pageNum, keyword);
    }

    // 상세보기
    @GetMapping("/view")
    public String view(@RequestParam Long idx, Model model) {
        Board board = boardService.getBoard(idx);
        model.addAttribute("board", board);
        return "admin/notice_view";
    }

    // 등록 페이지
    @GetMapping("/write")
    public String writePage() {
        return "admin/notice_write";
    }

    // 등록 처리
    @PostMapping("/write")
    public String write(Board board, HttpSession session) {
        // 관리자 ID 설정
        String adminId = (String) session.getAttribute("adminId");
        if (adminId == null) {
            adminId = "admin";
        }
        board.setId(adminId);
        boardService.addBoard(board);
        return "redirect:/admin/notice/list";
    }

    // 수정 페이지
    @GetMapping("/edit")
    public String editPage(@RequestParam Long idx, Model model) {
        Board board = boardService.getBoard(idx);
        model.addAttribute("board", board);
        return "admin/notice_edit";
    }

    // 수정 처리
    @PostMapping("/edit")
    public String edit(Board board) {
        boardService.editBoard(board);
        return "redirect:/admin/notice/list";
    }

    // 삭제 처리
    @PostMapping("/delete")
    public String delete(@RequestParam Long idx) {
        boardService.deleteBoard(idx);
        return "redirect:/admin/notice/list";
    }
}
