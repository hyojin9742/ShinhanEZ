package com.shinhanez.admin.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.ClaimsCriteria;
import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;

public interface ClaimsService {

	// 전체 청구 리스트
	public List<ClaimsDTO> getClaimList(ClaimsCriteria claimsCriteria);
	// 전체 청구 count
	int getClaimTotalCount(ClaimsCriteria claimsCriteria);
	// 단일 청구 조회
	public ClaimsDTO getClaim(Long claimId);
	// 청구 추가
	public int insertClaim(ClaimsDTO claimsDTO);
	// 청구 수정
	public int updateClaim(ClaimsDTO claimsDTO);	
	// 청구 삭제
	public int deleteClaim(
			@Param("adminIdx") int adminIdx,
			@Param("claimId") Long claimId);
	// customer_id로 계약조회
	public List<Contracts> getListContractsByCustomerId(String customerId);

}
