package com.shinhanez.admin.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.admin.service.ContractService;
import com.shinhanez.admin.service.InsuranceService;
import com.shinhanez.admin.service.BoardService;

/**
 * 관리자 통합 검색 컨트롤러
 */
@Controller
@RequestMapping("/admin/search")
public class AdminSearchController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private ContractService contractService;

    @Autowired
    private InsuranceService insuranceService;

    @Autowired
    private BoardService boardService;

    /**
     * 통합 검색 결과 페이지
     */
    @GetMapping("")
    public String search(@RequestParam(required = false) String keyword,
                        HttpSession session, Model model) {

        // 관리자 체크
        if (session.getAttribute("adminId") == null) {
            return "redirect:/member/login";
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            return "redirect:/admin/index";
        }

        model.addAttribute("keyword", keyword);

        // 고객 검색
        List<?> customers = customerService.searchByKeyword(keyword);
        model.addAttribute("customers", customers);
        model.addAttribute("customerCount", customers != null ? customers.size() : 0);

        // 계약 검색
        List<?> contracts = contractService.searchByKeyword(keyword);
        model.addAttribute("contracts", contracts);
        model.addAttribute("contractCount", contracts != null ? contracts.size() : 0);

        // 상품 검색
        List<?> products = insuranceService.searchByKeyword(keyword);
        model.addAttribute("products", products);
        model.addAttribute("productCount", products != null ? products.size() : 0);

        // 공지사항 검색
        List<?> notices = boardService.searchByKeyword(keyword);
        model.addAttribute("notices", notices);
        model.addAttribute("noticeCount", notices != null ? notices.size() : 0);

        return "admin/search_result";
    }

    /**
     * 통합 검색 API (AJAX용)
     */
    @GetMapping("/api")
    @ResponseBody
    public Map<String, Object> searchApi(@RequestParam String keyword, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        if (session.getAttribute("adminId") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        if (keyword == null || keyword.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "검색어를 입력하세요.");
            return result;
        }

        try {
            // 각 카테고리별 검색 (최대 5개씩)
            List<?> customers = customerService.searchByKeyword(keyword);
            List<?> contracts = contractService.searchByKeyword(keyword);
            List<?> products = insuranceService.searchByKeyword(keyword);
            List<?> notices = boardService.searchByKeyword(keyword);

            result.put("success", true);
            result.put("customers", customers != null ? customers.subList(0, Math.min(5, customers.size())) : new ArrayList<>());
            result.put("contracts", contracts != null ? contracts.subList(0, Math.min(5, contracts.size())) : new ArrayList<>());
            result.put("products", products != null ? products.subList(0, Math.min(5, products.size())) : new ArrayList<>());
            result.put("notices", notices != null ? notices.subList(0, Math.min(5, notices.size())) : new ArrayList<>());

            int totalCount = (customers != null ? customers.size() : 0)
                           + (contracts != null ? contracts.size() : 0)
                           + (products != null ? products.size() : 0)
                           + (notices != null ? notices.size() : 0);
            result.put("totalCount", totalCount);

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }
}
