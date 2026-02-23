package com.shinhanez.admin.domain;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class RpaDTO {
    
    // ==========================================
    // 1. 계약 및 고객 정보 (Contract & Customer)
    // ==========================================
	private Integer contractId;         // 계약번호 (공통)
	private String customerId;
    private String name;  			     // 고객이름
    private Date birthDate;          // 생년월일
    private String gender;             // 성별
    private Long productNo;          // 상품번호
    private String productName;        // 상품명
    private String productCategory;    // 상품분류
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date regDate;       // 계약일
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date expiredDate;         // 만료일
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date updateDate;         // 수정일
    private Integer premiumAmount;     // 월보험료
    private String paymentCycle;       // 납입주기
    private String contractStatus;     // 계약상태

    // ==========================================
    // 2. 납입 정보 (Payment)
    // ==========================================
    private Long paymentId;          // 납입번호
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date paymentDate;        // 납입일
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date dueDate;    // 납입기한
    private Long amount;      // 납입금액
    private String status;      // 납입상태

    // ==========================================
    // 3. 청구 정보 (Claim)
    // ==========================================
    private Long claimId;            // 청구번호
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate claimDate;          // 청구일
    private BigDecimal claimAmount;        // 청구금액
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate paidAt; // 지급일
    private BigDecimal paidAmount;       // 지급액
}