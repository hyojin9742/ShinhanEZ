package com.shinhanez.common.service;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.shinhanez.common.domain.ClaimFileVO;
import com.shinhanez.common.mapper.ClaimFileMapper;

import lombok.extern.log4j.Log4j2;

@SpringBootTest
@Transactional
@Log4j2
public class ClaimFileServiceTests {

	@Autowired
	ClaimFileService claimFileService;
	
	@Autowired
	ClaimFileMapper claimFileMapper;
	
	@Test
	void uploadFiles_success() throws Exception {

	    Long claimId = 1L; // 반드시 DB에 존재하는 claim_id
	    String uploadedBy = "user1";

	    MockMultipartFile file1 = new MockMultipartFile(
	            "files",
	            "test1.pdf",
	            "application/pdf",
	            "PDF FILE CONTENT".getBytes()
	    );

	    MockMultipartFile file2 = new MockMultipartFile(
	            "files",
	            "test2.jpg",
	            "image/jpeg",
	            "IMAGE FILE CONTENT".getBytes()
	    );

	    MultipartFile[] files = { file1, file2 };

	    // when
	    claimFileService.uploadFiles(claimId, files, uploadedBy);

	    // then
	    List<ClaimFileVO> list = claimFileMapper.selectByClaimId(claimId);
	    org.junit.jupiter.api.Assertions.assertEquals(2, list.size());

	    for (ClaimFileVO vo : list) {
	        log.info("saved file = {}", vo.getStorageKey());
	        org.junit.jupiter.api.Assertions.assertNotNull(vo.getStorageKey());
	    }
	}
	
}
