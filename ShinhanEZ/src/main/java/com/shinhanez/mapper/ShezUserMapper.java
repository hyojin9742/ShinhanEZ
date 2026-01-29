package com.shinhanez.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.shinhanez.domain.ShezUser;

/**
 * 회원 Mapper
 * - MyBatis SQL 매핑
 */
@Mapper
public interface ShezUserMapper {
	List<ShezUser> findAll();
    // 기존 DB 평문 PW 암호화 | 임시
	int updatePassword(@Param("id") String id, @Param("pw") String pw);
    // 회원가입
    int insert(ShezUser user);
    
    // 로그인 (ID, PW로 조회)
    ShezUser findByIdAndPw(@Param("id") String id, @Param("pw") String pw);
    
    // ID로 회원 조회
    ShezUser findById(String id);
    
    // ID 중복 체크
    int countById(String id);
    
    // 이메일로 회원 조회
    ShezUser findByEmail(String email);
}
