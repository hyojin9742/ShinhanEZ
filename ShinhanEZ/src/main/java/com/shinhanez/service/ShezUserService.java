package com.shinhanez.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.domain.ShezUser;
import com.shinhanez.mapper.ShezUserMapper;

/**
 * 회원 서비스
 */
@Service
public class ShezUserService {

    @Autowired
    private ShezUserMapper userMapper;
    // 기존 DB 평문 PW 암호화 | 임시
    public List<ShezUser> findAll(){
    	return userMapper.findAll();
    }
    public int updatePassword(String id, String pw) {
    	return userMapper.updatePassword(id, pw);
    }
    // 회원가입
    public int join(ShezUser user) {
        return userMapper.insert(user);
    }

    // 로그인
    public ShezUser login(String id, String pw) {
        return userMapper.findByIdAndPw(id, pw);
    }

    // 회원 조회
    public ShezUser findById(String id) {
        return userMapper.findById(id);
    }

    // ID 중복 체크 (true = 중복)
    public boolean isDuplicateId(String id) {
        return userMapper.countById(id) > 0;
    }
}
