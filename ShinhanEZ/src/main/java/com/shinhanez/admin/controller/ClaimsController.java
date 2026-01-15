package com.shinhanez.admin.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.service.ClaimsService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/claims")
@RequiredArgsConstructor
public class ClaimsController {

	// Service DI
	private final ClaimsService claimsService;
	
	// 청구 List
	@GetMapping({"/",""})
	public String claimsList(Model model) {
		List<ClaimsDTO> claimsList = claimsService.getClaimList();
		model.addAttribute("list", claimsList);
		return "claims_list";
	} 
	
	// 청구 View
	@GetMapping("/{claimId}")
	public String claimsView(@PathVariable Long claimId, Model model) {
		ClaimsDTO claimsDTO = claimsService.getClaim(claimId);
		model.addAttribute("claimsDTO", claimsDTO);
		return "claims_view";
	}
	
	// 청구 Insert page
	@GetMapping("/insert")
	public String claimsInsertPage(Model model) {
		model.addAttribute("claimsDTO", new ClaimsDTO());
		return "claims_insert";
	}
	
	// 청구 Insert DB저장
	@PostMapping("/insert")
	public String claimsInsert(ClaimsDTO claimsDTO, Model model, RedirectAttributes redirectAttributes) {
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
	    return "claims_insert";
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
	    return "claims_view";
	}
	
	// 청구 delete
	@PostMapping("/{claimId}/delete")
	public String claimsDelete(@PathVariable Long claimId, HttpSession session,RedirectAttributes redirectAttributes) {
		int adminId = (Integer)session.getAttribute("adminId");
		int result = claimsService.deleteClaim(adminId, claimId);
		
		if(result > 0) {
			redirectAttributes.addFlashAttribute("msgType", "success");
			redirectAttributes.addFlashAttribute("msg", "정상 삭제 되었습니다.");
			return "redirect:/admin/claims/list";
		}
		redirectAttributes.addFlashAttribute("msgType", "error");
		redirectAttributes.addFlashAttribute("msg", "삭제 권한이 없습니다.");
		return "redirect:/admin/claims/"+claimId;
	}
}
