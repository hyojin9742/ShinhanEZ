package com.shinhanez.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.shinhanez.admin.domain.Board;
import com.shinhanez.admin.service.BoardService;
import com.shinhanez.domain.ShezUser;
import com.shinhanez.domain.UserAdminDetails;

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
    public String list(@RequestParam(defaultValue = "1") int pageNum,
                       @RequestParam(required = false) String keyword,
                       Model model) {
        Map<String, Object> result = boardService.getBoardList(pageNum, keyword);
        model.addAttribute("boardList", result.get("list"));
        model.addAttribute("paging", result.get("paging"));
        model.addAttribute("keyword", keyword);
        return "pages/media_room";
    }

    // 상세 (로그인 없이 조회 가능)
    @GetMapping("/view/{idx}")
    public String view(@PathVariable Long idx, @AuthenticationPrincipal UserAdminDetails details, HttpSession session, Model model) {
        Board board = boardService.getBoardWithCnt(idx);
        model.addAttribute("board", board);

        // 로그인 사용자 정보 (수정/삭제 버튼 표시용)
        ShezUser user = null;
        if(details != null) {
        	user = details.getUser();
        }
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
    public String writeForm(HttpSession session, Authentication authentication, Model model) {
        ShezUser user = null;
        if (authentication != null) {
        	Object principal = authentication.getPrincipal(); 
        	
        	if (principal instanceof UserAdminDetails) { 
        		// 폼 로그인 사용자 
        		user = ((UserAdminDetails) principal).getUser(); 
        		
    		} else if (principal instanceof OAuth2User) { 
    			// OAuth2 로그인 사용자 
    			OAuth2User oauth2User = (OAuth2User) principal;
    			String email = oauth2User.getAttribute("email");
    			user = new ShezUser();
    			user.setId(email);
			} 
    	}
        if (user == null) {
            return "redirect:/member/login?error=needLogin";
        }
        model.addAttribute("mode", "write");
        model.addAttribute("id", user.getId());
        return "pages/media_write";
    }

    // 글쓰기 처리
    @PostMapping("/write")
    public String write(Board board, HttpSession session, Authentication authentication, RedirectAttributes rttr) {
        ShezUser user = null;
        if (authentication != null) {
        	Object principal = authentication.getPrincipal(); 
        	
        	if (principal instanceof UserAdminDetails) { 
        		// 폼 로그인 사용자 
        		user = ((UserAdminDetails) principal).getUser(); 
        		
    		} else if (principal instanceof OAuth2User) { 
    			// OAuth2 로그인 사용자 
    			OAuth2User oauth2User = (OAuth2User) principal;
    			String email = oauth2User.getAttribute("email");
    			user = new ShezUser();
    			user.setId(email);
			} 
    	}
        board.setId(user.getId());
        boardService.addBoard(board);
        rttr.addFlashAttribute("message", "게시글이 등록되었습니다.");
        return "redirect:/board/list";
    }

    // 수정 폼
    @GetMapping("/edit/{idx}")
    public String editForm(@PathVariable Long idx, HttpSession session,@AuthenticationPrincipal UserAdminDetails details, Model model) {
        ShezUser user = null;
        if(details != null) {
        	user = details.getUser();
        }
        if (user == null) {
            return "redirect:/member/login?error=needLogin";
        }
        Board board = boardService.getBoard(idx);

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
    public String edit(@PathVariable Long idx, Board board, HttpSession session, @AuthenticationPrincipal UserAdminDetails details, RedirectAttributes rttr) {
        ShezUser user = null;
        if(details != null) {
        	user = details.getUser();
        }

        // 본인 글이 아니고 관리자도 아니면 수정 거부
        Board existingBoard = boardService.getBoard(idx);
        if (!user.getId().equals(existingBoard.getId()) && !"ROLE_ADMIN".equals(user.getRole())) {
            return "redirect:/board/list?error=permission";
        }

        board.setIdx(idx);
        boardService.editBoard(board);
        rttr.addFlashAttribute("message", "게시글이 수정되었습니다.");
        return "redirect:/board/view/" + idx;
    }

    // 삭제
    @GetMapping("/delete/{idx}")
    public String delete(@PathVariable Long idx, HttpSession session, @AuthenticationPrincipal UserAdminDetails details, RedirectAttributes rttr) {
        ShezUser user = null;
        if(details != null) {
        	user = details.getUser();
        }

        // 본인 글이 아니고 관리자도 아니면 삭제 거부
        Board board = boardService.getBoard(idx);
        if (!user.getId().equals(board.getId()) && !"ROLE_ADMIN".equals(user.getRole())) {
            return "redirect:/board/list?error=permission";
        }

        boardService.deleteBoard(idx);
        rttr.addFlashAttribute("message", "게시글이 삭제되었습니다.");
        return "redirect:/board/list";
    }
}
