package com.shinhanez.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Swagger/OpenAPI 문서화 설정
 * - API 문서 자동 생성
 * - 접속: http://localhost:8090/swagger-ui.html
 */
@Configuration
public class SwaggerConfig {

    @Value("${server.port:8090}")
    private String serverPort;

    @Bean
    public OpenAPI openAPI() {
        // API 기본 정보
        Info info = new Info()
                .title("ShinhanEZ 보험관리 시스템 API")
                .version("1.0.0")
                .description("신한EZ손해보험 관리 시스템 REST API 문서입니다.\n\n" +
                        "## 주요 기능\n" +
                        "- 회원 관리 (가입, 로그인, 소셜 로그인)\n" +
                        "- 보험 상품 관리\n" +
                        "- 계약 관리\n" +
                        "- 보험금 청구 관리\n" +
                        "- 납입금 관리\n" +
                        "- 게시판 관리")
                .contact(new Contact()
                        .name("ShinhanEZ 개발팀")
                        .email("dev@shinhanez.com")
                        .url("https://www.shinhanez.com"))
                .license(new License()
                        .name("Apache 2.0")
                        .url("https://www.apache.org/licenses/LICENSE-2.0"));

        // 서버 정보
        Server localServer = new Server()
                .url("http://localhost:" + serverPort)
                .description("로컬 개발 서버");

        Server prodServer = new Server()
                .url("https://api.shinhanez.com")
                .description("운영 서버");

        // 세션 기반 인증 스키마
        SecurityScheme sessionAuth = new SecurityScheme()
                .type(SecurityScheme.Type.APIKEY)
                .in(SecurityScheme.In.COOKIE)
                .name("JSESSIONID")
                .description("세션 기반 인증 (로그인 후 자동 적용)");

        return new OpenAPI()
                .info(info)
                .servers(List.of(localServer, prodServer))
                .components(new Components()
                        .addSecuritySchemes("sessionAuth", sessionAuth))
                .addSecurityItem(new SecurityRequirement().addList("sessionAuth"));
    }
}
