package com.shinhanez.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.shinhanez.service.PrincipalOauth2UserService; // 서비스 import 확인

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final PrincipalOauth2UserService principalOauth2UserService;
    private final OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf().disable(); 
        http.authorizeRequests() 
        .antMatchers("/**").permitAll()
            .anyRequest().authenticated()
        .and()
            .oauth2Login()
            .loginPage("/member/login")
            .userInfoEndpoint()
                .userService(principalOauth2UserService)
            .and()
            .successHandler(oAuth2LoginSuccessHandler);
        
     // 4. ★ 로그아웃 설정 (여기가 중요!)
        http.logout()
            .logoutRequestMatcher(new AntPathRequestMatcher("/member/logout")) // URL이 /logout 이면 로그아웃 실행
            .logoutSuccessUrl("/")  // 로그아웃 성공 시 메인으로 이동
            .invalidateHttpSession(true) // 세션(로그인 정보) 싹 지우기
            .deleteCookies("JSESSIONID"); // 쿠키 삭제
        
        
		return http.build();
	}
}