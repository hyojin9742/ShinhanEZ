package com.shinhanez.service;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.shinhanez.domain.ShezUser;
import com.shinhanez.mapper.ShezUserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PrincipalOauth2UserService extends DefaultOAuth2UserService {

    // Mapper는 여기서 안 씁니다. (핸들러에서 쓸 예정)

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        // 1. 구글에서 유저 정보 가져오기
        OAuth2User oauth2User = super.loadUser(userRequest);
        
        // 2. 여기서 DB 저장을 하지 않고, 그대로 리턴합니다.
        // 나중에 핸들러에서 이 정보를 꺼내 쓸 수 있습니다.
        return oauth2User; 
    }
}
