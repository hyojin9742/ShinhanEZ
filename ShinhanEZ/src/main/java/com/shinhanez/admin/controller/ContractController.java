package com.shinhanez.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
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
import com.shinhanez.admin.domain.ContractSearchCriteria;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.service.ContractServiceImpl;
import com.shinhanez.domain.ShezUser;
import com.shinhanez.domain.UserAdminDetails;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/admin/contract/*")
@RequiredArgsConstructor
@Log4j2
public class ContractController {
	private final ContractServiceImpl service;
	
	@GetMapping("/list")
	public String contractList() {
		return "/admin/contract_list";
	}
	// 계약 상세 보기
	@GetMapping("/view")
	public String contractView(@RequestParam int contractId, Model model) {
		Contracts contract = service.readOneContract(contractId);
		model.addAttribute("contract",contract);
		return "/admin/contract_view";
	}
	
	/* ================================== REST 처리 ================================== */
	// 계약 목록 조회
	@GetMapping(value = "/rest" , produces = "application/json")
	public ResponseEntity<Map<String, Object>> showContractList(
				@RequestParam int pageNum,
				@RequestParam int pageSize,
				ContractSearchCriteria criteria
			){
		return ResponseEntity.ok(service.readAllList(pageNum, pageSize, criteria));
	}

	// 계약 등록
	@PostMapping(value = "/rest/register",consumes = "application/json", produces = "application/json")
	public ResponseEntity<Map<String,Object>> registerContract(@RequestBody Contracts contract) {
	    int registerResult = service.registerContract(contract);
	    return ResponseEntity.status(HttpStatus.CREATED)
	            .body(Map.of("registerResult",registerResult));
	}
	// 계약 단건 조회
	@GetMapping("/rest/{contractId}")
    public ResponseEntity<Contracts> showOneContract(@PathVariable Integer contractId) {
        return ResponseEntity.ok(service.readOneContract(contractId));
    }
	// 계약 수정
	@RequestMapping(value = "/rest/update/{contractId}", method = {RequestMethod.PUT, RequestMethod.PATCH},
			consumes = "application/json", produces = "application/json")
    public ResponseEntity<Map<String, Object>> updateContract(
            @PathVariable Integer contractId,
            @RequestBody Contracts contract,
            HttpSession session,
            @AuthenticationPrincipal UserAdminDetails details) {
        contract.setContractId(contractId);
        int updateResult = service.updateContract(contract, details);

        return ResponseEntity.ok(Map.of("updateResult",updateResult));
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
	// 상품 번호 보험 검색
	@GetMapping(value = "search/insurances/{productNo}", produces = "application/json")
	public ResponseEntity<Insurance> searchInsuranceById(@PathVariable Long productNo){
		Insurance searchResult =  service.searchInsuranceById(productNo);
		return ResponseEntity.ok(searchResult);
	}
	// 관리자 검색
	@GetMapping(value = "/search/admins", produces = "application/json")
	public ResponseEntity<List<Admins>> searchAdminsByName(@RequestParam String adminName){
		List<Admins> searchResult =  service.searchAdminsByName(adminName);
		return ResponseEntity.ok(searchResult);
	}
	/* ================================== 예외처리 ================================== */
	@ExceptionHandler(IllegalArgumentException.class)
	@ResponseBody
    public ResponseEntity<Map<String, Object>> handleIllegalArgument(
            IllegalArgumentException e, HttpServletRequest request) {

        log.warn("유효성 오류: {}", e.getMessage());
        if (request.getRequestURI().contains("/rest")) {
        	Map<String, Object> response = new HashMap<>();
        	response.put("message", e.getMessage());
        	
        	return ResponseEntity
        			.badRequest()
        			.body(response);        	
        }
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .build();
    }

    @ExceptionHandler(RuntimeException.class)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleRuntime(
            RuntimeException e, HttpServletRequest request) {

        log.error("런타임 오류: {}", e.getMessage());
        if (request.getRequestURI().contains("/rest")) {
        	Map<String, Object> response = new HashMap<>();
        	response.put("message", e.getMessage());
        	
        	return ResponseEntity
        			.status(HttpStatus.INTERNAL_SERVER_ERROR)
        			.body(response);        	
        }
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .build();
    }
}
