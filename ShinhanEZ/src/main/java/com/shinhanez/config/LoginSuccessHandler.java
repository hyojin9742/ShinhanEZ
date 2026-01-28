package com.shinhanez.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import com.shinhanez.admin.domain.Admins;
import com.shinhanez.domain.UserAdminDetails;

public class LoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler{

	@Override
	public void onAuthenticationSuccess(
			HttpServletRequest request, 
			HttpServletResponse response,
			Authentication authentication
			) throws IOException, ServletException {
        	UserAdminDetails principal = (UserAdminDetails) authentication.getPrincipal();

            HttpSession session = request.getSession();

            Admins admin = principal.getAdmin();
            if (admin != null) {
                session.setAttribute("adminIdx", admin.getAdminIdx());
            }
            super.onAuthenticationSuccess(request, response, authentication);
	}

}
