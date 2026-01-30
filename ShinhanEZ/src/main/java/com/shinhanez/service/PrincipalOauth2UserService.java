package com.shinhanez.service;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.shinhanez.domain.PrincipalOAuth2UserDetails;
import com.shinhanez.domain.ShezUser;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PrincipalOauth2UserService extends DefaultOAuth2UserService {
    
	private final ShezUserService shezUserService;
	
    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        // 1. 구글에서 유저 정보 가져오기
        OAuth2User oauth2User = super.loadUser(userRequest);
        
        // 이메일로 DB 조회
        String email = oauth2User.getAttribute("email");
        ShezUser existUser = shezUserService.findByEmail(email);
        
        // 기존 유저면 DB의 권한, 신규 유저면 ROLE_OAUTH
        if (existUser != null) {
            return new PrincipalOAuth2UserDetails(
                oauth2User.getAttributes(),
                "sub",
                existUser.getRole()
            );
        } else {
            return new PrincipalOAuth2UserDetails(
                oauth2User.getAttributes(),
                "sub"
            );
        }
    }
}
