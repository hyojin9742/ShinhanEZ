package com.shinhanez.admin.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.shinhanez.admin.domain.ClaimsDTO;

@Controller
@RequestMapping("/claims/*")
public class ClaimsController {

	@GetMapping("/list")
	public String claimsList(Model model) {
		// FIXME 메서드 만들기
		List<ClaimsDTO> claimsList = null;
		model.addAttribute("list", claimsList);
		return "claims_list";
	} 
	
	// 한개의 청구보기
	@GetMapping("/view")
	public String claimsView(Long claim_id, Model model) {
		// FIXME
		model.addAttribute("claimDTO", null);
		return "claims_view";
	}
	
	// 추가
	
	
	// 수정
	
	// 삭제
	
}
