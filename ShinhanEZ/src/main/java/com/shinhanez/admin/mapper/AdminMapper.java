package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.shinhanez.admin.domain.Admins;

@Mapper
public interface AdminMapper {
	// 관리자 목록
	public List<Admins> selectAllAdmins();
	// 관리자 상세
	public Admins selectOneAdmins(int adminIdx);
	// 등록
	public int insertAdimins(Admins admin);
	// 수정
	public int updateAdmins(Admins admin);
	// 삭제
	public int deleteAdmins(int adminIdx);
}
