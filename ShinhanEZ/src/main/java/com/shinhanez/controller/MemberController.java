package com.shinhanez.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.service.AdminService;
import com.shinhanez.domain.ShezUser;
import com.shinhanez.service.ShezUserService;

/**
 * 회원 컨트롤러 (로그인/회원가입/로그아웃)
 */
@Controller
@RequestMapping("/member")
public class MemberController {

    private final PasswordEncoder passwordEncoder;
    private ShezUserService userService;
    private AdminService adminService;
    
    @Autowired
    public MemberController(ShezUserService userService, AdminService adminService, PasswordEncoder passwordEncoder) {
    	this.userService = userService;
    	this.adminService = adminService;
    	this.passwordEncoder = passwordEncoder;
    }
    
    /* 비밀번호 암호화 처리 임시 메서드 */
    public void migratePassword() {
        List<ShezUser> userList = userService.findAll();

        for (ShezUser user : userList) {
            String plainPw = user.getPw();

            // 이미 암호화된 건 건너뜀
            if (plainPw.startsWith("$2a$") || plainPw.startsWith("$2b$")) {
                continue;
            }

            String encodedPw = passwordEncoder.encode(plainPw);
            userService.updatePassword(user.getId(), encodedPw);
        }
    }
    // 로그인 페이지
    @GetMapping("/login")
    public String loginForm() {
    	migratePassword();
    	adminService.encodeAdmins();
        return "member/login";
    }
    
    // 구글 로그인 처리
    @PostMapping("/googlelogin")
    public String googlelogin(@RequestParam String email, 
                        @RequestParam String providerId,
                        HttpSession session,
                        Model model) {
        ShezUser user = userService.findByEmail(email);
        Admins admin = adminService.readOneAdminById(email);
        if (user != null) {
            // 로그인 성공 - 세션에 저장
        	session.setAttribute("loginUser", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());
            if(admin != null ) {
            	adminService.lastLogin(admin.getAdminIdx());
            	session.setAttribute("adminIdx", admin.getAdminIdx());
            	session.setAttribute("adminName", admin.getAdminName());
            	session.setAttribute("adminRole", admin.getAdminRole());            	
            }
            // 로그인 성공 → 메인 페이지로 (관리자든 일반유저든)
            return "redirect:/";
        } else {
            // 로그인 실패
            model.addAttribute("error", "로그인 실패");
            return "member/login";
        }
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
        // 비밀번호 암호화
        String encodedPw = passwordEncoder.encode(user.getPw());
        user.setPw(encodedPw);

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
