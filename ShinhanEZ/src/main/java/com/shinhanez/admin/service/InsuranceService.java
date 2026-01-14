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
	
	public List<Insurance> getList(){
		return insuranceMapper.allGet();
	}
	public Insurance getPlan(Long productNo){
		return insuranceMapper.get(productNo);
	}
	
	public void addPlan(Insurance insurance) {
		insuranceMapper.insert(insurance);
	}
	
	

}
