package com.shinhanez.admin.service;

import java.time.YearMonth;
import java.util.HashMap;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.shinhanez.admin.domain.DashBoard;
import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.mapper.DashBoardMapper;
import com.shinhanez.domain.Paging;

@Service
public class DashBoardService {
	
	@Autowired
	private DashBoardMapper dashBoardMapper;
	
	
	// 연도별 상푼별 조회
	public List<DashBoard> allPlan(String year){
		return dashBoardMapper.allplan(year);
	}
	
	
	// 연도별 월별 조회
	public List<DashBoard> monthlyplan(String year){
		return dashBoardMapper.monthlyplan(year);
	}
	
	
	
	// 계약 건 전체 조회
	public List<DashBoard> allConstract(){
		return dashBoardMapper.allConstract();
	}
	
	
	
	
	
	
	// 이번달 불러오기
	public String getSimpleYearMonth() {
	    return YearMonth.now().toString(); 
	}
	
	// 전체 게시판 페이징, 검색
	public Map<String, Object> getConstractsList(int pageNum) {

		int pageSize = 5;
		int blockSize = 5;
		

		// 검색 조건 파라미터 준비
		Map<String, Object> params = new HashMap<>();
		
		params.put("thisMonth", getSimpleYearMonth());
		// 전체 개수 조회
		int totalDB = dashBoardMapper.countConstracts(params);
		
		

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
		List<DashBoard> list = dashBoardMapper.selectConstractsList(params);

		// 결과 리턴
		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("paging", pagingMap);

		return result;
	}
	
	// 전체 게시판 페이징, 검색
	public Map<String, Object> getBoardsList(int pageNum) {

		int pageSize = 5;
		int blockSize = 5;
		

		// 검색 조건 파라미터 준비
		Map<String, Object> params = new HashMap<>();
		
		params.put("thisMonth", getSimpleYearMonth());
		// 전체 개수 조회
		int totalDB = dashBoardMapper.countBoards(params);
		
		

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
		List<DashBoard> list = dashBoardMapper.selectBoardsList(params);

		// 결과 리턴
		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("paging", pagingMap);

		return result;
	}
	
	
	
	
	
	// 연도 가져오기
	public List<String> yearsGet(){
		return dashBoardMapper.years();
	}
	
	// 전 회원수 불러오기
	public int allUserCount() {
		return dashBoardMapper.allUserCount();
	};
	
	// 전 고객수 불러오기
	public int allCustomerCount() {
		return dashBoardMapper.allCustomerCount();
	};
	
	// 전 계약수 불러오기
	public int allcontractCount() {
		return dashBoardMapper.allcontractCount();
	};
	
	// 전 계약수 불러오기
	public int allboardCount() {
		return dashBoardMapper.allboardCount();
	};
	
	

}
