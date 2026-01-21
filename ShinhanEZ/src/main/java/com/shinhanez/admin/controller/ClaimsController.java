package com.shinhanez.admin.controller;


import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
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
import com.shinhanez.admin.service.ClaimsService;
import com.shinhanez.admin.service.ContractService;
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
		model.addAttribute("claimsDTO", claimsDTO);
		model.addAttribute("contracts", contracts);
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
		// adminId 세션넣는 작업 끝나면 setter로 변경===================
//	    claimsDTO.setAdminId((Long)session.getAttribute("adminId"));
		// 추후 삭제
	    claimsDTO.setAdminIdx(1L);
		
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
	public String claimsUpdate(@PathVariable Long claimId, ClaimsDTO claimsDTO, Model model, RedirectAttributes redirectAttributes) {
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

			redirectAttributes.addFlashAttribute("msgType", "success");
			redirectAttributes.addFlashAttribute("msg", "정상 삭제 되었습니다.");
			return "redirect:/admin/claims";
	}
	
	// 계약 리스트 조회 REST API
	@GetMapping(value = "/contracts", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Contracts> getContractsByCustomerId(@RequestParam("customerId") String customerId){
		return claimsService.getListContractsByCustomerId(customerId);
	}
	
	// 계약 단건조회 REST API
	@GetMapping(value = "/contracts/{contractId}", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Contracts selectOneContract(@PathVariable("contractId") Integer contractId) {
		return contractService.readOneContract(contractId);
	}
	
	
	
	
} // end of class