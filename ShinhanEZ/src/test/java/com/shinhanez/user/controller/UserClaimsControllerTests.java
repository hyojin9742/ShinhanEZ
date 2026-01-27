package com.shinhanez.user.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.controller.UserClaimsController;
import com.shinhanez.service.UserClaimsService;

@WebMvcTest(controllers = UserClaimsController.class)
@ContextConfiguration(classes = UserClaimsController.class)
public class UserClaimsControllerTests {

	@Autowired
	private MockMvc mockMvc;
	
	@MockBean
	private UserClaimsService userClaimsService;
	
	// 계약 리스트조회 테스트
	// GET /user/claims/contracts
	@Test
	void selectContractsByUserId() throws Exception{
		MockHttpSession session = new MockHttpSession();
        session.setAttribute("userId", "user1");

        mockMvc.perform(get("/user/claims/contracts")
                .session(session))
            .andExpect(status().isOk())
            .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON));
	}
	
	// 계약 단일조회 테스트
	// GET /user/claims/contracts
	@Test
	void selectContractDetailByUserId() throws Exception {
	    MockHttpSession session = new MockHttpSession();
	    session.setAttribute("userId", "user1");
	    int contractId = 1;

	    Contracts c = new Contracts();
        c.setContractId(contractId);
        c.setCustomerId("C001");
        c.setCustomerName("홍길동");
        c.setInsuredId("C001");
        c.setInsuredName("홍길동");
        c.setProductId(5);
        c.setProductName("테스트상품");
        c.setContractCoverage("보장내용");
        c.setPaymentCycle("MONTH");
        c.setContractStatus("ACTIVE");

	    given(userClaimsService.selectContractDetailByUserId("user1", contractId))
	        .willReturn(c);

        mockMvc.perform(get("/user/claims/contracts/{contractId}", contractId)
                .session(session)
                .accept(MediaType.APPLICATION_JSON))
        .andExpect(status().isOk())
        .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
        .andExpect(jsonPath("$.contractId").value(contractId))
        .andExpect(jsonPath("$.customerId").value("C001"))
        .andExpect(jsonPath("$.customerName").value("홍길동"))
        .andExpect(jsonPath("$.productId").value(5))
        .andExpect(jsonPath("$.productName").value("테스트상품"))
        .andExpect(jsonPath("$.contractStatus").value("ACTIVE"));

        // service 호출 검증
        verify(userClaimsService).selectContractDetailByUserId("user1", contractId);
	}
	
}
