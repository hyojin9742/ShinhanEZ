package com.shinhanez.admin.service;

import java.util.List;


import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.mapper.ClaimsMapper;

import lombok.RequiredArgsConstructor;
@Service
@RequiredArgsConstructor
@Transactional
public class ClaimsServiceImpl implements ClaimsService{

	// Mapper 주입
	private final ClaimsMapper claimsMapper;

	/* 메서드 구현 */
	
	// 청구 리스트
	@Override
	public List<ClaimsDTO> getClaimList() {
		return claimsMapper.getClaimList();
	}

	// 청구 단일 조회
	@Override
	public ClaimsDTO getClaim(Long claimId) {
		return claimsMapper.getClaim(claimId);
	}

	// 청구 추가
	@Override
	public int insertClaim(ClaimsDTO claimsDTO) {
		return claimsMapper.insertClaim(claimsDTO);
	}

	// 청구 업데이트
	@Override
	public int updateClaim(ClaimsDTO claimsDTO) {
		return claimsMapper.updateClaim(claimsDTO);
	}

	// 청구 삭제
	@Override
	public int deleteClaim(int adminId, Long claimId) {
		return claimsMapper.deleteClaim(adminId, claimId);
	}

}
