package com.shinhanez.admin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.mapper.CustomerMapper;

/**
 * 고객(보험자) 서비스
 * - 관리자 페이지용 CRUD
 * - 페이징, 검색, 정렬 지원
 */
@Service
public class CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    // 전체 고객 목록 (활성화된 고객만)
    public List<Customer> findAll() {
        return customerMapper.findAll();
    }

    // 페이징 + 검색 + 정렬 목록
    public List<Customer> findByPage(int page, int size, String searchType, String keyword, String sortType) {
        Map<String, Object> params = new HashMap<>();
        params.put("offset", (page - 1) * size);
        params.put("size", size);
        params.put("searchType", searchType);
        params.put("keyword", keyword);
        params.put("sortType", sortType);
        return customerMapper.findByPage(params);
    }

    // 검색 조건에 맞는 고객 수
    public int countBySearch(String searchType, String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("searchType", searchType);
        params.put("keyword", keyword);
        return customerMapper.countBySearch(params);
    }

    // 고객 상세 조회
    public Customer findById(String customerId) {
        return customerMapper.findById(customerId);
    }

    // 고객 ID 중복 체크
    public boolean existsById(String customerId) {
        return customerMapper.existsById(customerId) > 0;
    }

    // 고객 등록
    public int insert(Customer customer) {
        return customerMapper.insert(customer);
    }

    // 고객 수정
    public int update(Customer customer) {
        return customerMapper.update(customer);
    }

    // 고객 비활성화 (삭제 대신)
    public int deactivate(String customerId) {
        return customerMapper.deactivate(customerId);
    }

    // 고객 삭제 (실제 삭제)
    public int delete(String customerId) {
        return customerMapper.delete(customerId);
    }

    // 활성화된 고객 수
    public int count() {
        return customerMapper.count();
    }

    // 키워드로 고객 검색 (통합 검색용)
    public List<Customer> searchByKeyword(String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("searchType", "all");
        params.put("keyword", keyword);
        params.put("offset", 0);
        params.put("size", 10);
        params.put("sortType", "latest");
        return customerMapper.findByPage(params);
    }
}
