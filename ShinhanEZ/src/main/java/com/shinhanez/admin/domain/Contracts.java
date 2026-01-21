package com.shinhanez.admin.domain;


import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

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
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date regDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date expiredDate;
    private Integer premiumAmount;
    private String paymentCycle;
    private String contractStatus;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date updateDate;
    private Integer adminIdx;
    private String adminName;
}
