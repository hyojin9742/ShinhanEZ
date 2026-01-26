package com.shinhanez.domain;

import java.util.Date;

/**
 * 회원 Entity
 * - shez_user 테이블과 매핑
 */
public class ShezUser {
    private String id;          // 회원 ID (PK)
    private String pw;          // 비밀번호
    private String email;       // 이메일
    private String name;        // 이름
    private Date birth;         // 생년월일
    private String telecom;     // 통신사
    private String gender;      // 성별 (M/F)
    private String phone;       // 연락처
    private String nation;      // 내/외국인 (K/F)
    private String role;        // 권한 (ROLE_USER, ROLE_ADMIN)
    private Date regDate;       // 가입일
    private String login_naver; // 간편 네이버 아이디
    private String login_google;// 간편 구글 아이디
    private String login_kakao;	// 간편 카카오 아이디
    private String provider;    // 간편 제공자

    // 기본 생성자
    public ShezUser() {}

    // Getter & Setter
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getPw() { return pw; }
    public void setPw(String pw) { this.pw = pw; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Date getBirth() { return birth; }
    public void setBirth(Date birth) { this.birth = birth; }

    public String getTelecom() { return telecom; }
    public void setTelecom(String telecom) { this.telecom = telecom; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getNation() { return nation; }
    public void setNation(String nation) { this.nation = nation; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }

    @Override
    public String toString() {
        return "ShezUser [id=" + id + ", name=" + name + ", role=" + role + "]";
    }
}
