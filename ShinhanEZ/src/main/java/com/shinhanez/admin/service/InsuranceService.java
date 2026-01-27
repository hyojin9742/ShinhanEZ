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

	// 전체 게시판 페이징, 검색
	public Map<String, Object> getInsuranceList(int pageNum, String status, String keyword) {

		int pageSize = 10;
		int blockSize = 10;

		// 검색 조건 파라미터 준비
		Map<String, Object> params = new HashMap<>();
		params.put("status", status);
		params.put("keyword", keyword);

		// 전체 개수 조회
		int totalDB = insuranceMapper.countInsurance(params);

		// 페이징 계산
		Paging paging = new Paging(pageNum, pageSize, totalDB, blockSize);

		// 수동으로 값 넣어주기
		Map<String, Object> pagingMap = new HashMap<>();
		pagingMap.put("pageNum", paging.getPageNum());
		pagingMap.put("startPage", paging.getStartPage());
		pagingMap.put("endPage", paging.getEndPage());
		pagingMap.put("totalPages", paging.getTotalPages());

		pagingMap.put("hasPrev", paging.hasPrev());
		pagingMap.put("hasNext", paging.hasNext());

		// 페이징 계산
		int startRow = (pageNum - 1) * pageSize + 1;
		int endRow = pageNum * pageSize;

		params.put("startRow", startRow);
		params.put("endRow", endRow);

		// 리스트 조회
		List<Insurance> list = insuranceMapper.selectInsuranceList(params);

		// 결과 리턴
		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("paging", pagingMap);

		return result;
	}

	// 상세보기
	public Insurance getPlan(Long productNo) {
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

	// 키워드로 상품 검색 (통합 검색용)
	public List<Insurance> searchByKeyword(String keyword) {
		Map<String, Object> params = new HashMap<>();
		params.put("keyword", keyword);
		params.put("startRow", 1);
		params.put("endRow", 10);
		return insuranceMapper.selectInsuranceList(params);
	}
}
