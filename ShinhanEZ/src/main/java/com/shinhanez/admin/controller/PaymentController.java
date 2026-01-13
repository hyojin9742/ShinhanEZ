package com.shinhanez.admin.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.shinhanez.admin.domain.Payment;
import com.shinhanez.admin.service.PaymentService;

/**
 * 납입내역 관리 컨트롤러
 */
@Controller
@RequestMapping("/admin/payment")
public class PaymentController {
    
    @Autowired
    private PaymentService paymentService;
    
    private static final int PAGE_SIZE = 10; // 한 페이지당 10개
    
    // 관리자 체크
    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return "ROLE_ADMIN".equals(role);
    }
    
    // 목록 (페이징 + 검색)
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(required = false) String status,
                       @RequestParam(required = false) String searchType,
                       @RequestParam(required = false) String keyword,
                       HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login";
        }
        
        // 데이터 조회
        List<Payment> paymentList = paymentService.findAllWithPaging(page, PAGE_SIZE, status, searchType, keyword);
        int totalCount = paymentService.countWithSearch(status, searchType, keyword);
        
        // 페이징 계산
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        int startPage = ((page - 1) / 10) * 10 + 1;
        int endPage = Math.min(startPage + 9, totalPages);
        
        // Model에 데이터 전달
        model.addAttribute("paymentList", paymentList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("status", status);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        
        return "admin/payment_list";
    }
    
    // 상세 조회
    @GetMapping("/view/{id}")
    public String view(@PathVariable("id") Long paymentId,
                       HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login";
        }
        
        Payment payment = paymentService.findById(paymentId);
        model.addAttribute("payment", payment);
        
        return "admin/payment_view";
    }
    
    // 등록 폼
    @GetMapping("/register")
    public String registerForm(HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/member/login";
        }
        return "admin/payment_register";
    }
    
    // 등록 처리
    @PostMapping("/register")
    public String register(Payment payment, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/member/login";
        }
        
        paymentService.insert(payment);
        return "redirect:/admin/payment/list";
    }
    
    // 수정 폼
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable("id") Long paymentId,
                           HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/member/login";
        }
        
        Payment payment = paymentService.findById(paymentId);
        model.addAttribute("payment", payment);
        
        return "admin/payment_edit";
    }
    
    // 수정 처리
    @PostMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long paymentId,
                       Payment payment, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/member/login";
        }
        
        payment.setPaymentId(paymentId);
        paymentService.update(payment);
        return "redirect:/admin/payment/view/" + paymentId;
    }
    
    // 삭제
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Long paymentId,
                         HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/member/login";
        }
        
        paymentService.delete(paymentId);
        return "redirect:/admin/payment/list";
    }
}
