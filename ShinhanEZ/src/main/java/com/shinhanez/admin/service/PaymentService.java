package com.shinhanez.admin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.Payment;
import com.shinhanez.admin.mapper.PaymentMapper;

/**
 * 납입내역 서비스
 */
@Service
public class PaymentService {
    
    @Autowired
    private PaymentMapper paymentMapper;
    
    // 페이징 + 검색 조회
    public List<Payment> findAllWithPaging(int page, int pageSize, String status, String searchType, String keyword) {
        Map<String, Object> params = new HashMap<>();
        int startRow = (page - 1) * pageSize;
        int endRow = page * pageSize;
        
        params.put("startRow", startRow);
        params.put("endRow", endRow);
        params.put("status", status);
        params.put("searchType", searchType);
        params.put("keyword", keyword);
        
        return paymentMapper.findAllWithPaging(params);
    }
    
    // 총 건수 (검색 포함)
    public int countWithSearch(String status, String searchType, String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("status", status);
        params.put("searchType", searchType);
        params.put("keyword", keyword);
        
        return paymentMapper.countWithSearch(params);
    }
    
    // 단건 조회
    public Payment findById(Long paymentId) {
        return paymentMapper.findById(paymentId);
    }
    
    // 등록
    public int insert(Payment payment) {
        return paymentMapper.insert(payment);
    }
    
    // 수정
    public int update(Payment payment) {
        return paymentMapper.update(payment);
    }
    
    // 삭제
    public int delete(Long paymentId) {
        return paymentMapper.delete(paymentId);
    }
    
    // 상태별 건수
    public int countByStatus(String status) {
        return paymentMapper.countByStatus(status);
    }

    /**
     * 결제 완료 처리 (토스페이먼츠 연동)
     * @param paymentId 납입 ID
     * @param method 결제 방법
     * @return 업데이트 결과
     */
    public int completePayment(Long paymentId, String method) {
        Payment payment = paymentMapper.findById(paymentId);
        if (payment != null) {
            payment.setStatus("PAID");
            payment.setMethod(method);
            payment.setPaymentDate(new java.util.Date());
            return paymentMapper.update(payment);
        }
        return 0;
    }
}
