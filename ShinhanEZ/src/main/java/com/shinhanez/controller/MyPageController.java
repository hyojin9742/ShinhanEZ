package com.shinhanez.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.domain.Payment;
import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.admin.service.PaymentService;
import com.shinhanez.domain.ShezUser;
import com.shinhanez.domain.UserAdminDetails;
import com.shinhanez.service.UserContractsService;

import lombok.extern.slf4j.Slf4j;

/**
 * 마이페이지 컨트롤러
 */
@Controller
@RequestMapping("/mypage")
@Slf4j
public class MyPageController {

    @Autowired
    private PaymentService paymentService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private UserContractsService userContractService;

    /* TODO | 마이페이지 메인 */
    /**
     * 마이페이지 메인 | 납입내역 (결제 목록)
     */
    @GetMapping("/mypage")
    public String payments(Authentication authentication, Model model) {

        // 전체 납입내역 조회 (실제로는 해당 사용자의 계약에 대한 납입내역만 조회해야 함)
        List<Payment> payments = paymentService.findAllWithPaging(1, 20, null, null, null);

        // 대기/연체 건수
        int pendingCount = paymentService.countByStatus("PENDING");
        int overdueCount = paymentService.countByStatus("OVERDUE");

        model.addAttribute("payments", payments);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("overdueCount", overdueCount);
        
        // 계약 건수 바인딩
        ShezUser user = null;
        if (authentication != null) {
        	Object principal = authentication.getPrincipal(); 
        	
        	if (principal instanceof UserAdminDetails) { 
        		// 폼 로그인 사용자 
        		user = ((UserAdminDetails) principal).getUser();
        		log.info("userID => " + user.getId());
    		} else if (principal instanceof OAuth2User) { 
    			// OAuth2 로그인 사용자 
    			OAuth2User oauth2User = (OAuth2User) principal;
    			String email = oauth2User.getAttribute("email");
    			user = new ShezUser();
    			user.setId(email);
			} 
    	}
        Customer authCustomer = userContractService.getCustomerByLoginId(user.getId());
        String authCustomerId = authCustomer.getCustomerId();
        int pendingContract = userContractService.countContractByStatus(authCustomerId, "대기");
        int cancelledContract = userContractService.countContractByStatus(authCustomerId, "해지");
        int expiredContract = userContractService.countContractByStatus(authCustomerId, "만료");
        int activeContract = userContractService.countContractByStatus(authCustomerId, "활성");
        model.addAttribute("pendingContract",pendingContract);
        model.addAttribute("cancelledContract",cancelledContract);
        model.addAttribute("expiredContract",expiredContract);
        model.addAttribute("activeContract",activeContract);

        return "mypage/mypage";
    }
	// 계약 목록 조회
	@GetMapping(value = "/rest/contractList" , produces = "application/json")
	public ResponseEntity<Map<String, Object>> showContractList(
				@RequestParam int pageNum,
				@RequestParam int pageSize,
				Authentication authentication
			){
		ShezUser user = null;
        if (authentication != null) {
        	Object principal = authentication.getPrincipal(); 
        	
        	if (principal instanceof UserAdminDetails) { 
        		// 폼 로그인 사용자 
        		user = ((UserAdminDetails) principal).getUser();
        		log.info("userID => " + user.getId());
    		} else if (principal instanceof OAuth2User) { 
    			// OAuth2 로그인 사용자 
    			OAuth2User oauth2User = (OAuth2User) principal;
    			String email = oauth2User.getAttribute("email");
    			user = new ShezUser();
    			user.setId(email);
			} 
    	}
        Customer authCustomer = userContractService.getCustomerByLoginId(user.getId());
        String authCustomerId = authCustomer.getCustomerId();
		return ResponseEntity.ok(userContractService.selectAllContractListByCustomerId(pageNum, pageSize, authCustomerId));
	}
}
