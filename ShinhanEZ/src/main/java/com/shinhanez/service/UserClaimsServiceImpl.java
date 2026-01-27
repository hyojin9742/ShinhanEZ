package com.shinhanez.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.mapper.UserClaimsMapper;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class UserClaimsServiceImpl implements UserClaimsService{

	// mapper 주입
	private final UserClaimsMapper userClaimsMapper;

	// userId로 계약리스트 조회
	@Override
	public List<Contracts> selectContractsByUserId(String userId) {
		return userClaimsMapper.selectContractsByUserId(userId);
	}

	// userId와 contractId로 계약 단일 조회
	@Override
	public Contracts selectContractDetailByUserId(String userId, Integer contractId) {
		return userClaimsMapper.selectContractDetailByUserId(userId, contractId);
	}

	@Override
	public int insertClaim(ClaimsDTO claimsDTO) {
		return userClaimsMapper.insertClaim(claimsDTO);
	}

	
}
