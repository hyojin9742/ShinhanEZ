package com.shinhanez.common.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.shinhanez.common.domain.ClaimFileVO;

public interface ClaimFileService {
	
	// 첨부파일 업로드 : 여러개 저장 + 메타 insert
	void uploadFiles(
			Long claimId,
			MultipartFile[] files,
			String uploadedBy);
	
	// 청구별 첨부파일 목록 조회
	List<ClaimFileVO> getFilesByClaimId(Long claimId);
	
	// 파일 단건 조회 (다운로드용)
	ClaimFileVO getFile(Long fileId);
}
