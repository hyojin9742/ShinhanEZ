package com.shinhanez.admin.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.shinhanez.admin.domain.Admins;

public interface AdminService {
    // 기존 DB 평문 PW 암호화 | 임시
	public void encodeAdmins();
	// 전체 조회
	public Map<String, Object> readAllAdmins(int pageNum, int pageSize, String searchType, String searchKeyword, String adminRole);
	// 단건 조회
	public Admins readOneAdmin(int adminIdx, HttpSession session);
	// 등록
	public int registerAdmin(Admins admin, HttpSession session);
	// 수정
	public int modifyAdmin(Admins admin, HttpSession session);
	// 삭제
	public int deleteAdmin(int adminIdx, HttpSession session);
	
	// 마지막 로그인
	public int lastLogin(int adminIdx);
	// 아이디로 관리자 가져오기
	public Admins readOneAdminById(String adminId);
}
