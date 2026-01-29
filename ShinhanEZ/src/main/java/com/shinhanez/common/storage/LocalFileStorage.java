package com.shinhanez.common.storage;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.LocalDate;
import java.util.Set;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
@Component
public class LocalFileStorage implements FileStorage{

	@Value("${upload.root}")
	private String uploadRoot;
	
	// 허용 확장자 (최소 구현)
	private static final Set<String> ALLOWED_EXT = Set.of("pdf", "jpg", "jpeg", "png");
	
	@Override
	public String save(MultipartFile file) {
		
		if(file == null || file.isEmpty()) {
			throw new IllegalArgumentException("업로드 파일이 비어 있습니다.");
		}
		
		// 1. 원본 파일명
		String originName = file.getOriginalFilename();
		
		// 2. 확장자 추출
		String ext = getExtension(originName);
		if(!ALLOWED_EXT.contains(ext)) {
			throw new IllegalArgumentException("허용되지 않은 파일 확장자 입니다 : "+ext);
		}
		
		// 3. 날짜 폴더(yyyy/MM)
		LocalDate now = LocalDate.now();
		String datePath = now.getYear()+"/"+String.format("%02d", now.getMonthValue());
		
		// 4. UUID 파일명 생성
		String uuid = UUID.randomUUID().toString();
		String storedFileName = uuid+"."+ext;
		
		// 5. storageKey 생성 (DB에 저장될 값)
		String storageKey = "claims/"+datePath+"/"+storedFileName;
		
		// 6. 실제 저장 경로
		Path savePath = Paths.get(uploadRoot, storageKey);
		
		try {
			// 7. 디렉토리 없으면 생성
			Files.createDirectories(savePath.getParent());
			
			// 8. 파일 저장
			file.transferTo(savePath.toFile());
		} catch (IOException e) {
			throw new RuntimeException("파일 저장 중 오류 발생", e);
		}
		
		return storageKey;
	}

	@Override
	public InputStream open(String storageKey) {
		try {
			Path path = Paths.get(uploadRoot, storageKey);
			return Files.newInputStream(path, StandardOpenOption.READ);
		} catch (IOException e) {
			throw new RuntimeException("파일을 열 수 없습니다 : "+storageKey , e);
		}
	}

	@Override
	public void delete(String storageKey) {
		try {
			Path path = Paths.get(uploadRoot, storageKey);
			Files.deleteIfExists(path);
		} catch (IOException e) {
			throw new RuntimeException("파일 삭제 실패 : "+ storageKey, e);
		}
		
	}

	private String getExtension(String filename) {
		
		if(filename == null || filename.isBlank()) {
			throw new IllegalArgumentException("파일명이 비어 있습니다.");
		}
		
		int lastDot = filename.lastIndexOf(".");
		if(lastDot == -1 || lastDot == filename.length() -1) {
			throw new IllegalArgumentException("파일 확장자가 없습니다. : " + filename);
		}
		
		return filename.substring(lastDot + 1).toLowerCase();
	}
}
