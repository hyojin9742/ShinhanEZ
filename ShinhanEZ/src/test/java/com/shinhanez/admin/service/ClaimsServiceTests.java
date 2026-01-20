package com.shinhanez.admin.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.ClaimsCriteria;
import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;

import lombok.extern.log4j.Log4j2;

@SpringBootTest
@Transactional
@Log4j2
public class ClaimsServiceTests {

	@Autowired
	private ClaimsService claimsService;
	
	// 청구 전체 리스트 조회 테스트
	@Test
	void getClaimListTests() {
		ClaimsCriteria claimsCriteria = new ClaimsCriteria();
		claimsCriteria.setPageNum(2);
		claimsCriteria.setPageSize(10);
		List<ClaimsDTO> list = claimsService.getClaimList(claimsCriteria);
		list.forEach((claimsDTO)->{
			log.info("청구리스트 조회테스트........"+claimsDTO);
		});
	}

	// 청구 Count 테스트
	@Test
	void ClaimsTotalCountTests() {
		ClaimsCriteria claimsCriteria = new ClaimsCriteria();
		int total = claimsService.getClaimTotalCount(claimsCriteria);
		log.info("청구 전체 count............"+total);
	}
	
	// 청구 단일 조회 테스트 | 테스트 파라미터 claimsId = 1
	@Test
	void getClaimTests() {
		Long claimsId = 1L;
		ClaimsDTO claimsDTO = claimsService.getClaim(claimsId);
		log.info("청구 단일 조회 테스트.........."+claimsDTO);
	}
	
	// 청구 추가 테스트 
	@Test
	void insertClaimTests() {
    	ClaimsDTO claimsDTO = new ClaimsDTO();
    	claimsDTO.setCustomerId("C001");
    	claimsDTO.setInsuredId("C001");
    	claimsDTO.setContractId(1L);
    	claimsDTO.setAccidentDate(LocalDate.now().minusDays(2)); 
    	claimsDTO.setClaimAmount(new BigDecimal("555555.00"));
    	claimsDTO.setDocumentList("ID_CARD,ACCIDENT_REPORT");
    	claimsDTO.setStatus("PENDING");
    	claimsDTO.setAdminId(1L); 
    	claimsDTO.setPaidAt(null);
    	claimsDTO.setPaidAmount(null);
    	claimsDTO.setCompletedAt(null);
    	
        int result = claimsService.insertClaim(claimsDTO);
        log.info("청구추가 결과행.........."+result);
        log.info("추가된 행 확인......."+claimsService.getClaim(claimsDTO.getClaimId()));
        
	}
	
	// 청구 업데이트 테스트
	@Test
	void updateClaimTests() {
    	ClaimsDTO claimsDTO = new ClaimsDTO();
    	// 1번 청구건 수정
    	claimsDTO.setClaimId(1L);
    	claimsDTO.setClaimAmount(new BigDecimal("777777.00"));
    	claimsDTO.setDocumentList("ID_CARD,ACCIDENT_REPORT,EXTRA_DOC");
    	claimsDTO.setStatus("COMPLETED");
    	claimsDTO.setAdminId(2L);
    	
    	int result = claimsService.updateClaim(claimsDTO);
    	log.info("업데이트 결과행......."+result);
    	// 1번 수정했으니까 1번 확인 / 기존 Amount 500000
    	log.info("업데이트 확인......."+claimsService.getClaim(1L));
	}
	
	// 청구 삭제 테스트
	@Test
	void deleteClaimTests() {
    	// 파라미터로 adminId를 받음
    	// 직책인 super 일때만 가능 1=super / 2 != super
    	int adminId = 1;
    	// 삭제 청구id
    	Long claimId = 1L;
    	int result = claimsService.deleteClaim(adminId, claimId);
    	log.info("삭제결과........"+result);
    	log.info("삭제 행 조회...null이면 성공"+claimsService.getClaim(claimId));
	}
	
	// CID로 계약 조회 테스트
	@Test
	void getListContractsByCustomerIdTests() {
		// 테스트 파라미터 customer_id
    	String customerId = "C001";
    	List<Contracts> list = claimsService.getListContractsByCustomerId(customerId);
    	list.forEach((contracts)->{
    		log.info("customer_id로 조회결과........."+contracts);
    	});
	}
	
} // end of class