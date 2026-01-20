package com.shinhanez.admin.domain;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ClaimsCriteria {
	// paging
	private int pageNum = 1;
	private int pageSize = 10;
	
    // ROWNUM 페이징용
    public int getStartRow() {
        return (pageNum - 1) * pageSize;
    }
    
    public int getEndRow() {
        return pageNum * pageSize;
    }
	
	// filter/search
	private String status;
	private LocalDate fromDate;
	private LocalDate toDate;
	private String keyword;
	
	public int getOffset() {
		return (pageNum - 1) * pageSize;
	}
	
	public boolean hasKeyword() {
		return keyword != null && !keyword.trim().isEmpty();
	}
	
	public boolean hasStatus() {
		return status != null && !status.trim().isEmpty();
	}
	
}
