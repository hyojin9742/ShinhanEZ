package com.shinhanez.admin.mapper;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.Admins;

import lombok.extern.log4j.Log4j2;

@Transactional
@SpringBootTest
@Log4j2
public class AdminMapperTest {
	private AdminMapper mapper;
	
	@Autowired
	public AdminMapperTest(AdminMapper mapper) {
		this.mapper = mapper;
	}
	
	// 주입
	@Test
	public void mapperDi() {
		log.info("mapper 주입 테스트 "+ mapper );
	}
	
	// 전체 조회
	@Test
	public void selectAllAdminsTest() {
		mapper.selectAllAdmins().forEach(list -> log.info("전체 목록 조회 => "+list));
	}
	
	// 관리자 상세
	@Test
	public void selectOneAdminsTest() {
		Admins admin = mapper.selectOneAdmin(2);
		log.info("2번 계약 조회 => " + admin);
	}
	// 등록
	@Test
	public void insertAdiminsTest() {
		Admins admin = new Admins();
		admin.setAdminId("admin11");
		admin.setAdminPw("1111");
		admin.setAdminName("박철수");
		admin.setAdminRole("super");
		admin.setDepartment("경영팀");
		
		int iadmin = mapper.insertAdmin(admin);
		int iuser = mapper.insertUser(admin);
		log.info("iadmin => "+iadmin+ "iuser => "+iuser);
	}
	// 수정
	@Test
	public void updateAdminTest() {
		Admins admin = new Admins();
		admin.setAdminId("admin11");
		admin.setAdminPw("1111");
		admin.setAdminName("박철수");
		admin.setAdminRole("super");
		admin.setDepartment("경영팀");
		admin.setAdminIdx(3);
		
		int updateAdmin = mapper.updateAdmin(admin);
		log.info("updateAdmin => "+updateAdmin);
	}
	// 삭제
	@Test
	public void deleteAdminTest() {
		log.info("deleteAdmin => " + mapper.deleteAdmin(4));
	}
	
	// 아이디로 관리자 가져오기
	@Test
	public void selectOneAdminById() {
		log.info("selectOneAdminById => " + mapper.selectOneAdminById("admin"));
	}
}