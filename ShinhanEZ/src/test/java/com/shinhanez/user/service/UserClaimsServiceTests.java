package com.shinhanez.user.service;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.service.UserClaimsService;

import lombok.extern.log4j.Log4j2;

@SpringBootTest
@Log4j2
@Transactional
public class UserClaimsServiceTests {

	@Autowired
	private UserClaimsService userClaimsService;
	
	@Test
	void selectContractsByUserId_success() {
		String userId = "user1";
		List<Contracts> list = userClaimsService.selectContractsByUserId(userId);
		list.forEach(contract -> log.info("userId로 계약목록조회......"+contract));
	}
	
	@Test
	void selectContractDetailByUserId_success() {
		// 리스트로 계약하나 확보
		String userId = "user1";
		List<Contracts> list = userClaimsService.selectContractsByUserId(userId);
		Integer contractId = list.get(0).getContractId();
		Contracts contracts = userClaimsService.selectContractDetailByUserId(userId, contractId);
		log.info("userId와 contractId로 뽑아낸 계약......."+contracts);
	}
	
	@Test
	void insertClaim() {
	    ClaimsDTO claimsDTO = new ClaimsDTO();
	    claimsDTO.setCustomerId("C001");
	    claimsDTO.setInsuredId("C001");
	    claimsDTO.setContractId(1L);
	    claimsDTO.setAccidentDate(LocalDate.of(2026, 1, 20));
	    claimsDTO.setClaimAmount(new BigDecimal("150000"));
	    claimsDTO.setDocumentList("진단서, 입원확인서");
	    int result = userClaimsService.insertClaim(claimsDTO);
	    log.info("insert 결과 = {}", result);
	    assertEquals(1, result);
	}
	
}
