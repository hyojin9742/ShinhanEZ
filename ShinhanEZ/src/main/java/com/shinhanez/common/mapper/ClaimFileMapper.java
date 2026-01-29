package com.shinhanez.common.mapper;

import java.util.List;


import com.shinhanez.common.domain.ClaimFileVO;

public interface ClaimFileMapper {

    // 1) 파일 메타 1건 insert
    int insert(ClaimFileVO vo);

    // 2) 청구별 파일 목록 조회
    List<ClaimFileVO> selectByClaimId(Long claimId);

    // 3) 파일 단건 조회 (다운로드용)
    ClaimFileVO selectOne(Long fileId);
	
}
