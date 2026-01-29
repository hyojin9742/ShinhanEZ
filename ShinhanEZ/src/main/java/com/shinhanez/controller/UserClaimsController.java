package com.shinhanez.controller;
/* 사용자 청구(user Claims) 컨트롤러 */
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.service.ClaimsService;
import com.shinhanez.common.service.ClaimFileService;
import com.shinhanez.service.UserClaimsService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/claims")
public class UserClaimsController {

	// DI
	private final UserClaimsService userClaimsService;
	private final ClaimFileService claimFileService;
	
	/*
	[계약 목록 조회 API]
	GET /user/claims/contracts
	  - 청구 등록 화면에서 계약 선택 리스트 구성
	  - 응답 : JSON(List<Contracts>)
	  - 인증 : 세션 userId
	 * */
	@GetMapping(value = "/contracts", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Contracts> selectContractsByUserId(HttpSession httpSession){
		
		String userId = (String) httpSession.getAttribute("userId");
		if(userId == null) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
		}		
		return userClaimsService.selectContractsByUserId(userId) ;
	}
	
	/*
	[계약 상세 조회 API]
	GET /user/claims/contracts/{contractId}
	  - 목적 : 선택한 계약의 상세 정보 조회
	  - 응답 : JSON(Contracts)
	  - 인증 : 세션 userId
	 * */
	@GetMapping(value = "/contracts/{contractId}", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Contracts selectContractDetailByUserId(@PathVariable("contractId") Integer contractId, HttpSession httpSession) {
		
		String userId = (String) httpSession.getAttribute("userId");
		if(userId == null) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
		}
		return userClaimsService.selectContractDetailByUserId(userId, contractId);
	}
	
	/*
	[청구 등록]
	POST /user/claims/insert
	  - 성공 : 마이페이지로 이동
	  - 실패 : 등록 페이지로 redirect
	  
	정책 :
	  - 등록 시점에는 파일 업로드X
	    -> 등록 완료 후 마이페이지에서 첨부
	 * */
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
			return "redirect:/page/user_claim";			
		}
		return "redirect:/mypage/payments";
	}
	
	/*
	[고객 청구 목록 조회 API]
	GET /user/claims/api/list
	  - 응답 : JSON(List<ClaimsDTO>)
	  - 마이페이지에서 AJAX로 청구 리스트 렌더링
	  - 인증 : 세션 userId
	 * */
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
	
	/*
	[청구 서류 업로드 API]
	POST /user/claims/{claimsId}/files (multipart/form-data)
	  - 입력 : files[] (multipartFile)
	  - 처리 : 스토리지 저장 + DB 메타 저장
	  - 응답 : 업로드 완료 후 해당 청구의 파일 목록 반환
	  - 인증 : 세션 userId
	 * */ 
	@PostMapping(value = "/{claimsId}/files", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	@ResponseBody
	public ResponseEntity<?> uploadClaimFiles(
			@PathVariable Long claimsId,
			@RequestParam("files") MultipartFile[] files,
			HttpSession httpSession){
		
		String userId = (String) httpSession.getAttribute("userId");
		if(userId == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
		}
		claimFileService.uploadFiles(claimsId, files, userId);
		 return ResponseEntity.ok(claimFileService.getFilesByClaimId(claimsId));
	}
	
	/*
	[청구 서류 목록 조회 API]
	GET /user/claims/{claimsId}/files
	  - 응답 : JSON
	  - 인증 : 세션 userId
	 * */
	@GetMapping(value = "/{claimsId}/files", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<?> getClaimFiles(
			@PathVariable Long claimsId,
			HttpSession httpSession){
		
		String userId = (String) httpSession.getAttribute("userId");
		if(userId == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
	    }
	    try {
	        return ResponseEntity.ok(claimFileService.getFilesByClaimId(claimsId));
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                .body(e.getClass().getName() + " :: " + e.getMessage());
	    }
	}
	
	
} // end of Controller
