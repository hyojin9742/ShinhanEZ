package com.shinhanez.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.mapper.InsuranceMapper;

@Service
public class InsuranceService {
	
	
	@Autowired
	private InsuranceMapper insuranceMapper;
	
	// 전체 게시판
	public List<Insurance> getList(){
		return insuranceMapper.allGet();
	}
	
	// 전체 게시판22
	public List<Insurance> getList2(String status){
		return insuranceMapper.allGet2(status);
	}
	
	
	
	// 상세보기
	public Insurance getPlan(Long productNo){
		return insuranceMapper.get(productNo);
	}
	
	// 상품 추가
	public void addPlan(Insurance insurance) {
		insuranceMapper.insert(insurance);
	}
	
	
	// 상품 수정
	public void editPlan(Insurance insurance) {
		insuranceMapper.update(insurance);
	}
	
	

}
