package com.shinhanez.admin.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.shinhanez.admin.domain.PaymentDetailDTO;
import com.shinhanez.admin.service.PaymentDetaiService;
import com.shinhanez.admin.service.PaymentService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/rpa")
@RequiredArgsConstructor
public class PaymentRPAController {
	private final PaymentDetaiService paymentDetailService;

    
    @GetMapping("/payments")
    public ResponseEntity<List<PaymentDetailDTO>> getAllPayments() {
        List<PaymentDetailDTO> list = paymentDetailService.getPaymentReport();
        return ResponseEntity.ok(list);
    }

}
