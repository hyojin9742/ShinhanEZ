package com.shinhanez.user.controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.service.ClaimsService;
import com.shinhanez.controller.UserClaimsController;
import com.shinhanez.service.UserClaimsService;

@WebMvcTest(controllers = UserClaimsController.class)
@ContextConfiguration(classes = UserClaimsController.class)
public class UserClaimsControllerTests {

	@Autowired
	private MockMvc mockMvc;
	
	@MockBean
	private UserClaimsService userClaimsService;
	@MockBean
	private ClaimsService claimsService;
	
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
	
    @Test
    @DisplayName("세션 userId 없으면 401")
    void list_unauthorized() throws Exception {
        mockMvc.perform(get("/user/claims/api/list")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("세션 userId 있으면 200 + JSON 반환")
    void list_ok() throws Exception {

        ClaimsDTO dto = new ClaimsDTO();
        dto.setClaimId(1L);
        dto.setStatus("PENDING");
        dto.setCustomerName("김민호");
        dto.setInsuredName("김민호");
        dto.setAccidentDate(LocalDate.of(2026, 1, 1));
        dto.setClaimDate(LocalDate.of(2026, 1, 2));
        dto.setClaimAmount(new BigDecimal("500000.00"));
        dto.setAdminName("황청구");

        given(userClaimsService.getClaimsList("user1")).willReturn(List.of(dto));

        mockMvc.perform(get("/user/claims/api/list")
                        .sessionAttr("userId", "user1")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].claimId").value(1))
                .andExpect(jsonPath("$[0].status").value("PENDING"))
                .andExpect(jsonPath("$[0].customerName").value("김민호"))
                .andExpect(jsonPath("$[0].adminName").value("황청구"));
    }
	
}
