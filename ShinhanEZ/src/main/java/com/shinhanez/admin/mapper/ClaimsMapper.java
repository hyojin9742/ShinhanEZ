package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.ClaimsDTO;

public interface ClaimsMapper {

	// 청구 목록 조회
	List<ClaimsDTO> getClaimList();

	// 청구 단건 조회
	ClaimsDTO getClaim(Long claimId);

	// 청구 등록
	int insertClaim(ClaimsDTO claimsDTO);

	// 청구 수정
	int updateClaim(ClaimsDTO claimsDTO);

	// 청구 삭제
	int deleteClaim(
			@Param("adminId") int adminId,
			@Param("claimId") Long claimId);

	
}
