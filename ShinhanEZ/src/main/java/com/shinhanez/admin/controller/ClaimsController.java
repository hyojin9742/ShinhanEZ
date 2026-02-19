package com.shinhanez.admin.controller;


import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.shinhanez.admin.domain.ClaimsCriteria;
import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.service.ClaimsService;
import com.shinhanez.admin.service.ContractService;
import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.common.domain.ClaimFileVO;
import com.shinhanez.common.service.ClaimFileService;
import com.shinhanez.common.storage.FileStorage;
import com.shinhanez.domain.Paging;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/admin/claims")
@RequiredArgsConstructor
@Log4j2
public class ClaimsController {

	// Claims Service DI
	private final ClaimsService claimsService;
	// Contracts Serivce DI
	private final ContractService contractService;
	// Customer Service DI
	private final CustomerService customerService;
	// ClaimFile Service DI
	private final ClaimFileService claimFileService;
	// FileStorage DI
	private final FileStorage fileStorage;
	
	
	// 청구 List
	@GetMapping({"/",""})
	public String claimsList(ClaimsCriteria claimsCriteria, Model model) {
		int totalCount = claimsService.getClaimTotalCount(claimsCriteria);
	    int start = (claimsCriteria.getPageNum() - 1) * claimsCriteria.getPageSize() + 1;
	    int end = Math.min(claimsCriteria.getPageNum() * claimsCriteria.getPageSize(), totalCount);
		Paging paging = new Paging(
				claimsCriteria.getPageNum(), 
				claimsCriteria.getPageSize(), 
				totalCount, 
				10);
		List<ClaimsDTO> claimsList = claimsService.getClaimList(claimsCriteria);
		model.addAttribute("list", claimsList);
		model.addAttribute("paging", paging);
		model.addAttribute("claimsCriteria", claimsCriteria);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("startRow", totalCount == 0 ? 0 : start);
	    model.addAttribute("endRow", end);
		return "admin/claims_list";
	} 
	
	// 청구 View
	@GetMapping("/{claimId}")
	public String claimsView(@PathVariable Long claimId, Model model) {
		ClaimsDTO claimsDTO = claimsService.getClaim(claimId);
		Integer contractId = Math.toIntExact(claimsDTO.getContractId()); 
		Contracts contracts = contractService.readOneContract(contractId);
		String customerId = contracts.getCustomerId();
		Customer customer = customerService.findById(customerId);
		model.addAttribute("claimsDTO", claimsDTO);
		model.addAttribute("contracts", contracts);
		model.addAttribute("customer", customer);
		// 다운로드 추가
		model.addAttribute("claimFiles", claimFileService.getFilesByClaimId(claimId));
		return "admin/claims_view";
	}
	
	// 청구 Insert page
	@GetMapping("/insert")
	public String claimsInsertPage(Model model) {
		model.addAttribute("claimsDTO", new ClaimsDTO());
		return "admin/claims_insert";
	}
	
	// 청구 Insert DB저장
	@PostMapping("/insert")
	public String claimsInsert(ClaimsDTO claimsDTO, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
	    claimsDTO.setAdminIdx((int)session.getAttribute("adminIdx"));
		int result = claimsService.insertClaim(claimsDTO);
	    // 성공: 생성된 글 상세로 이동
	    if (result > 0) {
	        redirectAttributes.addFlashAttribute("msgType", "success"); 
	        redirectAttributes.addFlashAttribute("msg", "청구 등록 되었습니다."); 
	        return "redirect:/admin/claims/" + claimsDTO.getClaimId();
	    }
	    // 실패: 다시 작성 화면으로 forward
	    model.addAttribute("claimsDTO", claimsDTO);
	    model.addAttribute("msgType", "error");
	    model.addAttribute("msg", "청구 등록에 실패했습니다. 다시 확인해 주세요.");
	    return "admin/claims_insert";
	}
	
	// 청구 update
	@PostMapping("/{claimId}/update")
	public String claimsUpdate(@PathVariable Long claimId, ClaimsDTO claimsDTO, Model model, RedirectAttributes redirectAttributes, HttpSession httpSession) {
		
		claimsDTO.setAdminIdx((Integer)httpSession.getAttribute("adminIdx"));
		// 혹시 모를 다른글 수정 방지를 위한 글확정 코드
		claimsDTO.setClaimId(claimId);
		
		int result = claimsService.updateClaim(claimsDTO);
		
		if(result > 0) {
	        redirectAttributes.addFlashAttribute("msgType", "success"); 
	        redirectAttributes.addFlashAttribute("msg", "청구 수정 되었습니다."); 
	        return "redirect:/admin/claims/" + claimsDTO.getClaimId();
		}
		model.addAttribute("claimsDTO", claimsDTO);
	    model.addAttribute("msgType", "error");
	    model.addAttribute("msg", "청구 수정에 실패했습니다. 다시 확인해 주세요.");
	    return "admin/claims_view";
	}
	
	// 청구 delete
	@PostMapping("/{claimId}/delete")
	public String claimsDelete(@PathVariable Long claimId, HttpSession session,RedirectAttributes redirectAttributes) {
		Integer adminIdx = (Integer)session.getAttribute("adminIdx");
		
		if (adminIdx == null) {
			redirectAttributes.addFlashAttribute("msgType", "error");
			redirectAttributes.addFlashAttribute("msg", "삭제 권한이 없습니다.");
			return "redirect:/admin/claims";
		}
		
		int result = claimsService.deleteClaim(adminIdx, claimId);
		
		if(result != 0 ) {
			redirectAttributes.addFlashAttribute("msgType", "success");
			redirectAttributes.addFlashAttribute("msg", "정상 삭제 되었습니다.");
			return "redirect:/admin/claims";			
		}		
		redirectAttributes.addFlashAttribute("msgType", "error");
		redirectAttributes.addFlashAttribute("msg", "삭제 권한이 없습니다.");
		return "redirect:/admin/claims";			

	}
	
	// 계약 리스트 조회 REST API
	@GetMapping(value = "/contracts", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Contracts> getContractsByPhone(@RequestParam("phone") String phone){
		return claimsService.getListContractsByCustomerId(claimsService.findCustomerByPhone(phone).getCustomerId());
	}
	
	// 계약 단건조회 REST API
	@GetMapping(value = "/contracts/{contractId}", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> selectOneContract(@PathVariable("contractId") Integer contractId) {
		Map<String, Object> map = new HashMap<>();
		Contracts contract = contractService.readOneContract(contractId);
	    map.put("contract", contract);
	    Customer customer = null;
	    if (contract != null) {
	        customer = customerService.findById(contract.getCustomerId());
	    }
	    return Map.of(
	        "contract", contract,
	        "customer", customer
	    );
	}
	
	// 청구고객의 서류 목록 조회
	@GetMapping("/{claimId}/files")
	@ResponseBody
	public ResponseEntity<List<ClaimFileVO>> list(@PathVariable Long claimId){
		return ResponseEntity.ok(claimFileService.getFilesByClaimId(claimId));
	}
	
	// 서류 다운로드
	@GetMapping("/{claimId}/files/{fileId}/download")
	public ResponseEntity<Resource> download(
			@PathVariable Long claimId,
			@PathVariable Long fileId){
		
		// 1. 메타 조회
		ClaimFileVO file = claimFileService.getFile(fileId);
		if(file == null) {
			return ResponseEntity.notFound().build();
		}
		
		// 2. claimId 일치 검증
		if(!claimId.equals(file.getClaimId())) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
		}
		
		// 3. 삭제 여부 체크
		if("Y".equalsIgnoreCase(file.getIsDeleted())) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
		}
		
		// 4. 파일 스트림 오픈
		InputStream is = fileStorage.open(file.getStorageKey());
		Resource resource = new InputStreamResource(is);
		
		// 5. 헤더 구성
		String originName = (file.getOriginalName() == null || file.getOriginalName().isBlank())
				? "download" : file.getOriginalName();
		
		HttpHeaders headers =new HttpHeaders();
		
		// content-type
		String ct = (file.getContentType() == null || file.getContentType().isBlank())
				? MediaType.APPLICATION_OCTET_STREAM_VALUE
				:file.getContentType();
		headers.setContentType(MediaType.parseMediaType(ct));
				
		// Content-Disposition (UTF-8)
		headers.setContentDisposition(ContentDisposition.attachment()
				.filename(originName, StandardCharsets.UTF_8)
				.build());
		
		// Content-Length
		if(file.getFileSize() != null) {
			headers.setContentLength(file.getFileSize());
		}
		
		return new ResponseEntity<>(resource, headers, HttpStatus.OK);
	}
	
	
} // end of class