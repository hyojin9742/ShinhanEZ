package com.shinhanez.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.domain.Paging;
import com.shinhanez.mapper.UserContractsMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserContractsServiceImpl implements UserContractsService {
	private final UserContractsMapper userContractsMapper;

	@Override
	public Customer getCustomerByLoginId(String id) {
		return userContractsMapper.getCustomerByLoginId(id);
	}
	@Override
	public Customer getCutomerByNamePhone(String name, String phone) {
		return userContractsMapper.getCustomerByNamePhone(name, phone);
	}
	@Override
	public List<Customer> getCustomersByName(String name) {
		return userContractsMapper.getCustomersByName(name);
	}
	@Override
	public String newCustomerId() {
		return userContractsMapper.newCustomerId();
	}
	@Override
	public int joinNewCustomer(Customer customer) {
		return userContractsMapper.joinNewCustomer(customer);
	}	
	@Override
	public int userRegisterContracts(Contracts contract) {
		return userContractsMapper.userRegisterContracts(contract);
	}
	@Override
	public Map<String, Object> selectAllContractListByCustomerId(int pageNum, int pageSize, String customerId) {
		int totalDB = userContractsMapper.countContract(customerId);
		Paging pagingObj = new Paging(pageNum, pageSize, totalDB, 5);
		Map<String, Object> paging = new HashMap<>();
		paging.put("paging", pagingObj);
		paging.put("hasPrev", pagingObj.hasPrev());
		paging.put("hasNext", pagingObj.hasNext());
		List<Contracts> allList = userContractsMapper.selectAllContractListByCustomerId(pagingObj.startRow(), pagingObj.endRow(), customerId);
		Map<String, Object> contractLists = new HashMap<>();
		contractLists.put("paging", paging);
		contractLists.put("allList", allList);
		return contractLists;
	}
	@Override
	public int countContractByStatus(String customerId, String contractStatus) {
		return userContractsMapper.countContractByStatus(customerId, contractStatus);
	}
}
