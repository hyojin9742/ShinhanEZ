package com.shinhanez.admin.service;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.shinhanez.admin.domain.Admins;

public interface AdminService {
	// 전체 조회
	public List<Admins> readAllAdmins();
	// 단건 조회
	public Admins readOneAdmin(int adminIdx);
	// 등록
	public int registerAdmin(Admins admin, HttpSession session);
	// 수정
	public int modifyAdmin(Admins admin, HttpSession session);
	// 삭제
	public int deleteAdmin(int adminIdx, HttpSession session);
	
	// 아이디로 관리자 가져오기
	public Admins readOneAdminById(String adminId);
	// 마지막 로그인
	public int lastLogin(int adminIdx);
	// 권한 체크
	public boolean hasPermission(Admins admin, HttpSession session);
}
