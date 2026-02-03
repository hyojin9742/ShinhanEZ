package com.shinhanez.service;

import java.util.List;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;

public interface UserContractsService {
	public Customer getCustomerByLoginId(String id);
	public Customer getCutomerByNamePhone(String name, String phone);
	public List<Customer> getCustomersByName(String name);
	public String newCustomerId();
	public int joinNewCustomer(Customer customer);
	public int userRegisterContracts(Contracts contract);
}
