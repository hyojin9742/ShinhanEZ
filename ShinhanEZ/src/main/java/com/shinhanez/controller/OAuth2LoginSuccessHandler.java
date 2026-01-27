package com.shinhanez.controller;



import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.service.AdminService;
import com.shinhanez.domain.ShezUser;
import com.shinhanez.mapper.ShezUserMapper;
import com.shinhanez.service.ShezUserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class OAuth2LoginSuccessHandler implements AuthenticationSuccessHandler {
	
	
    private final ShezUserService shezuserservice;
    private final AdminService adminservice;
    
    
    

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        
        // 1. 로그인된 유저 정보 가져오기 (Service에서 리턴한 값)
        OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();
        String email = oauth2User.getAttribute("email");
        String name = oauth2User.getAttribute("name");
        String provider = oauth2User.getAttribute("sub"); // 구글 ID

        // 2. DB 조회 (이미 가입된 사람인지 확인)
        ShezUser existUser = shezuserservice.findByEmail(email);
        
        HttpSession session = request.getSession();
        if (existUser == null) {
            // --- [신규 회원 로직] ---
            System.out.println("신규 회원입니다. 회원가입 페이지로 이동합니다.");            
            
            System.out.println("신규 회원입니다. 회원가입 페이지로 보냅니다.");            
            
            // request 대신 session에 담아야 리다이렉트 후에도 살아있습니다.
            session.setAttribute("googleEmail", email);
            session.setAttribute("googleName", name);
            session.setAttribute("googleProviderId", provider);
            
            // JSP 파일 경로가 아니라, '컨트롤러 주소'로 보내야 합니다.
            response.sendRedirect("/member/join");

            
        } else {
        	// --- [기존 회원] ---
            System.out.println("기존 회원입니다. 바로 로그인 처리합니다.");
        	
            
            session.setAttribute("email", email);
            session.setAttribute("provider", provider);
            
            ShezUser user = shezuserservice.findByEmail(email);
            Admins admin = adminservice.readOneAdminById(email);
            if (user != null) {
                // 로그인 성공 - 세션에 저장
            	session.setAttribute("loginUser", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getName());
                session.setAttribute("userRole", user.getRole());
                if(admin != null ) {
                	adminservice.lastLogin(admin.getAdminIdx());
                	session.setAttribute("adminIdx", admin.getAdminIdx());
                	session.setAttribute("adminName", admin.getAdminName());
                	session.setAttribute("adminRole", admin.getAdminRole());            	
                }
                // 로그인 성공 → 메인 페이지로 (관리자든 일반유저든)
                response.sendRedirect("/");
            } else {
                // 로그인 실패
                session.setAttribute("error", "로그인 실패");
                response.sendRedirect("/member/join");
            }
        	
        }
    }
}
