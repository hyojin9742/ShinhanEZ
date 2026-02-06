package com.shinhanez.admin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.mapper.AdminMapper;
import com.shinhanez.domain.Paging;
import com.shinhanez.domain.UserAdminDetails;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class AdminServiceImpl implements AdminService {
    private final PasswordEncoder passwordEncoder;
	private AdminMapper mapper;
	
	@Autowired
	public AdminServiceImpl(AdminMapper mapper, PasswordEncoder passwordEncoder) {
		this.mapper = mapper;
		this.passwordEncoder = passwordEncoder;
	}

	// 전체조회
	@Override
	public Map<String, Object> readAllAdmins(int pageNum, int pageSize, String searchType, String searchKeyword, String adminRole) {
		log.info("service 전체조회 시행");
		Map<String, Object> searchParams = new HashMap<>();
		searchParams.put("searchType", searchType);
		searchParams.put("searchKeyword", searchKeyword);
		searchParams.put("adminRole", adminRole);
		int totalDB = mapper.countAllAdmins(searchParams);
		Paging pagingObj = new Paging(pageNum, pageSize, totalDB, 5);
		Map<String, Object> paging = new HashMap<>();
		paging.put("pagingObj", pagingObj);
		paging.put("hasPrev", pagingObj.hasPrev());
		paging.put("hasNext", pagingObj.hasNext());
		
		
		List<Admins> allList = mapper.selectAllAdmins(pagingObj.startRow(), pagingObj.endRow(), searchParams);
		
		Map<String, Object> adminLists = new HashMap<>();
		adminLists.put("paging", paging);
		adminLists.put("allList", allList);
		return adminLists;
	}
	// 단건조회
	@Override
	public Admins readOneAdmin(int adminIdx, HttpSession session, @AuthenticationPrincipal UserAdminDetails details) {
		log.info("service 단건조회 시행");
		Admins admin = mapper.selectOneAdmin(adminIdx);
		Integer sessionIdx = (Integer) session.getAttribute("adminIdx");
		if(admin.getAdminIdx() == sessionIdx || hasPermission(admin, details)) {
			return mapper.selectOneAdmin(adminIdx);
		} else {
			throw new IllegalArgumentException("권한이 없습니다"); // 예외처리 추가 필요
		}
	}
	// 등록
	@Transactional
	@Override
	public int registerAdmin(Admins admin, HttpSession session) {
		int register1 = 0;
		int register2 = 0;
		// 비밀번호 암호화
        if (admin.getAdminPw() != null && !admin.getAdminPw().isEmpty()) {
            String encodedPw = passwordEncoder.encode(admin.getAdminPw()) ;
            admin.setAdminPw(encodedPw);
            register1 = mapper.insertAdmin(admin);
            register2 = mapper.insertUser(admin);
        }
		if (register1 != 1 || register2 != 1) {
			throw new RuntimeException("관리자 등록 실패");
		}
		return 1;
	}
	// 수정
	@Transactional
	@Override
	public int modifyAdmin(Admins admin, HttpSession session, @AuthenticationPrincipal UserAdminDetails details) {
		Integer adminIdx = (Integer) session.getAttribute("adminIdx");
		if(admin.getAdminIdx() == adminIdx || hasPermission(admin, details)) {
				if (admin.getAdminPw() != null && !admin.getAdminPw().isEmpty()) {
				String encodedPw = passwordEncoder.encode(admin.getAdminPw()) ;
	            admin.setAdminPw(encodedPw);
			}
			int modify1 = mapper.updateAdmin(admin);
			int modify2 = mapper.updateUser(admin);
			if(modify1 != 1 || modify2 != 1) {
				throw new RuntimeException("관리자 수정 실패");
			}
			return 1;
		} else {
			return 0;
		}
	}
	// 삭제
	@Override
	public int deleteAdmin(int adminIdx, HttpSession session, @AuthenticationPrincipal UserAdminDetails details) {
		Admins admin = mapper.selectOneAdmin(adminIdx);
		Integer sessionIdx = (Integer) session.getAttribute("adminIdx");
		if(admin.getAdminIdx() == sessionIdx || hasPermission(admin, details)) {
			int delete1 = mapper.deleteAdmin(adminIdx);
			int delete2 = mapper.deleteUser(admin.getAdminId());
			if(delete1 != 1 || delete2 != 1) {
				throw new RuntimeException("관리자 수정 실패");
			}
			return 1;
		} else {
			return 0;
		}
	}
	
	// 마지막 로그인
	@Override
	public int lastLogin(int adminIdx) {
		return mapper.lastLogin(adminIdx);
	}
	// 아이디로 관리자 가져오기
	@Override
	public Admins readOneAdminById(String adminId) {
		Admins adminById = mapper.selectOneAdminById(adminId);
		return adminById;
	}
	// 권한 체크
	public boolean hasPermission(Admins admin, @AuthenticationPrincipal UserAdminDetails details) {
		String adminRole = details.getAdmin().getAdminRole();
		String targetRole = mapper.selectOneAdmin(admin.getAdminIdx()).getAdminRole();
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
