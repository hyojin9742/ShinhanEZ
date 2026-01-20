package com.shinhanez.admin.controller;

import java.util.List;

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

@Controller
@RequestMapping("/admin/insurance")
public class InsuranceController {    
	
	@Autowired
	private InsuranceService insuranceService;

  
	// 목록
	
	  @GetMapping("/list") public String list(Model model) { List<Insurance>
	  insurances= insuranceService.getList();
	  model.addAttribute("insurances",insurances); return "admin/insurances_list";
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
	
	// 목록2
	@PostMapping("/list2")
	@ResponseBody
	public List<Insurance> list2(@RequestParam String status) {
		List<Insurance> data= insuranceService.getList2(status);
		return data;
	}
	
	
	
	
	
	
	
	

}
