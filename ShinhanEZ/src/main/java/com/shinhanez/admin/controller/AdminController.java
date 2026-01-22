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
    @RequestMapping(value = "/employee/rest/modify", method = {RequestMethod.PUT, RequestMethod.PATCH}
    		,consumes = "application/json", produces = "application/json")
    public ResponseEntity<Integer> modifyAdmin(@RequestBody Admins admin, HttpSession session){
    	return ResponseEntity.ok(adminService.modifyAdmin(admin, session));
	}
    // 삭제
    @DeleteMapping(value = "employee/rest/delete/{adminIdx}", produces = "application/json")
    public ResponseEntity<Integer> deleteAdmin(@PathVariable int adminIdx, HttpSession session){
    	return ResponseEntity.ok(adminService.deleteAdmin(adminIdx, session));
    }
    
    /* Customer Controller 이동 */
    // 고객 목록 (페이징 + 검색 + 정렬)
    @GetMapping("/customer/list")
    public String customerList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "latest") String sortType,
            HttpSession session, Model model) {

        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }

        // 고객 목록 조회
        List<Customer> customers = customerService.findByPage(page, size, searchType, keyword, sortType);
        int totalCount = customerService.countBySearch(searchType, keyword);

        // 페이징 계산
        int totalPages = (int) Math.ceil((double) totalCount / size);
        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPages);

        model.addAttribute("customers", customers);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sortType", sortType);

        return "admin/customer_list";
    }
    
    // 고객 등록 폼
    @GetMapping("/customer/register")
    public String customerRegisterForm(HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        return "admin/customer_register";
    }

    // 고객 등록 처리
    @PostMapping("/customer/register")
    public String customerRegister(Customer customer,
            @RequestParam String passwordConfirm,
            HttpSession session, Model model) {

        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }

        // 비밀번호 확인
        if (!customer.getPassword().equals(passwordConfirm)) {
            model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
            model.addAttribute("customer", customer);
            return "admin/customer_register";
        }

        // ID 중복 체크
        if (customerService.existsById(customer.getCustomerId())) {
            model.addAttribute("error", "이미 존재하는 고객 ID입니다.");
            model.addAttribute("customer", customer);
            return "admin/customer_register";
        }

        customerService.insert(customer);
        return "redirect:/admin/customer/list";
    }

    // 고객 ID 중복 체크 (AJAX)
    @GetMapping("/customer/checkId")
    @ResponseBody
    public Map<String, Object> checkCustomerId(@RequestParam String customerId) {
        Map<String, Object> result = new HashMap<>();
        boolean exists = customerService.existsById(customerId);
        result.put("exists", exists);
        result.put("message", exists ? "이미 사용 중인 ID입니다." : "사용 가능한 ID입니다.");
        return result;
    }

    // 고객 상세
    @GetMapping("/customer/view")
    public String customerView(@RequestParam String id, HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        Customer customer = customerService.findById(id);
        model.addAttribute("customer", customer);
        return "admin/customer_view";
    }

    // 고객 수정 폼
    @GetMapping("/customer/edit")
    public String customerEditForm(@RequestParam String id, HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        Customer customer = customerService.findById(id);
        model.addAttribute("customer", customer);
        return "admin/customer_edit";
    }

    // 고객 수정 처리
    @PostMapping("/customer/edit")
    public String customerEdit(Customer customer, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        customerService.update(customer);
        return "redirect:/admin/customer/view?id=" + customer.getCustomerId();
    }

    // 고객 삭제 (비활성화 처리)
    @GetMapping("/customer/delete")
    public String customerDelete(@RequestParam String id, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        customerService.deactivate(id);
        return "redirect:/admin/customer/list";
    }
}
