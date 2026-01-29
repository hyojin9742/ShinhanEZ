package com.shinhanez.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.domain.ShezUser;
/**
 * 고객 컨트롤러
 * - 고객(보험자) CRUD
 * - 페이징, 검색, 정렬, ID 중복체크
 */
@Controller
@RequestMapping("/admin/customer/*")
public class CustomerController {
    private CustomerService customerService;
    
    @Autowired
    public CustomerController(CustomerService customerService) {
    	this.customerService = customerService;
    }

    // 고객 목록 (페이징 + 검색 + 정렬)
    @GetMapping("/list")
    public String customerList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "latest") String sortType,
            HttpSession session, Model model) {

        // 고객 목록 조회
        List<Customer> customers = customerService.findByPage(page, size, searchType, keyword, sortType);
        int totalCount = customerService.countBySearch(searchType, keyword);

        // 페이징 계산
        int totalPages = (int) Math.ceil((double) totalCount / size);
        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage+(blockSize-1), totalPages);

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
    @GetMapping("/register")
    public String customerRegisterForm() {
        return "admin/customer_register";
    }

    // 고객 등록 처리
    @PostMapping("/register")
    public String customerRegister(Customer customer,
            HttpSession session, Model model) {

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
    @GetMapping("/checkId")
    @ResponseBody
    public Map<String, Object> checkCustomerId(@RequestParam String customerId) {
        Map<String, Object> result = new HashMap<>();
        boolean exists = customerService.existsById(customerId);
        result.put("exists", exists);
        result.put("message", exists ? "이미 사용 중인 ID입니다." : "사용 가능한 ID입니다.");
        return result;
    }

    // 고객 상세
    @GetMapping("/view")
    public String customerView(@RequestParam String id, Model model) {
        Customer customer = customerService.findById(id);
        model.addAttribute("customer", customer);
        return "admin/customer_view";
    }

    // 고객 수정 폼
    @GetMapping("/edit")
    public String customerEditForm(@RequestParam String id, Model model) {
        Customer customer = customerService.findById(id);
        model.addAttribute("customer", customer);
        return "admin/customer_edit";
    }

    // 고객 수정 처리
    @PostMapping("/edit")
    public String customerEdit(Customer customer) {
        customerService.update(customer);
        return "redirect:/admin/customer/view?id=" + customer.getCustomerId();
    }

    // 고객 삭제 (비활성화 처리)
    @GetMapping("/delete")
    public String customerDelete(@RequestParam String id) {

        customerService.deactivate(id);
        return "redirect:/admin/customer/list";
    }
}
