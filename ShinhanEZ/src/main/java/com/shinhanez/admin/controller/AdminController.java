package com.shinhanez.admin.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.domain.ShezUser;

/**
 * 관리자 컨트롤러
 * - 고객(보험자) CRUD
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private CustomerService customerService;

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

    // 고객 목록
    @GetMapping("/customer/list")
    public String customerList(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        List<Customer> customers = customerService.findAll();
        model.addAttribute("customers", customers);
        return "admin/customer_list";
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

    // 고객 삭제
    @GetMapping("/customer/delete")
    public String customerDelete(@RequestParam String id, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/member/login?error=auth";
        }
        customerService.delete(id);
        return "redirect:/admin/customer/list";
    }
}
