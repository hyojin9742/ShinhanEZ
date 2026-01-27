package com.shinhanez.service;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.shinhanez.config.TossPaymentsConfig;
import com.shinhanez.domain.TossPaymentResponse;

/**
 * 토스페이먼츠 API 연동 서비스
 */
@Service
public class TossPaymentService {

    private static final Logger logger = LoggerFactory.getLogger(TossPaymentService.class);

    @Autowired
    private TossPaymentsConfig tossConfig;

    private final WebClient webClient;
    private final Gson gson;

    public TossPaymentService() {
        this.webClient = WebClient.builder()
                .baseUrl(TossPaymentsConfig.TOSS_API_URL)
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                .build();
        this.gson = new Gson();
    }

    /**
     * 결제 승인 요청
     * @param paymentKey 결제 키
     * @param orderId 주문 ID
     * @param amount 결제 금액
     * @return 결제 응답
     */
    public TossPaymentResponse confirmPayment(String paymentKey, String orderId, Long amount) {
        logger.info("결제 승인 요청 - paymentKey: {}, orderId: {}, amount: {}", paymentKey, orderId, amount);

        try {
            // Basic 인증 헤더 생성
            String authHeader = createAuthHeader();

            // 요청 바디 생성
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("paymentKey", paymentKey);
            requestBody.put("orderId", orderId);
            requestBody.put("amount", amount);

            // API 호출
            String response = webClient.post()
                    .uri("/confirm")
                    .header(HttpHeaders.AUTHORIZATION, authHeader)
                    .bodyValue(requestBody)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            logger.info("토스 API 응답: {}", response);

            return parseResponse(response);

        } catch (Exception e) {
            logger.error("결제 승인 실패", e);
            TossPaymentResponse errorResponse = new TossPaymentResponse();
            errorResponse.setSuccess(false);
            errorResponse.setErrorCode("CONFIRM_FAILED");
            errorResponse.setErrorMessage(e.getMessage());
            return errorResponse;
        }
    }

    /**
     * 결제 취소 요청
     * @param paymentKey 결제 키
     * @param cancelReason 취소 사유
     * @return 취소 응답
     */
    public TossPaymentResponse cancelPayment(String paymentKey, String cancelReason) {
        logger.info("결제 취소 요청 - paymentKey: {}, reason: {}", paymentKey, cancelReason);

        try {
            String authHeader = createAuthHeader();

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("cancelReason", cancelReason);

            String response = webClient.post()
                    .uri("/" + paymentKey + "/cancel")
                    .header(HttpHeaders.AUTHORIZATION, authHeader)
                    .bodyValue(requestBody)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            logger.info("토스 취소 API 응답: {}", response);

            return parseResponse(response);

        } catch (Exception e) {
            logger.error("결제 취소 실패", e);
            TossPaymentResponse errorResponse = new TossPaymentResponse();
            errorResponse.setSuccess(false);
            errorResponse.setErrorCode("CANCEL_FAILED");
            errorResponse.setErrorMessage(e.getMessage());
            return errorResponse;
        }
    }

    /**
     * 결제 조회
     * @param paymentKey 결제 키
     * @return 결제 정보
     */
    public TossPaymentResponse getPayment(String paymentKey) {
        logger.info("결제 조회 - paymentKey: {}", paymentKey);

        try {
            String authHeader = createAuthHeader();

            String response = webClient.get()
                    .uri("/" + paymentKey)
                    .header(HttpHeaders.AUTHORIZATION, authHeader)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            return parseResponse(response);

        } catch (Exception e) {
            logger.error("결제 조회 실패", e);
            TossPaymentResponse errorResponse = new TossPaymentResponse();
            errorResponse.setSuccess(false);
            errorResponse.setErrorCode("QUERY_FAILED");
            errorResponse.setErrorMessage(e.getMessage());
            return errorResponse;
        }
    }

    /**
     * Basic 인증 헤더 생성
     */
    private String createAuthHeader() {
        String credentials = tossConfig.getSecretKey() + ":";
        String encodedCredentials = Base64.getEncoder()
                .encodeToString(credentials.getBytes(StandardCharsets.UTF_8));
        return "Basic " + encodedCredentials;
    }

    /**
     * API 응답 파싱
     */
    private TossPaymentResponse parseResponse(String jsonResponse) {
        TossPaymentResponse response = new TossPaymentResponse();

        try {
            JsonObject json = gson.fromJson(jsonResponse, JsonObject.class);

            // 에러 체크
            if (json.has("code")) {
                response.setSuccess(false);
                response.setErrorCode(json.get("code").getAsString());
                response.setErrorMessage(json.has("message") ? json.get("message").getAsString() : "Unknown error");
                return response;
            }

            // 성공 응답 파싱
            response.setSuccess(true);
            response.setPaymentKey(json.has("paymentKey") ? json.get("paymentKey").getAsString() : null);
            response.setOrderId(json.has("orderId") ? json.get("orderId").getAsString() : null);
            response.setOrderName(json.has("orderName") ? json.get("orderName").getAsString() : null);
            response.setStatus(json.has("status") ? json.get("status").getAsString() : null);
            response.setTotalAmount(json.has("totalAmount") ? json.get("totalAmount").getAsLong() : null);
            response.setMethod(json.has("method") ? json.get("method").getAsString() : null);

            if (json.has("receipt") && json.get("receipt").isJsonObject()) {
                JsonObject receipt = json.getAsJsonObject("receipt");
                response.setReceiptUrl(receipt.has("url") ? receipt.get("url").getAsString() : null);
            }

            response.setApprovedAt(new Date());

        } catch (Exception e) {
            logger.error("응답 파싱 실패", e);
            response.setSuccess(false);
            response.setErrorCode("PARSE_ERROR");
            response.setErrorMessage("응답 파싱 실패: " + e.getMessage());
        }

        return response;
    }

    /**
     * 주문 ID 생성 (유니크)
     */
    public String generateOrderId(Long contractId, Long paymentId) {
        return "SHEZ_" + contractId + "_" + paymentId + "_" + System.currentTimeMillis();
    }
}
