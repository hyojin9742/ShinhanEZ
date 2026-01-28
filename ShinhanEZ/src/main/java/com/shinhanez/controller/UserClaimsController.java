package com.shinhanez.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.service.ClaimsService;
import com.shinhanez.service.UserClaimsService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/claims")
public class UserClaimsController {

	private final UserClaimsService userClaimsService;
	private final ClaimsService claimsService;
	
	// 계약 리스트 조회 REST API
	@GetMapping(value = "/contracts", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Contracts> selectContractsByUserId(HttpSession httpSession){
		String userId = (String) httpSession.getAttribute("userId");
		if(userId == null) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
		}		
		return userClaimsService.selectContractsByUserId(userId) ;
	}
	
	// 계약 단건조회 REST API
	@GetMapping(value = "/contracts/{contractId}", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Contracts selectContractDetailByUserId(@PathVariable("contractId") Integer contractId, HttpSession httpSession) {
		String userId = (String) httpSession.getAttribute("userId");
		if(userId == null) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
		}
		return userClaimsService.selectContractDetailByUserId(userId, contractId);
	}
	
	// 청구등록
	@PostMapping(value = "/insert")
	public String insertClaim(
			@ModelAttribute ClaimsDTO claimsDTO,
			HttpSession httpSession,
			RedirectAttributes redirectAttributes) {
		
		String userId = (String) httpSession.getAttribute("userId");
		if(userId == null) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
		}
		int result = userClaimsService.insertClaim(claimsDTO);

		if(result == 0) {
			redirectAttributes.addFlashAttribute("msg", "내용 확인 후 다시 시도해 주세요");
			return "redirect:/page/insurance_claim";			
		}
		redirectAttributes.addFlashAttribute("msg", "청구 등록 완료되었습니다.");
		return "redirect:/pages/insurance_claim";
	}
	
	// 고객 청구리스트 조회
	@GetMapping(value = "/api/list", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<ClaimsDTO>> getClaimsList(HttpSession httpSession){
		String userId = (String) httpSession.getAttribute("userId");
		
		if (userId == null) {
	        return ResponseEntity
	                .status(HttpStatus.UNAUTHORIZED)
	                .build();
	    }
		
		List<ClaimsDTO> list = userClaimsService.getClaimsList(userId);
	    return ResponseEntity.ok(list);
	}
}
