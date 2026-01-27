package com.shinhanez.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
    @Bean
    public SecurityFilterChain securityChain(HttpSecurity http) throws Exception {
        http
        	.csrf(csrf -> csrf.disable())
        	.authorizeHttpRequests(auth -> auth
                // 정적 리소스 허용
                .antMatchers(
            		"/css/**", 
            		"/js/**", 
            		"/images/**", 
            		"/resources/**"
        		).permitAll()
                // 공개 페이지
                .antMatchers("/", "/index").permitAll()
                .antMatchers("/member/join", "/member/login").permitAll()
                .antMatchers("/member/checkId").permitAll()
                .antMatchers("/member/popup/**").permitAll()
                // 회원 전용
                .antMatchers("/mypage/**").authenticated()
                .antMatchers("/payment/**").authenticated()
                // 관리자 전용
                .antMatchers("/admin/**").hasRole("ADMIN")
                // 나머지는 인증 필요
                .anyRequest().authenticated()
            )
            .logout(logout -> logout
                .logoutUrl("/member/logout")
                .logoutSuccessUrl("/")
                .permitAll()
            )
            // 세션 관리
            .sessionManagement(session -> session
                .maximumSessions(1)
                .maxSessionsPreventsLogin(false)
                .expiredUrl("/member/login?expired=true")
            );
    	return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
