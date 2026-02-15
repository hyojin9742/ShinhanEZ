package com.shinhanez.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;

import com.shinhanez.admin.service.AdminService;
import com.shinhanez.service.PrincipalOauth2UserService;
import com.shinhanez.service.ShezUserService;
import com.shinhanez.service.UserAdminDetailsService;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

	private final UserAdminDetailsService userAdminDetailsService; 
    private final PrincipalOauth2UserService principalOauth2UserService;
    private final AdminService adminService;
    
    // 정적 리소스 필터 제외
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return web -> web.ignoring()
            .antMatchers(
                "/css/**",
                "/js/**",
                "/images/**",
                "/resources/**",
                "/favicon.ico",
                "/.well-known/**"
            );
    }
    @Bean
    public SecurityFilterChain securityChain(HttpSecurity http) throws Exception {
        http
        	.csrf(csrf -> csrf.disable())
        	.authorizeHttpRequests(auth -> auth
                // 공개 페이지
                .antMatchers("/", "/index").permitAll()
                .antMatchers("/pages/**").permitAll()
                .antMatchers("/member/**").permitAll()
                .antMatchers("/board/list/**","/board/view/**").permitAll()
                .antMatchers("/product/list/**","/product/detail/**").permitAll()
                .antMatchers("/popup/**").permitAll()
                // 회원 전용 | 간편 로그인 + DB로그인
                .antMatchers("/board/write/**","/board/edit/**","/board/delete/**").hasAnyRole("USER", "ADMIN")
                .antMatchers("/mypage/**").hasRole("USER")
                .antMatchers("/product/subscribe/**").hasAnyRole("USER", "ADMIN")
                .antMatchers("/payment/**").hasAnyRole("USER", "ADMIN")
                .antMatchers("/user/claims/**").hasAnyRole("USER", "ADMIN")
                .antMatchers("/userContract/**").hasAnyRole("USER", "ADMIN")
                // 관리자 전용
                .antMatchers("/admin/**").hasRole("ADMIN")
                .antMatchers(HttpMethod.PUT, "/admin/**").hasRole("ADMIN")
                .antMatchers(HttpMethod.PATCH, "/admin/**").hasRole("ADMIN")
                .antMatchers(HttpMethod.DELETE, "/admin/**").hasRole("ADMIN")
                // 나머지는 인증 필요
                .anyRequest().authenticated()
            )
            // OAuth2 로그인 설정
            /*.oauth2Login(oauth2 -> oauth2
                .loginPage("/member/login")           // 커스텀 로그인 페이지
                .userInfoEndpoint(userInfo -> userInfo
                    .userService(principalOauth2UserService)  // OAuth2 사용자 정보 처리
                )
                .successHandler(new OAuth2LoginSuccessHandler())    // 로그인 성공 핸들러
            )*/
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
                .deleteCookies("JSESSIONID","remember-me") // 브라우저 세션 삭제
                .clearAuthentication(true)
                .permitAll()
            )
            // 로그인 유지
            .rememberMe(remember -> remember
                .key("shezCookie")              			  // 쿠키 암호화 키(테스트용) | 추후 랜덤값으로 수정
                .rememberMeParameter("keepLogin")  			  // 로그인 폼에서 체크박스 name
                .tokenValiditySeconds(60 * 60 * 24 * 14) 	  // 14일 유지 (초 단위)
                .userDetailsService(userAdminDetailsService)  // 사용자 정보 서비스
                .alwaysRemember(false)						  // 명시적으로 체크박스 선택시에만 유지
                .useSecureCookie(false) 					  // HTTPS 환경이면 true 설정
            )
            .exceptionHandling(ex -> ex
                .accessDeniedHandler(accessDeniedHandler())
            )
            // 세션 관리
            .sessionManagement(session -> session
        		.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)	
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
        return new LoginSuccessHandler(adminService);
    }
    @Bean
    public LoginFailureHandler loginFailureHandler() {
    	return new LoginFailureHandler();
    }
    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return (request, response, accessDeniedException) -> {
        	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        	if (auth != null && auth.isAuthenticated()) {
                boolean isOAuthOnly = auth.getAuthorities().stream()
                        .map(GrantedAuthority::getAuthority)
                        .anyMatch(role -> role.equals("ROLE_OAUTH"));
                
                boolean isUser = auth.getAuthorities().stream()
                        .map(GrantedAuthority::getAuthority)
                        .anyMatch(role -> role.equals("ROLE_USER"));
                boolean isAdmin = auth.getAuthorities().stream()
                		.map(GrantedAuthority::getAuthority)
                		.anyMatch(role -> role.equals("ROLE_ADMIN"));
                
                // OAuth 사용자가 USER 이상 권한 필요한 곳 접근
                if (isOAuthOnly && !isUser) {
                    response.sendRedirect("/member/join?msg=oauth");
                    return;
                } else if(isUser && !isAdmin) {                	
                	response.sendRedirect("/member/login?error=auth");
                	return;
                }
            }
            response.sendRedirect("/member/login?error=needLogin");
        };
    }
}
