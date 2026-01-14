package com.shinhanez.admin.mapper;

import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.math.BigDecimal;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.List;

import javax.sql.DataSource;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.domain.ClaimsDTO;
import lombok.extern.log4j.Log4j2;
@SpringBootTest
@Log4j2
@Transactional
@Rollback(true)
public class ClaimsMapperTests {

	// DB커넥터 주입
	@Autowired DataSource dataSource;
	
	// DB 연결 테스트
	@Test
	public void dbConnect() throws Exception{
		try(Connection conn = dataSource.getConnection()){
			System.out.println("DB 연결테스트......" + conn);
            assertNotNull(conn);
		}
	}
	
	// Mapper 주입
	@Autowired ClaimsMapper claimsMapper;
	
	// [청구 전체 조회]
	@Test
	void ClaimsListTest() {
		List<ClaimsDTO> Claimslist = claimsMapper.getClaimList();
		Claimslist.forEach((claimsDTO) -> {
			log.info("리스트조회......"+claimsDTO);
		});
	}
	
	// [청구 단건 조회]
	@Test
	void ClaimsGetTest() {
		// 임시테스트 Num = claimsId = 1
		Long num = 1L;
		ClaimsDTO claimsDTO = claimsMapper.getClaim(num);
		log.info("단건조회 결과........."+claimsDTO);
	}
	
	// [청구 생성]
    @Test
    void ClaimsInsertTests() {
    	ClaimsDTO claimsDTO = new ClaimsDTO();
    	claimsDTO.setCustomerId("C001");
    	claimsDTO.setInsuredId("C001");
    	claimsDTO.setContractId(1L);
    	// 사고일 (필수)
    	claimsDTO.setAccidentDate(LocalDate.now().minusDays(2)); 
    	// CLAIM_DATE XML에서 SYSDATE
    	// 금액/서류
    	claimsDTO.setClaimAmount(new BigDecimal("500000.00"));
    	claimsDTO.setDocumentList("ID_CARD,ACCIDENT_REPORT");
    	// 미지급 상태
    	claimsDTO.setStatus("PENDING");
    	claimsDTO.setAdminId(1L);
    	//  지급/완료 관련 값은 미지급 = null 
    	claimsDTO.setPaidAt(null);
    	claimsDTO.setPaidAmount(null);
    	claimsDTO.setCompletedAt(null);        
        int result = claimsMapper.insertClaim(claimsDTO);
        log.info("청구추가 결과행.........."+result);
    }
	
	// [청구 수정]
    @Test
    void ClaimUpdateTests() {
    	ClaimsDTO claimsDTO = new ClaimsDTO();
    	// 1번 청구건 수정
    	claimsDTO.setClaimId(1L);
    	claimsDTO.setClaimAmount(new BigDecimal("777777.00"));
    	claimsDTO.setDocumentList("ID_CARD,ACCIDENT_REPORT,EXTRA_DOC");
    	claimsDTO.setStatus("COMPLETED");
    	claimsDTO.setAdminId(2L);
    	
    	int result = claimsMapper.updateClaim(claimsDTO);
    	log.info("업데이트 결과행......."+result);
    	// 1번 수정했으니까 1번 확인 / 기존 Amount 500000
    	log.info("업데이트 확인......."+claimsMapper.getClaim(1L));
    }
    
    
    // [청구 삭제]
    @Test
    void ClaimsDeleteTests() {
    	// 파라미터로 adminId를 받음
    	// 직책인 super 일때만 가능 1=super / 2 != super
    	int adminId = 1;
    	// 삭제 청구id
    	Long claimId = 1L;
    	int result = claimsMapper.deleteClaim(adminId, claimId);
    	log.info("삭제결과........"+result);

    }
    
    
}// end of class
