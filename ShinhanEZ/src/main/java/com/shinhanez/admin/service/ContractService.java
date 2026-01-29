package com.shinhanez.admin.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.security.core.annotation.AuthenticationPrincipal;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.domain.ContractSearchCriteria;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.domain.UserAdminDetails;

public interface ContractService {
	// 계약 목록 조회
	public Map<String, Object> readAllList(int pageNum, int pageSize, ContractSearchCriteria criteria);
	// 계약 단건 조회
	public Contracts readOneContract(Integer contractId);
	// 계약 등록
	public int registerContract(Contracts contract);
	// 계약 수정
	public int updateContract(Contracts contract, @AuthenticationPrincipal UserAdminDetails details);
	
	/* 자동완성 */
	// 고객명 검색
	public List<Customer> searchCustomerByName(String cutomerName);
	// 보험 검색
	public List<Insurance> searchInsuranceByName(String productName);
	// 상품번호 보험 검색
	public Insurance searchInsuranceById(Long productNo);
	// 관리자 검색
	public List<Admins> searchAdminsByName(String adminName);

	// 키워드로 계약 검색 (통합 검색용)
	public List<Contracts> searchByKeyword(String keyword);
}
