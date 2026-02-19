package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.shinhanez.admin.domain.PaymentDetailDTO;

@Mapper
public interface PaymentDetaiMapper {
	// 모든 고객의 납입 상세 내역 조회
    List<PaymentDetailDTO> paymentDetails();

}
