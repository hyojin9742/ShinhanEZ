package com.shinhanez.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.shinhanez.admin.domain.DashBoard;
import com.shinhanez.admin.service.ContractServiceImpl;
import com.shinhanez.admin.service.DashBoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/dashboard/*")
public class DashBoardController {
	
	@Autowired
	private DashBoardService dashBoardService;
	
    // 년도별 상품 조회
    @GetMapping("/api/list")
    @ResponseBody 
    public List<DashBoard> getInsuranceList(@RequestParam(defaultValue = "ALL") String year
            ) {

        return dashBoardService.allPlan(year);
    }
    
    
    // 년도별 월 조회
    @GetMapping("/api/list2")
    @ResponseBody 
    public List<DashBoard> getInsuranceList2(@RequestParam(defaultValue = "2025") String year) {

        return dashBoardService.monthlyplan(year);
    }
   
    
    // 년도 조회 (셀렉트 생성용)
    @GetMapping("/api/yearlist")
    @ResponseBody
    public List<String> getYears(){
    	return dashBoardService.yearsGet();
    }
    
    
 
    
    // 대쉬보드 하단 최근 계약자 목록
    @GetMapping("/api/allconstracts")
    @ResponseBody 
    public Map<String, Object> getConstractsList(
            @RequestParam(defaultValue = "1") int pageNum) {

        return dashBoardService.getConstractsList(pageNum);
    } 
    // 대쉬보드 하단 최근 계약자 목록
    @GetMapping("/api/allboards")
    @ResponseBody 
    public Map<String, Object> getBoardsList(
            @RequestParam(defaultValue = "1") int pageNum) {

        return dashBoardService.getBoardsList(pageNum);
    } 
    
    
    
    
  	@GetMapping("/api/allcount")
    @ResponseBody
  	public HashMap<String, Integer> allCount() {
  		HashMap<String, Integer> allcount= new HashMap<>();
  		allcount.put("allusers", dashBoardService.allUserCount());
  		allcount.put("allcustomers", dashBoardService.allCustomerCount());
  		allcount.put("allcontracts", dashBoardService.allcontractCount());
  		allcount.put("allboards", dashBoardService.allboardCount());
  		
  		return allcount;
  		
  	};
  	
  	
  	
    
    
    
    
    
    
	
	

}
