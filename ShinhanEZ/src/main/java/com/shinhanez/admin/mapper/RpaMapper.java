package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.shinhanez.admin.domain.RpaDTO;

@Mapper
public interface RpaMapper {
	// 모든 고객의 계약 조회
    List<RpaDTO> contracts();
    List<RpaDTO> payments();
    List<RpaDTO> claims();
    

}
