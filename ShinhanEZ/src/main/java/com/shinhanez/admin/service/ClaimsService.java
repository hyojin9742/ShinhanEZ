package com.shinhanez.admin.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.ClaimsDTO;

public interface ClaimsService {

	// 전체 청구 리스트
	public List<ClaimsDTO> getClaimList();
	// 단일 청구 조회
	public ClaimsDTO getClaim(Long claimId);
	// 청구 추가
	public int insertClaim(ClaimsDTO claimsDTO);
	// 청구 수정
	public int updateClaim(ClaimsDTO claimsDTO);	
	// 청구 삭제
	public int deleteClaim(
			@Param("adminId") int adminId,
			@Param("claimId") Long claimId);

}
