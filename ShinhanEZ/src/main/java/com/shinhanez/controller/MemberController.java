package com.shinhanez.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.domain.ShezUser;
import com.shinhanez.service.ShezUserService;

/**
 * 회원 컨트롤러 (로그인/회원가입/로그아웃)
 */
@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private ShezUserService userService;

    // 로그인 페이지
    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
    }

    // 로그인 처리
    @PostMapping("/login")
    public String login(@RequestParam String id, 
                        @RequestParam String pw,
                        HttpSession session,
                        Model model) {
        ShezUser user = userService.login(id, pw);
        
        if (user != null) {
            // 로그인 성공 - 세션에 저장
            session.setAttribute("loginUser", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());
            
            // 로그인 성공 → 메인 페이지로 (관리자든 일반유저든)
            return "redirect:/";
        } else {
            // 로그인 실패
            model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "member/login";
        }
    }

    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // 회원가입 페이지
    @GetMapping("/join")
    public String joinForm() {
        return "member/join";
    }

    // 회원가입 처리
    @PostMapping("/join")
    public String join(ShezUser user, Model model) {
        // ID 중복 체크
        if (userService.isDuplicateId(user.getId())) {
            model.addAttribute("error", "이미 사용중인 아이디입니다.");
            return "member/join";
        }
        
        int result = userService.join(user);
        if (result > 0) {
            return "redirect:/member/login?join=success";
        } else {
            model.addAttribute("error", "회원가입에 실패했습니다.");
            return "member/join";
        }
    }

    // ID 중복 체크 (Ajax)
    @GetMapping("/checkId")
    @ResponseBody
    public String checkId(@RequestParam String id) {
        boolean isDuplicate = userService.isDuplicateId(id);
        return isDuplicate ? "duplicate" : "available";
    }
}
