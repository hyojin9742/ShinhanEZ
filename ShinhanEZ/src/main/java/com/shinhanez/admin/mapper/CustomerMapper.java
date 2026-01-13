package com.shinhanez.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.shinhanez.admin.domain.Customer;

/**
 * 고객(보험자) Mapper
 * - 관리자 페이지에서 CRUD
 */
@Mapper
public interface CustomerMapper {
    
    // 전체 고객 목록
    List<Customer> findAll();
    
    // 고객 상세 조회
    Customer findById(String customerId);
    
    // 고객 등록
    int insert(Customer customer);
    
    // 고객 수정
    int update(Customer customer);
    
    // 고객 삭제
    int delete(String customerId);
    
    // 고객 수 카운트
    int count();
}
