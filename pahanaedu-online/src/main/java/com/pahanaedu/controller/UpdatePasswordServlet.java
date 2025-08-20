package com.pahanaedu.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.PasswordResetToken;

/**
 * Servlet implementation class UpdatePasswordServlet
 */
@WebServlet("/update-password")
public class UpdatePasswordServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    String token = request.getParameter("token");
	    String newPassword = request.getParameter("newPassword");
	    String confirmPassword = request.getParameter("confirmPassword");
	    
	    UserDAO userDAO = new UserDAO();
	    
	    try {
	        // Validate token
	        PasswordResetToken resetToken = userDAO.getPasswordResetToken(token);
	        
	        if (resetToken == null || resetToken.isExpired() || resetToken.isUsed()) {
	            request.setAttribute("error", "Invalid or expired reset link");
	            request.getRequestDispatcher("reset-password.jsp?token=" + token).forward(request, response);
	            return;
	        }
	        
	        // Validate passwords match
	        if (!newPassword.equals(confirmPassword)) {
	            request.setAttribute("error", "Passwords don't match");
	            request.getRequestDispatcher("reset-password.jsp?token=" + token).forward(request, response);
	            return;
	        }
	        
	        // Validate password strength
	        if (newPassword.length() < 8 ) {
	            request.setAttribute("error", "Password must be at least 8 characters and include one uppercase letter, number, and special character");
	            request.getRequestDispatcher("reset-password.jsp?token=" + token).forward(request, response);
	            return;
	        }
	        
	        // Update password with hashing (once)
	        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
	        userDAO.updateUserPassword(resetToken.getUserId(), hashedPassword);
	        
	        // Invalidate token
	        userDAO.invalidatePasswordResetToken(token);
	        
	        // Redirect to login with success message
	        response.sendRedirect("login.jsp?message=Password updated successfully. Please login with your new password.");
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        request.setAttribute("error", "Error updating password: " + e.getMessage());
	        request.getRequestDispatcher("reset-password.jsp?token=" + token).forward(request, response);
	    }
	}
}