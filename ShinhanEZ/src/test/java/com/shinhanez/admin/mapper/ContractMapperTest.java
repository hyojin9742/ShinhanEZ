package com.shinhanez.admin.mapper;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.ContractSearchCriteria;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.mapper.ContractMapper;

import lombok.extern.log4j.Log4j2;



@SpringBootTest
@Transactional
@Log4j2
public class ContractMapperTest {
	private ContractMapper cmapper;
	
	@Autowired
	public ContractMapperTest(ContractMapper cmapper) {
		this.cmapper = cmapper;
	}
	
	@Test
	public void mapperDI() {
		log.info("cmapper 주입 테스트 "+ cmapper );
	}
	
	@Test
	public void allContractListTest(ContractSearchCriteria criteria) {
		cmapper.selectAllContractList(0, 10, criteria).forEach(list -> log.info("전체 목록 조회 => "+list));
	}
	
	@Test
	public void countAllContractsTest(ContractSearchCriteria criteria) {
		int count = cmapper.countAllContracts(criteria);
		log.info("전체 레코드 개수 : "+count);
	}
	
	@Test
	public void getContractTest() {
		Contracts contract = cmapper.selectOneContract(2);
		log.info("2번 계약 조회 => " + contract);
	}
	
	@Test
	public void registerContractTest() throws Exception {
		Contracts ct = new Contracts();
		ct.setCustomerId("C005");
		ct.setInsuredId("C010");
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
		
		log.info("등록 테스트 => "+cmapper.insertContract(ct));
	}
	
	@Test
	public void reviseContractTest() {
		Contracts ctu = new Contracts();
		ctu.setInsuredId("C007");
		ctu.setProductId(4);
		ctu.setContractCoverage("재해 사망 보장");
		ctu.setPremiumAmount(90000);
		ctu.setPaymentCycle("일시납");
		ctu.setContractStatus("해지");
		ctu.setAdminIdx(2);
		ctu.setContractId(5);
		
		log.info("수정 테스트 => "+cmapper.updateContract(ctu));
	}
}
