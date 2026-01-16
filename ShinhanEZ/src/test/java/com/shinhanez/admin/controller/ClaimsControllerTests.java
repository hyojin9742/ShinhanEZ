package com.shinhanez.admin.controller;


import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.flash;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import com.shinhanez.admin.domain.ClaimsDTO;
import com.shinhanez.admin.service.ClaimsService;
import com.shinhanez.admin.service.ContractService;

@WebMvcTest(controllers = ClaimsController.class)
@ContextConfiguration(classes = ClaimsController.class)
public class ClaimsControllerTests {

	@Autowired
	private MockMvc mockMvc;
	
	@MockBean
	private ClaimsService claimsService;
	
	// 계약조회서비스 주입
	@MockBean
	private ContractService contractService;
	
	
	
	/* GET /admin/claims"" */ 
	@Test
	void claimsListTests() throws Exception{
		// 테스트용 객체 생성하여 불변 list 생성하여 아이템 할당
		ClaimsDTO claimsDTO1 = new ClaimsDTO();
		ClaimsDTO claimsDTO2 = new ClaimsDTO();
		List<ClaimsDTO> list = List.of(claimsDTO1,claimsDTO2);
		// 메서드가 호출되면 list를 반환
		when(claimsService.getClaimList()).thenReturn(list);
		
/*
		컨트롤러 응답검증 -> get /admin/claims
		  1. HTTP 상태코드 200 OK 확인
		  2. 반환된 뷰 이름이 claims_list인지 확인
		  3. Model 객체에 list라는 이름의 속성이 있는지 확인
		  4. Model에 담긴 list가 서비스에서반환한 list와 동일한지 확인
 * */		
		mockMvc.perform(get("/admin/claims"))
				.andExpect(status().isOk())
				.andExpect(view().name("admin/claims_list"))
				.andExpect(model().attributeExists("list"))
				.andExpect(model().attribute("list", list));
	}
	
	/* GET /admin/claims/ */ 
	@Test
	void claimsListTests2() throws Exception{
		// 테스트용 객체 생성하여 불변 list 생성하여 아이템 할당
		ClaimsDTO claimsDTO1 = new ClaimsDTO();
		ClaimsDTO claimsDTO2 = new ClaimsDTO();
		List<ClaimsDTO> list = List.of(claimsDTO1,claimsDTO2);
		// 메서드가 호출되면 list를 반환
		when(claimsService.getClaimList()).thenReturn(list);
		mockMvc.perform(get("/admin/claims/"))
				.andExpect(status().isOk())
				.andExpect(view().name("admin/claims_list"))
				.andExpect(model().attributeExists("list"))
				.andExpect(model().attribute("list", list));
	}
	
	/* GET /admin/claims/{claimId} */
	@Test
	void claimsViewTests() throws Exception{
		Long claimId = 1L;
		ClaimsDTO claimsDTO = new ClaimsDTO();
		claimsDTO.setClaimId(claimId);
		when(claimsService.getClaim(claimId)).thenReturn(claimsDTO);
		
		mockMvc.perform(get("/admin/claims/{claimId}",claimId))
				.andExpect(status().isOk())
				.andExpect(view().name("admin/claims_view"))
				.andExpect(model().attributeExists("claimsDTO"))
				.andExpect(model().attribute("claimsDTO", claimsDTO));
	}
	
	/* GET /admin/claims/insert */
	@Test
    void claimsInsertPageTests() throws Exception {
        mockMvc.perform(get("/admin/claims/insert"))
               .andExpect(status().isOk())
               .andExpect(view().name("admin/claims_insert"))
               .andExpect(model().attributeExists("claimsDTO"));
    }
	
	/* POST /admin/claims/insert (success) */
    @Test
    void claimInsertSuccessTests() throws Exception {
        // any = post요청으로 온 DTO도 ok // insert 성공의 1 리턴
        when(claimsService.insertClaim(any(ClaimsDTO.class))).thenReturn(1);

        mockMvc.perform(post("/admin/claims/insert")
                    .param("claimId", "100")
               )
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/claims/100"))
               .andExpect(flash().attribute("msgType", "success"))
               .andExpect(flash().attribute("msg", "청구 등록 되었습니다."));
    }
    
	/* POST /admin/claims/insert (error) */
    @Test
    void claimInsertErrorTests() throws Exception {
        // insert 실패의 0 리턴
        when(claimsService.insertClaim(any(ClaimsDTO.class))).thenReturn(0);

        mockMvc.perform(post("/admin/claims/insert")
                    .param("claimId", "100")
               )
               .andExpect(status().isOk())
               .andExpect(view().name("claims_insert"))
               .andExpect(model().attribute("msgType", "error"))
               .andExpect(model().attribute("msg", "청구 등록에 실패했습니다. 다시 확인해 주세요."))
               .andExpect(model().attributeExists("claimsDTO"));
    }

    /* POST /admin/claims/{claimId}/update (success) */
    @Test
    void claimUpdateSuccessTests() throws Exception {
        Long claimId = 10L;
        when(claimsService.updateClaim(any(ClaimsDTO.class))).thenReturn(1);

        mockMvc.perform(post("/admin/claims/{claimId}/update", claimId)
                    .param("status", "COMPLETED")
               )
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/claims/"+claimId))
               .andExpect(flash().attribute("msgType", "success"))
               .andExpect(flash().attribute("msg", "청구 수정 되었습니다."));
    }

    /* POST /admin/claims/{claimId}/update (error) */
    @Test
    void claimUpdateErrorTests() throws Exception {
        Long claimId = 10L;
        when(claimsService.updateClaim(any(ClaimsDTO.class))).thenReturn(0);

        mockMvc.perform(post("/admin/claims/{claimId}/update", claimId)
                    .param("status", "COMPLETED")
               )
               .andExpect(status().isOk())
               .andExpect(view().name("claims_view"))
               .andExpect(model().attribute("msgType", "error"))
               .andExpect(model().attribute("msg", "청구 수정에 실패했습니다. 다시 확인해 주세요."))
               .andExpect(model().attributeExists("claimsDTO"));
    }
    
    /* POST /admin/claims/{claimId}/delete (success) */
    @Test
    void claimDeleteSuccessTests() throws Exception {
        Long claimId = 55L;
        when(claimsService.deleteClaim(eq(1), eq(claimId))).thenReturn(1);

        mockMvc.perform(post("/admin/claims/{claimId}/delete", claimId)
                    .sessionAttr("adminId", 1)
               )
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/claims/list"))
               .andExpect(flash().attribute("msgType", "success"))
               .andExpect(flash().attribute("msg", "정상 삭제 되었습니다."));
    }

    /* POST /admin/claims/{claimId}/delete (error) */
    @Test
    void claimDeleteForbiddenTests() throws Exception {
        Long claimId = 55L;
        // 권한 없음(0) 반환
        when(claimsService.deleteClaim(eq(1), eq(claimId))).thenReturn(0);

        mockMvc.perform(post("/admin/claims/{claimId}/delete", claimId)
                    .sessionAttr("adminId", 1)
               )
               .andExpect(status().is3xxRedirection())
               .andExpect(redirectedUrl("/admin/claims/55"))
               .andExpect(flash().attribute("msgType", "error"))
               .andExpect(flash().attribute("msg", "삭제 권한이 없습니다."));
    }
    
} // end of class