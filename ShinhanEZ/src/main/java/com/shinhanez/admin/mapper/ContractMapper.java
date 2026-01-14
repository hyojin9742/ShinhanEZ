package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.Contracts;

@Mapper
public interface ContractMapper {
	// 계약 목록 조회
	public List<Contracts> allContractList(@Param("startRow") int startRow, @Param("endRow") int endRow);
	// 계약 전체 건수
	public int countAllContracts();
	// 계약 단건 조회
	public Contracts getContract(Integer ctrId);
	// 계약 등록
	public int registerContract(Contracts ctr);
	// 계약 수정
	public int reviseContract(Contracts ctr);
}
