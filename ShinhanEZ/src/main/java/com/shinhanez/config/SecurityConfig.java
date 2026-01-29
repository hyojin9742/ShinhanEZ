package com.shinhanez.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;

import com.shinhanez.service.UserAdminDetailsService;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	private final UserAdminDetailsService userAdminDetailsService; 
	
	public SecurityConfig(UserAdminDetailsService userAdminDetailsService) { 
		this.userAdminDetailsService = userAdminDetailsService; 
	}
	
    @Bean
    public SecurityFilterChain securityChain(HttpSecurity http) throws Exception {
        http
        	.csrf(csrf -> csrf.disable())
        	.authorizeHttpRequests(auth -> auth
                // 정적 리소스 허용
                .antMatchers(
            		"/.well-known/**",
            		"/css/**", 
            		"/js/**", 
            		"/images/**", 
            		"/resources/**"
        		).permitAll()
                // 공개 페이지
                .antMatchers("/", "/index").permitAll()
                .antMatchers("/pages/**").permitAll()
                .antMatchers("/member/**").permitAll()
                .antMatchers("/board/**").permitAll()
                .antMatchers("/product/**").permitAll()
                .antMatchers("/popup/**").permitAll()
                // 회원 전용
                .antMatchers("/board/write/**","/board/edit/**","/board/delete/**").authenticated()
                .antMatchers("/mypage/**").authenticated()
                .antMatchers("/product/subscribe/**").authenticated()
                .antMatchers("/payment/**").authenticated()
                // 관리자 전용
                .antMatchers("/admin/**").hasRole("ADMIN")
                .antMatchers(HttpMethod.PUT, "/admin/**").hasRole("ADMIN")
                .antMatchers(HttpMethod.PATCH, "/admin/**").hasRole("ADMIN")
                .antMatchers(HttpMethod.DELETE, "/admin/**").hasRole("ADMIN")
                // 나머지는 인증 필요
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/member/login")
                .loginProcessingUrl("/member/loginProc")
                .usernameParameter("id")
                .passwordParameter("pw")
                .defaultSuccessUrl("/", false)
                .successHandler(loginSuccessHandler())
                .failureHandler(loginFailureHandler())
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/member/logout")
                .logoutSuccessUrl("/")
                .invalidateHttpSession(true) // 서버 세션 무효화
                .deleteCookies("JSESSIONID") // 브라우저 세션 삭제
                .permitAll()
            )
            // 로그인 유지
            .rememberMe(remember -> remember
                .key("shezCookie")              			  // 쿠키 암호화 키(테스트용) | 추후 랜덤값으로 수정
                .rememberMeParameter("keepLogin")  			  // 로그인 폼에서 체크박스 name
                .tokenValiditySeconds(60 * 60 * 24 * 14) 	  // 14일 유지 (초 단위)
                .userDetailsService(userAdminDetailsService)  // 사용자 정보 서비스
            )
            .exceptionHandling(ex -> ex
                .accessDeniedHandler(accessDeniedHandler())
            )
            // 세션 관리
            .sessionManagement(session -> session
                .maximumSessions(1)
                .maxSessionsPreventsLogin(false)
                .expiredUrl("/member/login?error=needLogin")
            );
    	return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration authenticationConfiguration
    ) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }
    @Bean
    public LoginSuccessHandler loginSuccessHandler() {
        return new LoginSuccessHandler();
    }
    @Bean
    public LoginFailureHandler loginFailureHandler() {
    	return new LoginFailureHandler();
    }
    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return (request, response, accessDeniedException) -> {
            response.sendRedirect("/member/login?error=auth");
        };
    }
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
