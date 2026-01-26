package com.shinhanez.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.shinhanez.admin.domain.Board;
import com.shinhanez.admin.service.BoardService;
import com.shinhanez.domain.ShezUser;

/**
 * 일반 사용자용 게시판 컨트롤러 (미디어룸)
 */
@Controller("publicBoardController")
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private BoardService boardService;

    // 목록 (로그인 없이 조회 가능)
    @GetMapping("/list")
    public String list(Model model) {
        List<Board> boardList = boardService.findAll();
        model.addAttribute("boardList", boardList);
        model.addAttribute("totalCount", boardService.count());
        return "pages/media_room";
    }

    // 상세 (로그인 없이 조회 가능)
    @GetMapping("/view/{idx}")
    public String view(@PathVariable Long idx, HttpSession session, Model model) {
        Board board = boardService.findByIdWithCnt(idx);
        model.addAttribute("board", board);

        // 로그인 사용자 정보 (수정/삭제 버튼 표시용)
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        if (user != null) {
            model.addAttribute("loginUser", user);
            // 본인 글이거나 관리자면 수정/삭제 가능
            boolean canModify = user.getId().equals(board.getId()) || "ROLE_ADMIN".equals(user.getRole());
            model.addAttribute("canModify", canModify);
        }
        return "pages/media_view";
    }

    // 글쓰기 폼 (로그인 필요)
    @GetMapping("/write")
    public String writeForm(HttpSession session, Model model) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/member/login?error=auth";
        }
        model.addAttribute("mode", "write");
        model.addAttribute("id", user.getId());
        return "pages/media_write";
    }

    // 글쓰기 처리
    @PostMapping("/write")
    public String write(Board board, HttpSession session, RedirectAttributes rttr) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/member/login?error=auth";
        }
        board.setId(user.getId());
        boardService.insert(board);
        rttr.addFlashAttribute("message", "게시글이 등록되었습니다.");
        return "redirect:/board/list";
    }

    // 수정 폼
    @GetMapping("/edit/{idx}")
    public String editForm(@PathVariable Long idx, HttpSession session, Model model) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/member/login?error=auth";
        }
        Board board = boardService.findById(idx);

        // 본인 글이 아니고 관리자도 아니면 접근 거부
        if (!user.getId().equals(board.getId()) && !"ROLE_ADMIN".equals(user.getRole())) {
            return "redirect:/board/list?error=permission";
        }

        model.addAttribute("mode", "edit");
        model.addAttribute("bdto", board);
        model.addAttribute("id", user.getId());
        return "pages/media_write";
    }

    // 수정 처리
    @PostMapping("/edit/{idx}")
    public String edit(@PathVariable Long idx, Board board, HttpSession session, RedirectAttributes rttr) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/member/login?error=auth";
        }

        // 본인 글이 아니고 관리자도 아니면 수정 거부
        Board existingBoard = boardService.findById(idx);
        if (!user.getId().equals(existingBoard.getId()) && !"ROLE_ADMIN".equals(user.getRole())) {
            return "redirect:/board/list?error=permission";
        }

        board.setIdx(idx);
        boardService.update(board);
        rttr.addFlashAttribute("message", "게시글이 수정되었습니다.");
        return "redirect:/board/view/" + idx;
    }

    // 삭제
    @GetMapping("/delete/{idx}")
    public String delete(@PathVariable Long idx, HttpSession session, RedirectAttributes rttr) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/member/login?error=auth";
        }

        // 본인 글이 아니고 관리자도 아니면 삭제 거부
        Board board = boardService.findById(idx);
        if (!user.getId().equals(board.getId()) && !"ROLE_ADMIN".equals(user.getRole())) {
            return "redirect:/board/list?error=permission";
        }

        boardService.delete(idx);
        rttr.addFlashAttribute("message", "게시글이 삭제되었습니다.");
        return "redirect:/board/list";
    }
}
