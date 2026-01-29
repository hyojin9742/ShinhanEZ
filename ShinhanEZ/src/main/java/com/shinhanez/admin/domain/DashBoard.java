package com.shinhanez.admin.domain;

import java.util.Date;

import lombok.Data;


@Data
public class DashBoard {
	private String contractId;
	private String id;
	private String cusName;
	private String insurName;
	private String productName;
	private String regDate;
	private String status;
	private int count;
}
