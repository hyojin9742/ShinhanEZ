package com.shinhanez.admin.domain;

import lombok.AllArgsConstructor;

import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDateTime;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString

public class Insurance {
    
    /**
     * 상품번호 (Primary Key)
     */
    private Long productNo;
    
    /**
     * 상품명
     */
    private String productName;
    
    /**
     * 분류 (생명보험, 손해보험, 건강보험 등)
     */
    private String category;
    
    /**
     * 기본 보험료
     */
    private Long basePremium;
    
    /**
     * 보장범위
     */
    private String coverageRange;
    
    /**
     * 보장 기간 (개월 단위)
     */
    private Integer coveragePeriod;
    
    /**
     * 상태 (ACTIVE, INACTIVE)
     */
    private String status;
    
    /**
     * 생성일
     */
    private Date createdDate;
    
    /**
     * 수정일
     */
    private Date updatedDate;
    
    /**
     * 생성자
     */
    private String createdUser;
    
    /**
     * 수정자
     */
    private String updatedUser;
    
    /**
     * 상품 활성 여부 확인
     */
    public boolean isActive() {
        return "ACTIVE".equals(this.status);
    }
    
    /**
     * 상품 활성화
     */
    public void activate() {
        this.status = "ACTIVE";
    }
    
    /**
     * 상품 비활성화
     */
    public void deactivate() {
        this.status = "INACTIVE";
    }
}