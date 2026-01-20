package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.shinhanez.admin.domain.Admins;

@Mapper
public interface AdminMapper {
	// 관리자 목록
	public List<Admins> selectAllAdmins();
	// 관리자 상세
	public Admins selectOneAdmin(int adminIdx);
	// 등록
	public int insertAdimin(Admins admin);
	public int insertUser(Admins admin);
	// 수정
	public int updateAdmin(Admins admin);
	// 삭제
	public int deleteAdmin(int adminIdx);
}
