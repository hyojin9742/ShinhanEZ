package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;

@Mapper
public interface ContractMapper {
	// 계약 목록 조회
	public List<Contracts> selectAllContractList(@Param("startRow") int startRow, @Param("endRow") int endRow);
	// 계약 전체 건수
	public int countAllContracts();
	// 계약 단건 조회
	public Contracts selectOneContract(Integer ctrId);
	// 계약 등록
	public int insertContract(Contracts ctr);
	// 계약 수정
	public int updateContract(Contracts ctr);
	
	/* 자동완성 데이터 검색 */
	// 계약자, 피보험자 검색
	public List<Customer> searchCustomerByName(@Param("customerName") String customerName);
	// 보험 상품 검색
	// 관리자 검색
}
