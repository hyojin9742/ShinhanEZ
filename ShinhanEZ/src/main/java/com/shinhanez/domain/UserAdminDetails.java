package com.shinhanez.domain;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.shinhanez.admin.domain.Admins;

import lombok.Getter;
import lombok.Setter;

public class UserAdminDetails implements UserDetails {

    private ShezUser user;
    private Admins admin;

    // 일반 회원용 생성자
    public UserAdminDetails(ShezUser user) {
        this.user = user;
    }

    // 관리자용 생성자
    public UserAdminDetails(Admins admin, ShezUser user) {
        this.admin = admin;
        this.user = user;
    }

    /* ================= 권한 ================= */
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorities = new ArrayList<>();
        if (user != null) {
        	authorities.add(new SimpleGrantedAuthority(user.getRole()));
        }
        if (admin != null && "ROLE_ADMIN".equals(user.getRole())) {
            authorities.add(new SimpleGrantedAuthority(
        		"ROLE_" + admin.getAdminRole().toUpperCase()
    		));
        }
        return authorities;
    }

    /* ================= 인증 정보 ================= */
    @Override
    public String getPassword() {
        if (user != null) return user.getPw();
        if (admin != null) return admin.getAdminPw();
        return null;
    }

    @Override
    public String getUsername() {
        if (user != null) return user.getId();
        if (admin != null) return admin.getAdminId();
        return null;
    }

    /* ================= 계정 상태 ================= */
    // 만료 정책 | 계정 유효기간
    @Override
    public boolean isAccountNonExpired() {
        return true; 
    }
    // 잠금 정책 | 비밀번호 실패 -> 계정 잠금
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }
    // 비밀번호 만료 | 비밀번호 변경주기 설정
    @Override
    public boolean isCredentialsNonExpired() {
        return true; 
    }
    // 탈퇴/비활성화 필드 | 휴면처리, DB의 비활성 계정 로그인 방지
    @Override
    public boolean isEnabled() {
        return true;
    }

    /** ================= 편의 메서드 ================= */
    public boolean isAdmin() {
        return admin != null;
    }
    public ShezUser getUser() {
        return user;
    }
    public Admins getAdmin() {
        return admin;
    }
    
    public String getDisplayName() {
        if (admin != null) return admin.getAdminName();
        return user.getName();
    }
    public String getDisplayRoleLabel() {
        switch (admin.getAdminRole()) {
            case "SUPER": return "관리자";
            case "MANAGER": return "매니저";
            case "STAFF": return "스태프";
            default: return "관리자";
        }
    }
}
