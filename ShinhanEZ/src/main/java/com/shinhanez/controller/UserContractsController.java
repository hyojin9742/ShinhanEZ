package com.shinhanez.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.domain.ShezUser;
import com.shinhanez.domain.UserAdminDetails;
import com.shinhanez.service.ShezUserService;
import com.shinhanez.service.UserContractsService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/userContract/*")
@RequiredArgsConstructor
public class UserContractsController {
	private final ShezUserService shezUserService;
	private final UserContractsService userContractsSevice;
	
	/* ============================================ 보험 신규 계약 부분 ============================================ */
    /* 인증계정 가져오기 */
    @GetMapping("/authInfo")
    @ResponseBody
    public ShezUser authInfo(Authentication authentication) {
        ShezUser user = null;
        if (authentication != null) {
        	Object principal = authentication.getPrincipal(); 
        	
        	if (principal instanceof UserAdminDetails) { 
        		// 폼 로그인 사용자 
        		user = ((UserAdminDetails) principal).getUser(); 
        		
    		} else if (principal instanceof OAuth2User) { 
    			// OAuth2 로그인 사용자 
    			OAuth2User oauth2User = (OAuth2User) principal;
    			String email = oauth2User.getAttribute("email");
    			user = shezUserService.findById(email);
			} 
    	}
        return user;
    }
    @GetMapping("/rest/{id}")
    @ResponseBody
    public Customer getCustomerByLoginId(@PathVariable String id) {
    	return userContractsSevice.getCustomerByLoginId(id);
    }
    @GetMapping("/rest/{name}/{phone}")
    @ResponseBody
    public Customer getCustomerByNamePhone(@PathVariable String name, @PathVariable String phone) {
    	return userContractsSevice.getCutomerByNamePhone(name, phone);
    }
    @GetMapping("/rest/search/insured")
    @ResponseBody
    public List<Customer> GetCustomersByName(@RequestParam String name) {
    	return userContractsSevice.getCustomersByName(name);
    }
    @GetMapping("/rest/newCustomerId")
    @ResponseBody
    public String newCusomerId() {
    	return userContractsSevice.newCustomerId();
    }
    @PostMapping("/rest/registerCustomer")
    @ResponseBody
    public Map<String, Object> registerNewCustomer(@RequestBody Customer customer) {
    	customer.setRole("Y");
    	int result = userContractsSevice.joinNewCustomer(customer);
    	Map<String, Object> resultMap = new HashMap<>();
    	resultMap.put("customerId", customer.getCustomerId());
    	resultMap.put("result",result);
    	return resultMap;
    }
    @PostMapping("/rest/registerInsured")
    @ResponseBody
    public Map<String, Object> registerNewInsured(@RequestBody Customer customer) {
    	customer.setRole("Y");
    	int result = userContractsSevice.joinNewCustomer(customer);
    	Map<String, Object> resultMap = new HashMap<>();
    	resultMap.put("insuredId", customer.getCustomerId());
    	resultMap.put("result",result);
    	return resultMap;
    }
    @PostMapping("/rest/userRegisterContract")
    @ResponseBody
    public void userRegisterContract(@RequestBody Contracts contract) {
    	userContractsSevice.userRegisterContracts(contract);
    }
}
