package com.shinhanez.admin.service;

import java.util.List;
import java.util.Map;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;

public interface ContractService {
	// 계약 목록 조회
	public Map<String, Object> readAllList(int pageNum, int pageSize);
	// 계약 단건 조회
	public Contracts readOneContract(Integer ctrId);
	// 계약 등록
	public int registerContract(Contracts ctr);
	// 계약 수정
	public int updateContract(Contracts ctr);
	
	/* 자동완성 */
	// 고객명 검색
	public List<Customer> searchCustomerByName(String cutomerName);
}
