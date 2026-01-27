package com.shinhanez.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.service.UserClaimsService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/claims")
public class UserClaimsController {

	private final UserClaimsService userClaimsService;
	
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
	
}
