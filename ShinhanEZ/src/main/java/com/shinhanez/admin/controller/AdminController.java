package com.shinhanez.admin.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.service.AdminService;
import com.shinhanez.domain.UserAdminDetails;

/**
 * 관리자 컨트롤러
 * - 고객(보험자) CRUD
 * - 페이징, 검색, 정렬, ID 중복체크
 */
@Controller
@RequestMapping("/admin")
public class AdminController {
	
	private AdminService adminService;
	
	@Autowired
    public AdminController(AdminService adminService) {
    	this.adminService = adminService;
    }

    // 관리자 메인 (고객 목록)
    @GetMapping({"", "/"})
    public String index() {
        return "admin/index";
    }
    /* Admin 페이지 */
    @GetMapping("/employee")
    public String adminList() {
    	return "admin/admin_list";
    }
    /* 관리자 상세 페이지 */
    @GetMapping("/employee/view")
    public String getAdmin(@RequestParam int adminIdx, Model model, HttpSession session, @AuthenticationPrincipal UserAdminDetails details) {
    	Admins admin = adminService.readOneAdmin(adminIdx, session, details);
    	model.addAttribute("admin",admin);
    	return "admin/admin_view";
    }
    /* ========================================= REST ========================================= */
    // 전체 조회
    @GetMapping(value = "/employee/rest", produces = "application/json")
    public ResponseEntity<Map<String, Object>> showAdminsList(
			@RequestParam int pageNum,
			@RequestParam int pageSize,
			@RequestParam(required = false) String searchType,
			@RequestParam(required = false) String searchKeyword,
			@RequestParam(required = false) String adminRole
		){
    	return ResponseEntity.ok(adminService.readAllAdmins(pageNum, pageSize, searchType,searchKeyword,adminRole));
    }
    // 단건조회
    @GetMapping(value = "/employee/rest/{adminIdx}", produces = "application/json")
    public ResponseEntity<Admins> showOneAdmin(@PathVariable int adminIdx, HttpSession session, @AuthenticationPrincipal UserAdminDetails details){
    	return ResponseEntity.ok(adminService.readOneAdmin(adminIdx, session, details));
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
    public ResponseEntity<Integer> modifyAdmin(@RequestBody Admins admin, @PathVariable Integer adminIdx , HttpSession session, @AuthenticationPrincipal UserAdminDetails details){
    	return ResponseEntity.ok(adminService.modifyAdmin(admin, session, details));
	}
    // 삭제
    @DeleteMapping(value = "/employee/rest/delete/{adminIdx}", produces = "application/json")
    public ResponseEntity<Integer> deleteAdmin(@PathVariable int adminIdx, HttpSession session, @AuthenticationPrincipal UserAdminDetails details){
    	return ResponseEntity.ok(adminService.deleteAdmin(adminIdx, session, details));
    }
}
