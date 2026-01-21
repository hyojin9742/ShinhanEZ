package com.shinhanez.admin.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.service.ContractServiceImpl;
import com.shinhanez.domain.ShezUser;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/contract/*")
@RequiredArgsConstructor
public class ContractController {
	private final ContractServiceImpl service;
	
	private boolean isAdmin(HttpSession session) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        return user != null && "ROLE_ADMIN".equals(user.getRole());
    }
	
	@GetMapping("/list")
	public String moveContact(HttpSession session) {
		if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
		return "/admin/contract_list";
	}
	
	/* ================================== REST 처리 ================================== */
	// 계약 목록 조회
	@GetMapping(value = "/rest" , produces = "application/json")
	public ResponseEntity<Map<String, Object>> showContractList(
				@RequestParam("pageNum") int pageNum,
				@RequestParam("pageSize") int pageSize
			){
		return ResponseEntity.ok(service.readAllList(pageNum, pageSize));
	}
	// 계약 단건 조회
	@GetMapping("/rest/{contractId}")
    public ResponseEntity<Contracts> showOneContract(@PathVariable Integer contractId) {
        return ResponseEntity.ok(service.readOneContract(contractId));
    }
	// 계약 등록
	@PostMapping(value = "/rest/register",consumes = "application/json", produces = "application/json")
	public ResponseEntity<Map<String,Object>> registerContract(@RequestBody Contracts contract) {
	    int registerResult = service.registerContract(contract);
	    return ResponseEntity.status(HttpStatus.CREATED)
	            .body(Map.of("message", "계약 등록 성공","registerResult",registerResult));
	}
	// 계약 수정
	@RequestMapping(value = "/rest/update/{contractId}", method = {RequestMethod.PUT, RequestMethod.PATCH},
			consumes = "application/json", produces = "application/json")
    public ResponseEntity<Map<String, Object>> updateContract(
            @PathVariable Integer contractId,
            @RequestBody Contracts contract) {
        contract.setContractId(contractId);
        int updateResult = service.updateContract(contract);

        return ResponseEntity.ok(Map.of("message", "계약 수정 성공","updateResult",updateResult));
    }
	
	/* ================================== 자동완성 ================================== */
	// 계약자, 피보험자 검색
	@GetMapping(value = "/search/customers", produces = "application/json")
	public ResponseEntity<List<Customer>> searchCustomerByName(@RequestParam String customerName){
		List<Customer> searchResult =  service.searchCustomerByName(customerName);
		return ResponseEntity.ok(searchResult);
	}
	// 상품 검색
	@GetMapping(value = "/search/insurances", produces = "application/json")
	public ResponseEntity<List<Insurance>> searchInsuranceByName(@RequestParam String productName){
		List<Insurance> searchResult =  service.searchInsuranceByName(productName);
		return ResponseEntity.ok(searchResult);
	}
	// 관리자 검색
	@GetMapping(value = "/search/admins", produces = "application/json")
	public ResponseEntity<List<Admins>> searchAdminsByName(@RequestParam String adminName){
		List<Admins> searchResult =  service.searchAdminsByName(adminName);
		return ResponseEntity.ok(searchResult);
	}
	
}
