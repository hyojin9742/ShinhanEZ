package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.Admins;

@Mapper
public interface AdminMapper {
	// 관리자 목록
	public List<Admins> selectAllAdmins(@Param("startRow") int startRow, @Param("endRow") int endRow);
	// 관리자 전체 건수
	public int countAllAdmins();
	// 관리자 상세
	public Admins selectOneAdmin(int adminIdx);
	// 등록
	public int insertAdmin(Admins admin);
	public int insertUser(Admins admin);
	// 수정
	public int updateAdmin(Admins admin);
	// 삭제
	public int deleteAdmin(int adminIdx);
	// 아이디로 관리자 가져오기
	public Admins selectOneAdminById(String adminId);
	// 마지막 로그인 처리
	public int lastLogin(int adminIdx);
}
