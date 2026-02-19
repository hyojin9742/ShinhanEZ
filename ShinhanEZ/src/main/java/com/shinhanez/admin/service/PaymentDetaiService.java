package com.shinhanez.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.PaymentDetailDTO;
import com.shinhanez.admin.mapper.PaymentDetaiMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PaymentDetaiService {
	@Autowired
	private final PaymentDetaiMapper paymentMapper;
	
	public List<PaymentDetailDTO> getPaymentReport() {
        return paymentMapper.paymentDetails();
    }
	
	
	

    

}
