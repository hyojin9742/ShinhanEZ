package com.shinhanez.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.service.PaymentService;
import com.shinhanez.config.TossPaymentsConfig;
import com.shinhanez.domain.TossPaymentRequest;
import com.shinhanez.domain.TossPaymentResponse;
import com.shinhanez.service.TossPaymentService;

/**
 * 토스페이먼츠 결제 컨트롤러
 */
@Controller
@RequestMapping("/payment")
public class TossPaymentController {

    private static final Logger logger = LoggerFactory.getLogger(TossPaymentController.class);

    @Autowired
    private TossPaymentsConfig tossConfig;

    @Autowired
    private TossPaymentService tossPaymentService;

    @Autowired
    private PaymentService paymentService;

    /**
     * 결제 페이지
     */
    @GetMapping("/checkout")
    public String checkout(@RequestParam(required = false) Long contractId,
                          @RequestParam(required = false) Long paymentId,
                          @RequestParam(required = false) Long productNo,
                          @RequestParam(required = false) Long amount,
                          @RequestParam(required = false) String orderName,
                          Model model, HttpSession session) {

        // 테스트용 기본값 설정
        if (amount == null) amount = 50000L;
        if (orderName == null) orderName = "신한EZ 보험료 납입";
        if (contractId == null) contractId = 1L;
        if (paymentId == null) paymentId = 1L;
        if (productNo == null) productNo = 1L;

        // 주문 ID 생성
        String orderId = tossPaymentService.generateOrderId(contractId, paymentId);

        // 세션에 결제 정보 저장 (검증용)
        session.setAttribute("paymentOrderId", orderId);
        session.setAttribute("paymentAmount", amount);
        session.setAttribute("paymentContractId", contractId);
        session.setAttribute("paymentPaymentId", paymentId);
        session.setAttribute("paymentProductNo", productNo);

        model.addAttribute("clientKey", tossConfig.getClientKey());
        model.addAttribute("orderId", orderId);
        model.addAttribute("amount", amount);
        model.addAttribute("orderName", orderName);
        model.addAttribute("successUrl", tossConfig.getSuccessUrl());
        model.addAttribute("failUrl", tossConfig.getFailUrl());
        model.addAttribute("contractId", contractId);
        model.addAttribute("paymentId", paymentId);
        model.addAttribute("productNo", productNo);

        return "payment/checkout";
    }

    /**
     * 결제 성공 콜백
     */
    @GetMapping("/success")
    public String success(@RequestParam String paymentKey,
                         @RequestParam String orderId,
                         @RequestParam Long amount,
                         Model model, HttpSession session) {

        logger.info("결제 성공 콜백 - paymentKey: {}, orderId: {}, amount: {}", paymentKey, orderId, amount);

        // 세션에서 원래 결제 정보 조회하여 검증
        String sessionOrderId = (String) session.getAttribute("paymentOrderId");
        Long sessionAmount = (Long) session.getAttribute("paymentAmount");

        if (sessionOrderId == null || !sessionOrderId.equals(orderId)) {
            logger.warn("주문 ID 불일치 - session: {}, request: {}", sessionOrderId, orderId);
            model.addAttribute("error", "주문 정보가 일치하지 않습니다.");
            return "payment/fail";
        }

        if (sessionAmount == null || !sessionAmount.equals(amount)) {
            logger.warn("결제 금액 불일치 - session: {}, request: {}", sessionAmount, amount);
            model.addAttribute("error", "결제 금액이 일치하지 않습니다.");
            return "payment/fail";
        }

        // 토스 API로 결제 승인 요청
        TossPaymentResponse response = tossPaymentService.confirmPayment(paymentKey, orderId, amount);

        if (response.isSuccess()) {
            // 결제 성공 처리
            Long contractId = (Long) session.getAttribute("paymentContractId");
            Long paymentId = (Long) session.getAttribute("paymentPaymentId");

            // DB에 결제 완료 상태 업데이트
            if (paymentId != null) {
                paymentService.completePayment(paymentId, response.getMethod());
            }
            logger.info("결제 완료 - contractId: {}, paymentId: {}", contractId, paymentId);

            model.addAttribute("response", response);
            model.addAttribute("contractId", contractId);
            model.addAttribute("paymentId", paymentId);

            // 세션 정리
            session.removeAttribute("paymentOrderId");
            session.removeAttribute("paymentAmount");
            session.removeAttribute("paymentContractId");
            session.removeAttribute("paymentPaymentId");

            return "payment/success";
        } else {
            // 결제 승인 실패
            model.addAttribute("errorCode", response.getErrorCode());
            model.addAttribute("errorMessage", response.getErrorMessage());
            return "payment/fail";
        }
    }

    /**
     * 결제 실패 콜백
     */
    @GetMapping("/fail")
    public String fail(@RequestParam(required = false) String code,
                      @RequestParam(required = false) String message,
                      @RequestParam(required = false) String orderId,
                      Model model) {

        logger.warn("결제 실패 - code: {}, message: {}, orderId: {}", code, message, orderId);

        model.addAttribute("errorCode", code);
        model.addAttribute("errorMessage", message);
        model.addAttribute("orderId", orderId);

        return "payment/fail";
    }

    /**
     * 결제 승인 API (AJAX용)
     */
    @PostMapping("/confirm")
    @ResponseBody
    public Map<String, Object> confirmPayment(@RequestBody TossPaymentRequest request, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 세션 검증
            String sessionOrderId = (String) session.getAttribute("paymentOrderId");
            Long sessionAmount = (Long) session.getAttribute("paymentAmount");

            if (sessionOrderId == null || !sessionOrderId.equals(request.getOrderId())) {
                result.put("success", false);
                result.put("message", "주문 정보가 일치하지 않습니다.");
                return result;
            }

            // 결제 승인
            TossPaymentResponse response = tossPaymentService.confirmPayment(
                    request.getOrderId(), // paymentKey가 필요하지만 request에서 받아야 함
                    request.getOrderId(),
                    request.getAmount()
            );

            if (response.isSuccess()) {
                result.put("success", true);
                result.put("paymentKey", response.getPaymentKey());
                result.put("orderId", response.getOrderId());
                result.put("amount", response.getTotalAmount());
            } else {
                result.put("success", false);
                result.put("code", response.getErrorCode());
                result.put("message", response.getErrorMessage());
            }

        } catch (Exception e) {
            logger.error("결제 승인 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }

    /**
     * 결제 취소 API
     */
    @PostMapping("/cancel")
    @ResponseBody
    public Map<String, Object> cancelPayment(@RequestParam String paymentKey,
                                             @RequestParam String cancelReason) {
        Map<String, Object> result = new HashMap<>();

        try {
            TossPaymentResponse response = tossPaymentService.cancelPayment(paymentKey, cancelReason);

            if (response.isSuccess()) {
                result.put("success", true);
                result.put("message", "결제가 취소되었습니다.");
            } else {
                result.put("success", false);
                result.put("code", response.getErrorCode());
                result.put("message", response.getErrorMessage());
            }

        } catch (Exception e) {
            logger.error("결제 취소 오류", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }
}
