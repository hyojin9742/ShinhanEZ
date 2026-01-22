package com.shinhanez.domain;

import lombok.Getter;

@Getter
public class Paging {
	int pageNum;
	
	int pageSize;
	int blockSize;
	
	int totalDB;
	int totalPages;
	
	int startPage;
	int endPage;
	
	public Paging(int pageNum, int pageSize, int totalDB, int blockSize) {
		this.pageNum = pageNum;				
		this.pageSize = pageSize;
		this.totalDB = totalDB;
		this.blockSize = blockSize;
		
		totalPages = (int)Math.ceil((double)totalDB/pageSize);
		startPage = (int)(Math.ceil((double)pageNum/blockSize)-1)*blockSize+1;
		endPage = Math.min(startPage+(blockSize-1), totalPages);
	}
	
	public boolean hasPrev() {
		return startPage>1;
	}
	public boolean hasNext() {
		return endPage<totalPages;
	}
	public int startRow() {
		return (pageNum-1)*pageSize;
	}
	public int endRow() {
		return pageNum*pageSize;
	}
}