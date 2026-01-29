package com.shinhanez.common.storage;

import java.io.InputStream;

import org.springframework.web.multipart.MultipartFile;

public interface FileStorage {

    /** 파일 저장 후, DB에 저장할 storageKey(상대키) 반환 */
    String save(MultipartFile file);

    /** storageKey로 파일 읽기 (다운로드 스트리밍용) */
    InputStream open(String storageKey);

    /** storageKey로 파일 삭제 (실패 시 정리/소프트삭제 연동) */
    void delete(String storageKey);
	
}
