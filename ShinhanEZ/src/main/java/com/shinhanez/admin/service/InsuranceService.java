package com.shinhanez.admin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.mapper.InsuranceMapper;
import com.shinhanez.domain.Paging;

@Service
public class InsuranceService {
	
	
	@Autowired
	private InsuranceMapper insuranceMapper;
	
	// 전체 게시판
	public List<Insurance> getList(){
		return insuranceMapper.allGet();
	}
	
	// 전체 게시판22
	public List<Insurance> getList2(String status){
		return insuranceMapper.allGet2(status);
	}
	
	
	/**
     * 보험 목록 조회 (검색 + 페이징)
     * @param pageNum 현재 페이지 번호
     * @param status 상태 필터 (ACTIVE, INACTIVE, all)
     * @param keyword 검색어
     */
    public Map<String, Object> getInsuranceList(int pageNum, String status, String keyword) {
        
        int pageSize = 10; // 한 페이지당 보여줄 개수
        int blockSize = 5; // 페이지 네비게이션 블록 크기

        // 1. 검색 조건을 담을 Map 생성
        Map<String, Object> params = new HashMap<>();
        params.put("status", status);
        params.put("keyword", keyword);

        // 2. 전체 데이터 개수 조회 (검색 조건 포함)
        int totalDB = insuranceMapper.countInsurance(params);

        // 3. Paging 객체 생성 (사용자 정의 클래스 활용)
        Paging paging = new Paging(pageNum, pageSize, totalDB, blockSize);

        // 4. SQL 파라미터에 페이징 정보 추가
        // startRow()는 (pageNum-1)*pageSize 값을 반환한다고 가정 (MySQL OFFSET용)
        params.put("pageSize", pageSize);
        params.put("offset", paging.startRow());

        // 5. 실제 데이터 리스트 조회
        List<Insurance> list = insuranceMapper.selectInsuranceList(params);

        // 6. 결과 반환 (Controller가 JSON으로 변환하기 쉽도록 Map 사용)
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("paging", paging);

        return result;
    }
	
	 

	
	
	
	
	// 상세보기
	public Insurance getPlan(Long productNo){
		return insuranceMapper.get(productNo);
	}
	
	// 상품 추가
	public void addPlan(Insurance insurance) {
		insuranceMapper.insert(insurance);
	}
	
	
	// 상품 수정
	public void editPlan(Insurance insurance) {
		insuranceMapper.update(insurance);
	}
	
	

}
