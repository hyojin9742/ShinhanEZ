package com.shinhanez.domain;

/**
 * 토스페이먼츠 결제 요청 DTO
 */
public class TossPaymentRequest {

    private String orderId;         // 주문 ID
    private Long amount;            // 결제 금액
    private String orderName;       // 주문명
    private String customerName;    // 고객명
    private String customerEmail;   // 고객 이메일
    private String paymentMethod;   // 결제 수단 (CARD, VIRTUAL_ACCOUNT, TRANSFER)

    // 계약 정보 (보험료 납입용)
    private Long contractId;        // 계약 ID
    private Long paymentId;         // 납입 ID

    public TossPaymentRequest() {}

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Long getAmount() {
        return amount;
    }

    public void setAmount(Long amount) {
        this.amount = amount;
    }

    public String getOrderName() {
        return orderName;
    }

    public void setOrderName(String orderName) {
        this.orderName = orderName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Long getContractId() {
        return contractId;
    }

    public void setContractId(Long contractId) {
        this.contractId = contractId;
    }

    public Long getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Long paymentId) {
        this.paymentId = paymentId;
    }
}
