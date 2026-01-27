package com.shinhanez.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;


public interface UserClaimsMapper {
	// 고객(userId)의 계약 리스트 조회
	public List<Contracts> selectContractsByUserId(
			@Param("userId") String userId);
	
	// 고객(userId)의 단일 계약 상세 조회
	public Contracts selectContractDetailByUserId(
			@Param("userId") String userId,
			@Param("contractId") Integer contractId);
	
	// 청구등록
	public int insertClaim(ClaimsDTO claimsDTO);
}
