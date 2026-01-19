package com.shinhanez.admin.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Admins {
	int adminId;
	String id;
	String pw;
	String role;
	String name;
	String department;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	Date last_login;
}
