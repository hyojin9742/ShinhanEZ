package com.shinhanez.admin.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.shinhanez.admin.domain.RpaDTO;
import com.shinhanez.admin.service.RpaService;
import com.shinhanez.admin.service.PaymentService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/rpa")
@RequiredArgsConstructor
public class RpaController {
	private final RpaService rpaService;

    
    @GetMapping("/contracts")
    public ResponseEntity<List<RpaDTO>> getAllConstracts() {
        List<RpaDTO> list = rpaService.getContracts();
        return ResponseEntity.ok(list);
    }
    @GetMapping("/payments")
    public ResponseEntity<List<RpaDTO>> getAllPayments() {
        List<RpaDTO> list = rpaService.getPayments();
        return ResponseEntity.ok(list);
    }
    @GetMapping("/claims")
    public ResponseEntity<List<RpaDTO>> getAllClaims() {
        List<RpaDTO> list = rpaService.getClaims();
        return ResponseEntity.ok(list);
    }

}
