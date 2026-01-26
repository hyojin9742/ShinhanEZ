package com.shinhanez.domain;

import java.util.Date;

/**
 * 토스페이먼츠 결제 응답 DTO
 */
public class TossPaymentResponse {

    private String paymentKey;      // 토스 결제 키
    private String orderId;         // 주문 ID
    private String orderName;       // 주문명
    private String status;          // 결제 상태 (DONE, CANCELED, WAITING_FOR_DEPOSIT 등)
    private Long totalAmount;       // 총 결제 금액
    private String method;          // 결제 수단
    private Date approvedAt;        // 승인 일시
    private String receiptUrl;      // 영수증 URL

    // 에러 정보
    private String errorCode;
    private String errorMessage;

    // 성공 여부
    private boolean success;

    public TossPaymentResponse() {}

    public String getPaymentKey() {
        return paymentKey;
    }

    public void setPaymentKey(String paymentKey) {
        this.paymentKey = paymentKey;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getOrderName() {
        return orderName;
    }

    public void setOrderName(String orderName) {
        this.orderName = orderName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Long totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public Date getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Date approvedAt) {
        this.approvedAt = approvedAt;
    }

    public String getReceiptUrl() {
        return receiptUrl;
    }

    public void setReceiptUrl(String receiptUrl) {
        this.receiptUrl = receiptUrl;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
