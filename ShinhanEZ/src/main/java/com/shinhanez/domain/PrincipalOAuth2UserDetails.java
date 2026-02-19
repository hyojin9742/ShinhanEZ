package com.shinhanez.domain;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

public class PrincipalOAuth2UserDetails implements OAuth2User {
    
    private Map<String, Object> attributes;
    private String nameAttributeKey;
    private String role;
    
    public PrincipalOAuth2UserDetails(Map<String, Object> attributes, String nameAttributeKey) {
        this.attributes = attributes;
        this.nameAttributeKey = nameAttributeKey;
        this.role = "ROLE_OAUTH";
    }
    public PrincipalOAuth2UserDetails(Map<String, Object> attributes, String nameAttributeKey,String role) {
    	this.attributes = attributes;
    	this.nameAttributeKey = nameAttributeKey;
    	this.role = role;
    }
    
    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }
    
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(new SimpleGrantedAuthority(role));
    }
    
    @Override
    public String getName() {
        return (String) attributes.get(nameAttributeKey);
    }
    
    public String getOAuthName() {
        return (String) attributes.get("name");
    }
    
    public String getEmail() {
        return (String) attributes.get("email");
    }
    
    public String getSub() {
    	return (String) attributes.get("sub");
    }
    public String getRole() {
        return role;
    }
}
