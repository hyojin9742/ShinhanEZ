package com.shinhanez.admin.controller;

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

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.domain.Board;
import com.shinhanez.admin.service.BoardService;
import com.shinhanez.domain.ShezUser;

/**
 * 관리자용 게시판(미디어룸) 컨트롤러
 */
@Controller
@RequestMapping("/admin/board")
public class BoardController {

    @Autowired
    private BoardService boardService;

    // 관리자 권한 체크
    private boolean isAdmin(HttpSession session) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        return user != null && "ROLE_ADMIN".equals(user.getRole());
    }

    // 권한별 수정/삭제 가능 여부 체크
    private boolean canModify(HttpSession session) {
        Admins admin = (Admins) session.getAttribute("adminInfo");
        if (admin == null) return false;
        String role = admin.getAdminRole();
        return "super".equals(role) || "manager".equals(role);
    }

    // 목록
    @GetMapping("/list")
    public String list(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        List<Board> boardList = boardService.findAll();
        model.addAttribute("boardList", boardList);
        model.addAttribute("totalCount", boardService.count());

        // 권한 정보 전달
        Admins admin = (Admins) session.getAttribute("adminInfo");
        if (admin != null) {
            model.addAttribute("canModify", canModify(session));
        }
        return "admin/board_list";
    }

    // 상세
    @GetMapping("/view/{idx}")
    public String view(@PathVariable Long idx, HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        Board board = boardService.findByIdWithCnt(idx);
        model.addAttribute("board", board);
        model.addAttribute("canModify", canModify(session));
        return "admin/board_view";
    }

    // 등록 폼
    @GetMapping("/register")
    public String registerForm(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        if (!canModify(session)) {
            return "redirect:/admin/board/list?error=permission";
        }
        return "admin/board_register";
    }

    // 등록 처리
    @PostMapping("/register")
    public String register(Board board, HttpSession session, RedirectAttributes rttr) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        if (!canModify(session)) {
            return "redirect:/admin/board/list?error=permission";
        }
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        board.setId(user.getId());
        boardService.insert(board);
        rttr.addFlashAttribute("message", "게시글이 등록되었습니다.");
        return "redirect:/admin/board/list";
    }

    // 수정 폼
    @GetMapping("/edit/{idx}")
    public String editForm(@PathVariable Long idx, HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        if (!canModify(session)) {
            return "redirect:/admin/board/list?error=permission";
        }
        Board board = boardService.findById(idx);
        model.addAttribute("board", board);
        return "admin/board_edit";
    }

    // 수정 처리
    @PostMapping("/edit/{idx}")
    public String edit(@PathVariable Long idx, Board board, HttpSession session, RedirectAttributes rttr) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        if (!canModify(session)) {
            return "redirect:/admin/board/list?error=permission";
        }
        board.setIdx(idx);
        boardService.update(board);
        rttr.addFlashAttribute("message", "게시글이 수정되었습니다.");
        return "redirect:/admin/board/view/" + idx;
    }

    // 삭제
    @GetMapping("/delete/{idx}")
    public String delete(@PathVariable Long idx, HttpSession session, RedirectAttributes rttr) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        if (!canModify(session)) {
            return "redirect:/admin/board/list?error=permission";
        }
        boardService.delete(idx);
        rttr.addFlashAttribute("message", "게시글이 삭제되었습니다.");
        return "redirect:/admin/board/list";
    }
}
