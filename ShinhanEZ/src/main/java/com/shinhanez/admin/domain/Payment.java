package com.shinhanez.admin.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 납입내역 DTO
 */
public class Payment {
    private Long paymentId;      // 납입 ID (PK)
    private Long contractId;     // 계약 ID (FK)
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date paymentDate;    // 실제 납입일
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date dueDate;        // 납입 기한
    
    private Long amount;         // 납입 금액
    private String method;       // 납입 방법 (자동이체/카드/계좌이체)
    private String status;       // 납입 상태 (PAID/PENDING/OVERDUE)
    private Date regDate;        // 등록일
    
    // 조인용 필드
    private String customerName; // 고객명
    private String productName;  // 상품명
    
    // Getters and Setters
    public Long getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(Long paymentId) {
        this.paymentId = paymentId;
    }
    
    public Long getContractId() {
        return contractId;
    }
    
    public void setContractId(Long contractId) {
        this.contractId = contractId;
    }
    
    public Date getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }
    
    public Date getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }
    
    public Long getAmount() {
        return amount;
    }
    
    public void setAmount(Long amount) {
        this.amount = amount;
    }
    
    public String getMethod() {
        return method;
    }
    
    public void setMethod(String method) {
        this.method = method;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getRegDate() {
        return regDate;
    }
    
    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
}
