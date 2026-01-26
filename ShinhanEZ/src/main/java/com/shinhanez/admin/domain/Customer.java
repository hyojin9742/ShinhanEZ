package com.shinhanez.admin.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 고객(보험자) Entity
 * - customer 테이블과 매핑
 */
public class Customer {
    private String customerId;      // 고객 ID (PK)
    private String loginId;        // 로그인 ID
    private String name;            // 이름
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date birthDate;         // 생년월일
    private String gender;          // 성별 (M/F)
    private String phone;           // 연락처
    private String email;           // 이메일
    private String address;         // 주소
    private String role;          // 상태
    private Date regDate;           // 등록일

    // 기본 생성자
    public Customer() {}

    // Getter & Setter
    public String getCustomerId() { return customerId; }
    public void setCustomerId(String customerId) { this.customerId = customerId; }

    public String getLoginId() { return loginId; }
    public void setLoginId(String loginId) { this.loginId = loginId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Date getBirthDate() { return birthDate; }
    public void setBirthDate(Date birthDate) { this.birthDate = birthDate; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }

    @Override
    public String toString() {
        return "Customer [customerId=" + customerId + ", name=" + name + ",role="+role+"]";
    }
}
