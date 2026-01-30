package com.shinhanez.controller;

import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
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
    
    /*// 구글 로그인 처리
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
    }*/

    // 회원가입 페이지
    @GetMapping("/join")
    public String joinForm() {
        return "member/join";
    }

    // 회원가입 처리
    @PostMapping("/join")
    public String join(ShezUser user, Model model) {
        // 현재 인증 정보 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        boolean isOAuthUser = false;
        
        // OAuth 사용자인지 확인
        if (auth != null && auth.isAuthenticated()) {
            isOAuthUser = auth.getAuthorities().stream()
                    .map(GrantedAuthority::getAuthority)
                    .anyMatch(role -> role.equals("ROLE_OAUTH"));
        }
        // ID 중복 체크
        if (!isOAuthUser && userService.isDuplicateId(user.getId())) {
            model.addAttribute("error", "이미 사용중인 아이디입니다.");
            return "member/join";
        }
        // 비밀번호 암호화
        if (user.getPw() != null && !user.getPw().isEmpty()) {
            String encodedPw = passwordEncoder.encode(user.getPw());
            user.setPw(encodedPw);
        }

        int result = userService.join(user);
        
        if (result > 0) {
            // OAuth 사용자의 경우
            if (isOAuthUser) {
                // ROLE_USER 권한으로 업데이트
                OAuth2User oauth2User = (OAuth2User) auth.getPrincipal();
                
                DefaultOAuth2User newOAuth2User = new DefaultOAuth2User(
                    Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER")),
                    oauth2User.getAttributes(),
                    "sub"
                );
                
                Authentication newAuth = new UsernamePasswordAuthenticationToken(
                    newOAuth2User,
                    auth.getCredentials(),
                    Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"))
                );
                
                SecurityContextHolder.getContext().setAuthentication(newAuth);
                
                return "redirect:/";
            } else {
                // 일반 회원가입은 로그인 페이지로
                return "redirect:/member/login?join=success";
            }
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
