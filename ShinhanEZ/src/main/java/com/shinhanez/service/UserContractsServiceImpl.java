package com.shinhanez.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
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
}
