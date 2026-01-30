package com.shinhanez.config;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import lombok.RequiredArgsConstructor;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import com.shinhanez.domain.PrincipalOAuth2UserDetails;

import java.io.IOException;


@RequiredArgsConstructor
public class OAuth2LoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
    	
    	PrincipalOAuth2UserDetails oAuth = (PrincipalOAuth2UserDetails) authentication.getPrincipal();
    	HttpSession session = request.getSession();
    	
    	session.setAttribute("userId", oAuth.getEmail());
    	
        super.onAuthenticationSuccess(request, response, authentication);    	   
   	
    }
}
