package com.shinhanez.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.annotation.JsonCreator.Mode;
import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.admin.service.InsuranceService;
import com.shinhanez.domain.Paging;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/insurance")
@RequiredArgsConstructor
public class InsuranceController {    
	
	@Autowired
	private InsuranceService insuranceService;

  
	
	  
	// [1] 화면 보여주기 (JSP 이동)
    // 사용자가 메뉴에서 클릭해서 들어오는 주소입니다.
    @GetMapping("/list") 
    public String insurancePage() {
        return "admin/insurances_list"; // views/admin/insurance/list.jsp 로 이동
    }

    // [2] 데이터만 주기 (JSON 반환)
    // 자바스크립트(AJAX)가 몰래 요청하는 주소입니다.
    @GetMapping("/api/list")
    @ResponseBody 
    public Map<String, Object> getInsuranceList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "all") String status,
            @RequestParam(defaultValue = "") String keyword) {

        return insuranceService.getInsuranceList(pageNum, status, keyword);
    }
      
	
	//상세보기
	@GetMapping("/get")
	public String get(@RequestParam Long productNo,Model model ) {
		Insurance insurance= insuranceService.getPlan(productNo);
		model.addAttribute("insurance",insurance);
		return "admin/insurances_view";
	}
	// 상품등록 페이지 이동
	@GetMapping("/register")
	public String registePage() {
		return "admin/insurances_register";
	}
	// 상품등록	
	@PostMapping("/register")
	public String registe(Insurance insurance) {
		insuranceService.addPlan(insurance);
		return "redirect:/admin/insurance/list";
	}
	// 상품 수정페이지 이동
	@GetMapping("/edit")
	public String edit(@RequestParam Long productNo,Model model ) {
		Insurance insurance= insuranceService.getPlan(productNo);
		model.addAttribute(insurance);
		return "admin/insurances_edit";
	}
	// 상품 수정	
	@PostMapping("/edit")
	public String edit(Insurance insurance) {
		
		insuranceService.editPlan(insurance);
		return "redirect:/admin/insurance/list";
	}
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	

}
