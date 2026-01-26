package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.ClaimsCriteria;
import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;

public interface ClaimsMapper {

	// 청구 목록 조회
	List<ClaimsDTO> getClaimList(ClaimsCriteria claimsCriteria);
	
	// 청구 전체 count
	int getClaimTotalCount(ClaimsCriteria claimsCriteria);

	// 청구 단건 조회
	ClaimsDTO getClaim(Long claimId);

	// 청구 등록
	int insertClaim(ClaimsDTO claimsDTO);

	// 청구 수정
	int updateClaim(ClaimsDTO claimsDTO);

	// 청구 삭제
	int deleteClaim(
			@Param("adminIdx") int adminIdx,
			@Param("claimId") Long claimId);

	// cutomerId로 계약 리스트조회
	List<Contracts> getListContractsByCustomerId(String customerId);
	
	// phone으로 customerId 조회
	Customer findCustomerByPhone(@Param("phone") String phone);
	

}
