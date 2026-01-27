package com.shinhanez.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import com.shinhanez.service.PrincipalOauth2UserService; // 서비스 import 확인

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final PrincipalOauth2UserService principalOauth2UserService;
    private final OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        
        http.csrf().disable(); // 2.7 문법

        http.authorizeRequests() // 2.7 문법 (여기가 다릅니다)
            // 1. 로그인 없이 들어갈 수 있는 주소들을 등록합니다.
            .antMatchers("/", "/index", "/member/login", "/member/join", "/css/**", "/images/**", "/js/**").permitAll()
            // 2. 그 외 나머지 주소는 인증(로그인)이 필요합니다.
            .anyRequest().authenticated()
        .and()
            .oauth2Login()
            .loginPage("/member/login")
            // 3. 로그인 성공 시 핸들러 연결
            .userInfoEndpoint()
                .userService(principalOauth2UserService)
            .and()
            .successHandler(oAuth2LoginSuccessHandler);
        
        return http.build();
    }
}