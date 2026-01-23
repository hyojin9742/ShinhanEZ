package com.shinhanez.admin.service;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.ContractSearchCriteria;
import com.shinhanez.admin.domain.Contracts;

import lombok.extern.log4j.Log4j2;

@SpringBootTest
@Transactional
@Log4j2

public class ContractServiceTest {
	private final ContractServiceImpl service;
	@Autowired
	public ContractServiceTest(ContractServiceImpl service) {
		this.service = service;
	}
	
	@Test
	public void serviceDi() {
		log.info("서비스 주입 테스트 : " + service);
	}
	// 계약 목록 조회
	@Test
	public void readAllListTest(ContractSearchCriteria criteria) {
		service.readAllList(1, 10, criteria).forEach(
				(paging,list)->log.info("페이징 : " + paging + "list : "+list)
				);;
	}
	// 계약 단건 조회
	@Test
	public void readOneContractTest() {
		Contracts contract = service.readOneContract(2);
		log.info("계약단건조회 => "+contract);
	}
	// 계약 등록
	@Test
	public void registerContractTest() throws Exception {
		Contracts ct = new Contracts();
		ct.setCustomerId("C005");
		ct.setInsuredId("C001");
		ct.setProductId(2);
		ct.setContractCoverage("암 진단비 보장");
		String strRegDate = "2026-01-15";
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date regDate = sdf.parse(strRegDate);
		ct.setRegDate(regDate);

		String strExpiredDate = "2040-01-30";
		Date expiredDate = sdf.parse(strExpiredDate);
		ct.setExpiredDate(expiredDate);
		ct.setPremiumAmount(70000);
		ct.setPaymentCycle("분기납");
		ct.setContractStatus("활성");
		ct.setAdminIdx(4);
		log.info("등록 테스트 => "+service.registerContract(ct));
	}
	// 계약 수정
	@Test
	public void updateContractTest(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Contracts ctu = new Contracts();
		ctu.setInsuredId("C007");
		ctu.setProductId(4);
		ctu.setContractCoverage("재해 사망 보장");
		ctu.setPremiumAmount(90000);
		ctu.setPaymentCycle("일시납");
		ctu.setContractStatus("해지");
		ctu.setAdminIdx(2);
		ctu.setContractId(5);
		
		log.info("수정 테스트 => "+service.updateContract(ctu,session));
	}
}
