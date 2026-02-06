package com.shinhanez.admin.service;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.annotation.AuthenticationPrincipal;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.domain.UserAdminDetails;

public interface AdminService {

	// 전체 조회
	public Map<String, Object> readAllAdmins(int pageNum, int pageSize, String searchType, String searchKeyword, String adminRole);
	// 단건 조회
	public Admins readOneAdmin(int adminIdx, HttpSession session, @AuthenticationPrincipal UserAdminDetails details);
	// 등록
	public int registerAdmin(Admins admin, HttpSession session);
	// 수정
	public int modifyAdmin(Admins admin, HttpSession session, @AuthenticationPrincipal UserAdminDetails details);
	// 삭제
	public int deleteAdmin(int adminIdx, HttpSession session, @AuthenticationPrincipal UserAdminDetails details);
	
	// 마지막 로그인
	public int lastLogin(int adminIdx);
	// 아이디로 관리자 가져오기
	public Admins readOneAdminById(String adminId);
}
