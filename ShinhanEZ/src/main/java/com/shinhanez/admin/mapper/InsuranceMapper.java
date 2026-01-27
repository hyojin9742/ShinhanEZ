package com.shinhanez.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.shinhanez.admin.domain.Insurance;

@Mapper
public interface InsuranceMapper {

	// 리스트
	List<Insurance> selectInsuranceList(Map<String, Object> params);
	int countInsurance(Map<String, Object> params);

	// 상품 상세 조회, 수정페이지 상세
	Insurance get(Long productNo);

	// 상품 등록
	int insert(Insurance insurance);

	// 상품 수정
	int update(Insurance insurance);

	// 상품 삭제
	int delete(Insurance insurance);
}
