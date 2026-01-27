package com.shinhanez.user.service;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.service.UserClaimsService;

import lombok.extern.log4j.Log4j2;

@SpringBootTest
@Log4j2
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
	
}
