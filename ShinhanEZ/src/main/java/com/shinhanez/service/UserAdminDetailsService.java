package com.shinhanez.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.admin.mapper.AdminMapper;
import com.shinhanez.admin.service.AdminService;
import com.shinhanez.domain.ShezUser;
import com.shinhanez.domain.UserAdminDetails;
import com.shinhanez.mapper.ShezUserMapper;

@Service
public class UserAdminDetailsService implements UserDetailsService{
	
    private final ShezUserMapper userMapper;
    private final AdminMapper adminMapper;
    @Autowired
    public UserAdminDetailsService(ShezUserMapper userMapper, AdminMapper adminMapper) {
    	this.userMapper = userMapper;
    	this.adminMapper = adminMapper;
    }
    
    @Override
    public UserDetails loadUserByUsername(String userid) throws UsernameNotFoundException {

        ShezUser user = userMapper.findById(userid);
        if (user == null) {
            throw new UsernameNotFoundException("존재하지 않는 사용자입니다: " + userid);
        }

        if ("ROLE_ADMIN".equals(user.getRole())) {
            Admins admin = adminMapper.selectOneAdminById(userid);
            if (admin == null) {
                throw new UsernameNotFoundException(
                    "관리자 권한이 있으나 Admin 정보가 없습니다: " + userid
                );
            }
            return new UserAdminDetails(admin, user);
        }

        return new UserAdminDetails(user);
    }

}
