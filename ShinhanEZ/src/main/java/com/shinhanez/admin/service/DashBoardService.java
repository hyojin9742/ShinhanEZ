package com.shinhanez.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.DashBoard;
import com.shinhanez.admin.mapper.DashBoardMapper;

@Service
public class DashBoardService {
	
	@Autowired
	private DashBoardMapper dashBoardMapper;
	
	
	// 연도별 상푼별 조회
	public List<DashBoard> allPlan(String year){
		return dashBoardMapper.allplan(year);
	}
	
	
	// 연도별 월별 조회
	public List<DashBoard> monthlyplan(String year){
		return dashBoardMapper.monthlyplan(year);
	}
	
	// 연도 가져오기
	public List<String> yearsGet(){
		return dashBoardMapper.years();
	}
	

}
