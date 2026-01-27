package com.shinhanez.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.service.InsuranceService;

/**
 * 보험상품 컨트롤러 (사용자용)
 */
@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private InsuranceService insuranceService;

    /**
     * 상품 목록 (추천 상품)
     */
    @GetMapping("/list")
    public String productList(@RequestParam(defaultValue = "1") int page,
                             @RequestParam(required = false) String category,
                             Model model) {

        // 활성화된 상품만 조회
        Map<String, Object> result = insuranceService.getInsuranceList(page, "ACTIVE", null);

        model.addAttribute("products", result.get("list"));
        model.addAttribute("paging", result.get("paging"));
        model.addAttribute("category", category);

        return "product/list";
    }

    /**
     * 상품 상세
     */
    @GetMapping("/detail/{productNo}")
    public String productDetail(@PathVariable Long productNo, Model model) {

        Insurance product = insuranceService.getPlan(productNo);

        if (product == null || !"ACTIVE".equals(product.getStatus())) {
            return "redirect:/product/list";
        }

        model.addAttribute("product", product);

        return "product/detail";
    }

    /**
     * 상품 가입 (결제 페이지로 이동)
     */
    @GetMapping("/subscribe/{productNo}")
    public String subscribe(@PathVariable Long productNo, HttpSession session, Model model) {

        // 로그인 체크
        if (session.getAttribute("loginUser") == null) {
            return "redirect:/member/login?redirect=/product/subscribe/" + productNo;
        }

        Insurance product = insuranceService.getPlan(productNo);

        if (product == null || !"ACTIVE".equals(product.getStatus())) {
            return "redirect:/product/list";
        }

        // 결제 페이지로 리다이렉트 (상품 정보 전달)
        String encodedName = URLEncoder.encode(product.getProductName(), StandardCharsets.UTF_8);
        return "redirect:/payment/checkout?amount=" + product.getBasePremium()
                + "&orderName=" + encodedName
                + "&productNo=" + product.getProductNo();
    }
}
