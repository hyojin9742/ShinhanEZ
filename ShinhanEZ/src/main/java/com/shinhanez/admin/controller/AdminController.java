package com.shinhanez.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.service.AdminService;
import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.domain.ShezUser;

/**
 * 관리자 컨트롤러
 * - 고객(보험자) CRUD
 * - 페이징, 검색, 정렬, ID 중복체크
 */
@Controller
@RequestMapping("/admin")
public class AdminController {
	
	private AdminService adminService;
    private CustomerService customerService;
    @Autowired
    public AdminController(AdminService adminService, CustomerService customerService) {
    	this.adminService = adminService;
    	this.customerService = customerService;
    }

    // 관리자 권한 체크
    private boolean isAdmin(HttpSession session) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        return user != null && "ROLE_ADMIN".equals(user.getRole());
    }

    // 관리자 메인 (고객 목록)
    @GetMapping({"", "/"})
    public String index(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        List<Customer> customers = customerService.findAll();
        model.addAttribute("customers", customers);
        model.addAttribute("totalCount", customerService.count());
        return "admin/index";
    }
    /* Admin 페이지 */
    @GetMapping("/employee")
    public String adminList() {
    	return "admin/admin_list";
    }
    // 전체 조회
    @GetMapping(value = "/employee/rest", produces = "application/json")
    public ResponseEntity<Map<String, Object>> showAdminsList(
			@RequestParam("pageNum") int pageNum,
			@RequestParam("pageSize") int pageSize
		){
    	return ResponseEntity.ok(adminService.readAllAdmins(pageNum, pageSize));
    }
    // 단건조회
    @GetMapping(value = "/employee/rest/{adminIdx}", produces = "application/json")
    public ResponseEntity<Admins> showOneAdmin(@PathVariable int adminIdx){
    	return ResponseEntity.ok(adminService.readOneAdmin(adminIdx));
    }
    // 등록
    @PostMapping(value = "/employee/rest/register",
    		consumes = "application/json", produces = "application/json")
    public ResponseEntity<Integer> registerAdmin(@RequestBody Admins admin, HttpSession session){
    	return ResponseEntity.ok(adminService.registerAdmin(admin, session));
    }
    // 수정
    @RequestMapping(value = "/employee/rest/modify/{adminIdx}", method = {RequestMethod.PUT, RequestMethod.PATCH}
    		,consumes = "application/json", produces = "application/json")
    public ResponseEntity<Integer> modifyAdmin(@RequestBody Admins admin, @PathVariable Integer adminIdx , HttpSession session){
    	return ResponseEntity.ok(adminService.modifyAdmin(admin, session));
	}
    // 삭제
    @DeleteMapping(value = "/employee/rest/delete/{adminIdx}", produces = "application/json")
    public ResponseEntity<Integer> deleteAdmin(@PathVariable int adminIdx, HttpSession session){
    	return ResponseEntity.ok(adminService.deleteAdmin(adminIdx, session));
    }
}
