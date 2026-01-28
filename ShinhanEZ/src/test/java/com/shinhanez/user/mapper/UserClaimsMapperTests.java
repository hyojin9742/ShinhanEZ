package com.shinhanez.user.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.sql.Connection;
import java.time.LocalDate;
import java.util.List;
import java.math.BigDecimal;

import javax.sql.DataSource;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.mapper.UserClaimsMapper;
import com.shinhanez.mapper.ShezUserMapper;

import lombok.extern.log4j.Log4j2;

@SpringBootTest
@Log4j2
@Transactional
public class UserClaimsMapperTests {

	// DB커넥터 주입
	@Autowired DataSource dataSource;
	
	// DB 연결 테스트
	@Test
	public void dbConnect() throws Exception{
		try(Connection conn = dataSource.getConnection()){
			log.info("DB 연결테스트......" + conn);
            assertNotNull(conn);
		}
	}
	
	@Autowired
	private UserClaimsMapper userClaimsMapper ;
	
	@Test
	@DisplayName("계약리스트 : userId로 계약 목록 조회됨")
	void selectContractsByUserId_success() {
		String userId = "user1";
		List<Contracts> list = userClaimsMapper.selectContractsByUserId(userId);
		assertNotNull(list);
		log.info("contracts size = {}", list.size());
		list.forEach(contract -> log.info("userId로 계약목록조회......"+contract));
	}
	
	@Test
	void selectContractDetailByUserId_success() {
		// 리스트로 계약하나 확보
		String userId = "user1";
		List<Contracts> list = userClaimsMapper.selectContractsByUserId(userId);
		Integer contractId = list.get(0).getContractId();
		Contracts contracts = userClaimsMapper.selectContractDetailByUserId(userId, contractId);
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
	    int result = userClaimsMapper.insertClaim(claimsDTO);
	    log.info("insert 결과 = {}", result);
	    assertEquals(1, result);
	}
	
	// 고객 청구 리스트 조회 테스트
	@Test
	void getClaimsListTests() {
		String userId = "user1";
		List<ClaimsDTO> list = userClaimsMapper.getClaimsList(userId);
		list.forEach(claimsDTO ->
		log.info("고객청구 리스트 조회 테스트....."+claimsDTO));
	}
}
