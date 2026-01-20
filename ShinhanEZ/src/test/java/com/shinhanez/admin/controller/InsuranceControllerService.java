package com.shinhanez.admin.controller;


import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.service.InsuranceService;

@SpringBootTest
public class InsuranceControllerService {
	
	@Autowired
    private MockMvc mockMvc;
	
	@MockBean
    private InsuranceService insuranceService;

	 @Test
	    void 보험_리스트_페이지_테스트() throws Exception {
	        // given: 가짜 보험 리스트
	        List<Insurance> mockList = List.of(
	                Insurance.builder().productNo(1L).productName("보험A").build(),
	                Insurance.builder().productNo(2L).productName("보험B").build()
	        );

	        when(insuranceService.getList()).thenReturn(mockList);

	        // when & then
	        mockMvc.perform(get("/admin/insurance/list"))
	                .andExpect(status().isOk())
	                // 뷰 이름 검증
	                .andExpect(view().name("admin/insurances_list"))
	                // 모델 데이터 검증
	                .andExpect(model().attributeExists("insurances"))
	                .andExpect(model().attribute("insurances", mockList));
	    }

}
