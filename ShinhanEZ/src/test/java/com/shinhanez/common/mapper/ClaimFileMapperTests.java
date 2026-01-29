package com.shinhanez.common.mapper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.common.domain.ClaimFileVO;

import lombok.extern.log4j.Log4j2;

@SpringBootTest
@Log4j2
@Transactional
public class ClaimFileMapperTests {

	@Autowired
	private ClaimFileMapper claimFileMapper;
	
	@Test
	void insert_then_selectByClaimId() {

	    Long claimId = 1L;

	    ClaimFileVO vo = new ClaimFileVO();
	    vo.setClaimId(claimId);
	    vo.setDocType("ETC");
	    vo.setOriginalName("test.pdf");
	    vo.setStorageKey("claims/2026/01/test-uuid.pdf");
	    vo.setContentType("application/pdf");
	    vo.setFileSize(123L);
	    vo.setUploadedBy("user1");

	    // when
	    int inserted = claimFileMapper.insert(vo);
	    // then
	    assertEquals(1, inserted);

	    List<ClaimFileVO> list = claimFileMapper.selectByClaimId(claimId);
	    assertTrue(list.size() >= 1);

	    ClaimFileVO saved = list.get(0);
	    assertEquals("test.pdf", saved.getOriginalName());
	}
	
	@Test
	void insert_then_selectOne() {
	    Long claimId = 1L;

	    ClaimFileVO vo = new ClaimFileVO();
	    vo.setClaimId(claimId);
	    vo.setDocType("ETC");
	    vo.setOriginalName("one.pdf");
	    vo.setStorageKey("claims/2026/01/one-uuid.pdf");
	    vo.setContentType("application/pdf");
	    vo.setFileSize(100L);
	    vo.setUploadedBy("user1");

	    claimFileMapper.insert(vo);

	    ClaimFileVO saved = claimFileMapper.selectByClaimId(claimId).get(0);

	    ClaimFileVO one = claimFileMapper.selectOne(saved.getFileId());
	    org.junit.jupiter.api.Assertions.assertNotNull(one);
	    org.junit.jupiter.api.Assertions.assertEquals(saved.getStorageKey(), one.getStorageKey());
	}
	
	
}
