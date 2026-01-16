package com.shinhanez.admin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.mapper.ContractMapper;
import com.shinhanez.domain.Paging;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Service
@RequiredArgsConstructor
public class ContractServiceImpl implements ContractService {
	private final ContractMapper mapper;
		
	// 계약 목록 조회
	@Override
	public Map<String, Object> readAllList(int pageNum, int pageSize) {
		
		log.info("전체 계약 조회 | 페이지 번호 : "+pageNum+" 페이지 크기 : "+pageSize);
		
		int totalDB = mapper.countAllContracts();
		Paging pagingObj = new Paging(pageNum, pageSize, totalDB, 5);
		Map<String, Object> paging = new HashMap<>();
		paging.put("paging", pagingObj);
		paging.put("hasPrev", pagingObj.hasPrev());
		paging.put("hasNext", pagingObj.hasNext());
		
		List<Contracts> allList = mapper.selectAllContractList(pagingObj.startRow(), pagingObj.endRow());
		
		Map<String, Object> contractLists = new HashMap<>();
		contractLists.put("paging", paging);
		contractLists.put("allList", allList);
		
		return contractLists;
	}	
	// 계약 단건 조회
	@Override
	public Contracts readOneContract(Integer ctrId) {
		log.info("단건 조회 서비스 계약번호 "+ctrId);
		Contracts contract = mapper.selectOneContract(ctrId);
		if(contract == null) {
			throw new IllegalArgumentException("없는 계약 번호입니다 : "+ctrId);
		}
		return contract;
	}
	// 계약 등록
	@Transactional
	@Override
	public int registerContract(Contracts ctr) {
		log.info("등록 서비스 : "+ctr);
		validateRegister(ctr);
		validateContract(ctr);
		
		int registerResult = mapper.insertContract(ctr);
		if(registerResult != 1) {
			throw new RuntimeException("등록에 실패했습니다.");
		}
		return registerResult; // 반환값 확인
	}
	
	// 계약 수정
	@Transactional
	@Override
	public int updateContract(Contracts ctr) {
		log.info("수정 서비스 : "+ctr);
		validateContract(ctr);
		int updateResult = mapper.updateContract(ctr);
		if(updateResult != 1) {
			throw new RuntimeException("수정에 실패했습니다.");
		}
		return updateResult; // 반환값 확인
	}
	
	// 유효성 검증
	private void validateContract(Contracts contract) {
		if(contract.getInsuredId() ==  null ) {
			throw new IllegalArgumentException("피보험자 번호는 필수입니다");			
		}
		if(contract.getProductId() ==  null ) {
			throw new IllegalArgumentException("상품 번호는 필수입니다");			
		}
		if(contract.getContractCoverage() ==  null ) {
			throw new IllegalArgumentException("보장 내용은 필수입니다");			
		}
		if(contract.getPremiumAmount() ==  null ) {
			throw new IllegalArgumentException("납부 보험료는 필수입니다");			
		}
		if(contract.getPaymentCycle() ==  null ) {
			throw new IllegalArgumentException("납입 주기 필수입니다");			
		}
		if(contract.getContractStatus() ==  null ) {
			throw new IllegalArgumentException("계약 상태는 필수입니다");			
		}
		if(contract.getAdminId() ==  null ) {
			throw new IllegalArgumentException("관리자 번호는 필수입니다");			
		}
	}// /validateContract
	public void validateRegister(Contracts contract) {
		if(contract.getCustomerId() == null ) {
			throw new IllegalArgumentException("고객 번호는 필수입니다");
		}
		if(contract.getRegDate() ==  null ) {
			throw new IllegalArgumentException("계약일은 필수입니다");			
		}
		if(contract.getExpiredDate() ==  null ) {
			throw new IllegalArgumentException("만료일 필수입니다");			
		}
	}// /validateRegister
}
