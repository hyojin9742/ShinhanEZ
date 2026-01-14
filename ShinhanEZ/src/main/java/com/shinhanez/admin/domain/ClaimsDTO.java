package com.shinhanez.admin.domain;

import java.time.LocalDate;
import java.math.BigDecimal;

import lombok.Data;
import lombok.Setter;

@Data
public class ClaimsDTO {

    private Long claimId;                 // 청구 번호 PK NN

    private String customerId;             // 청구인 NN
    private String insuredId;              // 피보험자 NN
    private Long contractId;               // 계약 ID NN

    private LocalDate accidentDate;        // 사고일 NN
    private LocalDate claimDate;           // 청구일 NN

    private BigDecimal claimAmount;        // 청구금액 (NUMBER(15,2)) NN
    private String documentList;           // 서류 목록

    private LocalDate paidAt;              // 지급일
    private BigDecimal paidAmount;         // 지급액 (NUMBER(15,2))

    private String status;                 // 처리 상태 NN
    private LocalDate completedAt;         // 처리 완료일

    private Long adminId;                  // 담당 관리자
    
    // list 조회용 필드--------------------------------------------

	// 보험신청자
	private String customerName;
	// 피보험자
	private String insuredName;
	// 담당자
	private String adminName;
}
