package com.shinhanez.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;

public interface UserContractsMapper {
	public Customer getCustomerByLoginId(String id);
	public Customer getCustomerByNamePhone(@Param("name") String name, @Param("phone") String phone);
	public List<Customer> getCustomersByName(String name);
	public String newCustomerId();
	public int joinNewCustomer(Customer customer);
	public int userRegisterContracts(Contracts contract);
}
