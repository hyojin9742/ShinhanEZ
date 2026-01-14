package com.shinhanez.admin.domain;


import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Contracts {
	private Integer contractId;
	private String customerId;
	private String customerName;
	private String insuredId;
	private String insuredName;
	private Integer productId;
	private String productName;
    private String contractCoverage;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date regDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date expiredDate;
    private Integer premiumAmount;
    private String paymentCycle;
    private String contractStatus;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date updateDate;
    private Integer adminId;
    private String adminName;
}
