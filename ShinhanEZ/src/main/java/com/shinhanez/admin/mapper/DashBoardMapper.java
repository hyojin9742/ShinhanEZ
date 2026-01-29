package com.shinhanez.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.domain.ContractSearchCriteria;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.domain.DashBoard;
import com.shinhanez.admin.domain.Insurance;

@Mapper
public interface DashBoardMapper {
	// 연도별 상품 건별 조회
	public List<DashBoard> allplan(String year);
	
	// 연도별 월별 조회
	public List<DashBoard> monthlyplan(String year);
	
	//계약 조회
	public List<DashBoard> allConstract();
	
	//하단 리스트 (최근 계약자)
	public List<DashBoard> selectConstractsList(Map<String, Object> params);
	public int countConstracts(Map<String, Object> params);	
	
	//하단 리스트 (최근 계약자)
	public List<DashBoard> selectBoardsList(Map<String, Object> params);
	public int countBoards(Map<String, Object> params);
	
	
	
	// 연도 불러오기 (셀렉트 생성용)
	public List<String> years();
	
	
	// 전 회원수 불러오기
	public int allUserCount();
	
	// 전 고객수 불러오기
	public int allCustomerCount();
	
	// 전 계약수 불러오기
	public int allcontractCount();
	
	// 전 계약수 불러오기
	public int allboardCount();
	
}
