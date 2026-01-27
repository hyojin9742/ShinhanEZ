package com.shinhanez.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.shinhanez.admin.domain.Payment;
import com.shinhanez.admin.service.PaymentService;
import com.shinhanez.domain.ShezUser;

/**
 * 마이페이지 컨트롤러
 */
@Controller
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    private PaymentService paymentService;

    /**
     * 마이페이지 메인
     */
    @GetMapping("")
    public String mypage(HttpSession session, Model model) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/member/login";
        }
        return "mypage/index";
    }

    /**
     * 납입내역 (결제 목록)
     */
    @GetMapping("/payments")
    public String payments(HttpSession session, Model model) {
        ShezUser user = (ShezUser) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/member/login";
        }

        // 전체 납입내역 조회 (실제로는 해당 사용자의 계약에 대한 납입내역만 조회해야 함)
        List<Payment> payments = paymentService.findAllWithPaging(1, 20, null, null, null);

        // 대기/연체 건수
        int pendingCount = paymentService.countByStatus("PENDING");
        int overdueCount = paymentService.countByStatus("OVERDUE");

        model.addAttribute("payments", payments);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("overdueCount", overdueCount);

        return "mypage/payments";
    }
}
