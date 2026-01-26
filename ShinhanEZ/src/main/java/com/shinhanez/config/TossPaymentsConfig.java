package com.shinhanez.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * 토스페이먼츠 API 설정
 */
@Configuration
@ConfigurationProperties(prefix = "toss.payments")
public class TossPaymentsConfig {

    private String clientKey;
    private String secretKey;
    private String successUrl;
    private String failUrl;

    // 토스페이먼츠 API URL
    public static final String TOSS_API_URL = "https://api.tosspayments.com/v1/payments";

    public String getClientKey() {
        return clientKey;
    }

    public void setClientKey(String clientKey) {
        this.clientKey = clientKey;
    }

    public String getSecretKey() {
        return secretKey;
    }

    public void setSecretKey(String secretKey) {
        this.secretKey = secretKey;
    }

    public String getSuccessUrl() {
        return successUrl;
    }

    public void setSuccessUrl(String successUrl) {
        this.successUrl = successUrl;
    }

    public String getFailUrl() {
        return failUrl;
    }

    public void setFailUrl(String failUrl) {
        this.failUrl = failUrl;
    }
}
