package com.shinhanez.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.Payment;

/**
 * 납입내역 Mapper 인터페이스
 */
@Mapper
public interface PaymentMapper {
    
    // 페이징 + 검색 조회
    List<Payment> findAllWithPaging(Map<String, Object> params);
    
    // 총 건수 (검색 포함)
    int countWithSearch(Map<String, Object> params);
    
    // 단건 조회
    Payment findById(@Param("paymentId") Long paymentId);
    
    // 등록
    int insert(Payment payment);
    
    // 수정
    int update(Payment payment);
    
    // 삭제
    int delete(@Param("paymentId") Long paymentId);
    
    // 상태별 건수
    int countByStatus(@Param("status") String status);
}
