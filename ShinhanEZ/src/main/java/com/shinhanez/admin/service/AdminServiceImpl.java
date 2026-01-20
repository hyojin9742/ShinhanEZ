package com.shinhanez.admin.service;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.mapper.AdminMapper;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class AdminServiceImpl implements AdminService {
	private AdminMapper mapper;
	@Autowired
	public AdminServiceImpl(AdminMapper mapper) {
		this.mapper = mapper;
	}
	
	// 전체조회
	@Override
	public List<Admins> readAllAdmins() {
		log.info("service 전체조회 시행");
		return mapper.selectAllAdmins();
	}
	// 단건조회
	@Override
	public Admins readOneAdmin(int adminIdx) {
		log.info("service 단건조회 시행");
		return mapper.selectOneAdmin(adminIdx);
	}
	// 등록
	@Transactional
	@Override
	public int registerAdmin(Admins admin,HttpSession session) {
		if(hasPermission(admin, session)) {
			int result1 = mapper.insertAdmin(admin);
			int result2 = mapper.insertUser(admin);
			if (result1 != 1 || result2 != 1) {
				throw new RuntimeException("관리자 등록 실패");
			}
			return 1;
		}
        return 0;
	}
	// 수정
	@Transactional
	@Override
	public int modifyAdmin(Admins admin, HttpSession session) {
		Integer adminIdx = (Integer) session.getAttribute("adminIdx");
		if(admin.getAdminIdx() == adminIdx || hasPermission(admin, session)) {
			mapper.updateAdmin(admin);
			return 1;
		} else {
			return 0;
		}
	}
	// 삭제
	@Override
	public int deleteAdmin(int adminIdx, HttpSession session) {
		Admins admin = mapper.selectOneAdmin(adminIdx);
		adminIdx = (Integer) session.getAttribute("adminIdx");
		if(admin.getAdminIdx() == adminIdx || hasPermission(admin, session)) {
			mapper.deleteAdmin(adminIdx);
			return 1;
		} else {
			return 0;
		}
	}
	
	// 아이디로 관리자 가져오기
	@Override
	public Admins readOneAdminById(String adminId) {
		Admins adminById = mapper.selectOneAdminById(adminId);
		return adminById;
	}
	// 마지막 로그인
	@Override
	public int lastLogin(int adminIdx) {
		return mapper.lastLogin(adminIdx);
	}
	// 권한 체크
	@Override
	public boolean hasPermission(Admins admin, HttpSession session) {
		String adminRole = (String) session.getAttribute("adminRole");
		String targetRole = admin.getAdminRole();
		if(adminRole == null || targetRole == null ) {
			return false;
		}
		switch (adminRole) {
        case "super":
            return true;
        case "manager":
            return "staff".equals(targetRole);
        default:
            return false;
		}
	}
}
