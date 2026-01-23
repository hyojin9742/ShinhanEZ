package com.shinhanez.admin.controller;

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
	
	
    @GetMapping("/api/list")
    @ResponseBody 
    public List<DashBoard> getInsuranceList(@RequestParam(defaultValue = "ALL") String year
            ) {

        return dashBoardService.allPlan(year);
    }
    
    
    @GetMapping("/api/list2")
    @ResponseBody 
    public List<DashBoard> getInsuranceList2(@RequestParam(defaultValue = "2025") String year) {

        return dashBoardService.monthlyplan(year);
    }
    
    
    @GetMapping("/api/yearlist")
    @ResponseBody
    public List<String> getYears(){
    	return dashBoardService.yearsGet();
    }
    
    
    
    
    
    
	
	

}
