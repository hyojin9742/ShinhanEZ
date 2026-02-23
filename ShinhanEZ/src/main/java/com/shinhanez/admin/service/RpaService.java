package com.shinhanez.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.PaymentDetailDTO;
import com.shinhanez.admin.domain.RpaDTO;
import com.shinhanez.admin.mapper.RpaMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RpaService {
	@Autowired
	private final RpaMapper rpaMapper;
	
	public List<RpaDTO> getContracts() {
        return rpaMapper.contracts();
    }
	public List<RpaDTO> getPayments() {
        return rpaMapper.payments();
    }
	public List<RpaDTO> getClaims() {
        return rpaMapper.claims();
    }
	
	
	

    

}
