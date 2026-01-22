package com.shinhanez.admin.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class Admins {
	int adminIdx;
	String adminId;
	String adminPw;
	String adminRole;
	String adminName;
	String department;
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	Date lastLogin;
}
