package com.shinhanez.common.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.shinhanez.common.domain.ClaimFileVO;
import com.shinhanez.common.mapper.ClaimFileMapper;
import com.shinhanez.common.storage.FileStorage;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ClaimFileServiceImpl implements ClaimFileService{
	
    private final ClaimFileMapper claimFileMapper;
    private final FileStorage fileStorage;

    /* 여러 파일 업로드 + 메타 insert */
    @Override
    @Transactional
    public void uploadFiles(Long claimId, MultipartFile[] files, String uploadedBy) {

    	// 파일 없는 경우 그냥 통과
        if (files == null || files.length == 0) {
            return; 
        }
        // 실패 시 정리용
        List<String> savedStorageKeys = new ArrayList<>();

        try {
            for (MultipartFile file : files) {
                // 1) 파일 저장 (로컬)
                String storageKey = fileStorage.save(file);
                savedStorageKeys.add(storageKey);
                // 2) 메타 생성
                ClaimFileVO vo = new ClaimFileVO();
                vo.setClaimId(claimId);
                vo.setDocType("ETC");
                vo.setOriginalName(file.getOriginalFilename());
                vo.setStorageKey(storageKey);
                vo.setContentType(file.getContentType());
                vo.setFileSize(file.getSize());
                vo.setUploadedBy(uploadedBy);
                // 3) DB insert
                claimFileMapper.insert(vo);
            }
        } catch (Exception e) {
            // DB는 @Transactional로 롤백됨
            // 파일은 직접 삭제
            for (String key : savedStorageKeys) {
                try {
                    fileStorage.delete(key);
                } catch (Exception ignore) {
                	
                }
            }
            throw e;
        }
    }

    /* 청구별 파일 목록 조회 */
    @Override
    public List<ClaimFileVO> getFilesByClaimId(Long claimId) {
    	List<ClaimFileVO> list = claimFileMapper.selectByClaimId(claimId);
        return (list == null) ? List.of() : list;
    }

    /* 파일 단건 조회 (다운로드용) */
    @Override
    public ClaimFileVO getFile(Long fileId) {
        return claimFileMapper.selectOne(fileId);
    }
}
