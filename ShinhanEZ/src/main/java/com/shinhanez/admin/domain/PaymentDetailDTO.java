package com.shinhanez.admin.domain;

import lombok.Data;

@Data
public class PaymentDetailDTO {
	// 1. 고객 정보
    private String customerId;      // 고객번호 (VARCHAR2)
    private String name;            // 이름 (Join 결과)

    // 2. 계약 정보
    private Long contractId;        // 계약번호 (NUMBER)
    private Long productId;        // 상품번호 (NUMBER)
    private String paymentCycle;    // 납입주기 (월납, 분기납 등)
    private Long premiumAmount;     // 월보험료 (청구액)

    // 3. 납입 정보
    private String paymentDate;  // 실제납입일 (Date)
    private String dueDate;      // 납입기한 (Date)
    private Double amount;          // 실제납입액 (NUMBER(12,2))
    private String method;          // 납입방법 (자동이체 등)
    private String status;

}
