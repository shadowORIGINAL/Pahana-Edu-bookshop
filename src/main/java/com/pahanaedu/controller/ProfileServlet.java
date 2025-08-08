package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

public class ProfileServlet extends HttpServlet {
    private final UserService userService = new UserService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("updateProfile".equals(action)) {
                handleProfileUpdate(request, response, currentUser);
            } else if ("changePassword".equals(action)) {
                handlePasswordChange(request, response, currentUser);
            } else {
                response.sendRedirect("edit_profile.jsp?error=Invalid+action");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {
        User updatedUser = new User();
        updatedUser.setId(currentUser.getId());
        updatedUser.setEmail(currentUser.getEmail());
        updatedUser.setFirstName(request.getParameter("first_name"));
        updatedUser.setLastName(request.getParameter("last_name"));
        updatedUser.setAddress(request.getParameter("address"));
        updatedUser.setTelephone(request.getParameter("telephone"));
        updatedUser.setRole(currentUser.getRole());
        updatedUser.setActive(true);
        
        // Always preserve the original units_consumed value
        updatedUser.setUnitsConsumed(currentUser.getUnitsConsumed());
        
        userService.updateUser(updatedUser);
        updateSessionUser(currentUser, updatedUser);
        
        response.sendRedirect("edit_profile.jsp?success=Profile+updated+successfully");
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Verify current password
        if (!BCrypt.checkpw(currentPassword, currentUser.getPassword())) {
            throw new Exception("Current password is incorrect");
        }
        
        // Verify new passwords match
        if (!newPassword.equals(confirmPassword)) {
            throw new Exception("New passwords don't match");
        }
        
        // Verify password strength
        if (newPassword.length() < 8 ) {
            throw new Exception("Password must be at least 8 characters and include one uppercase letter, number, and special character");
        }
        
        // Hash the new password once
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        
        // Update password
        userService.updatePassword(currentUser.getId(), hashedPassword);
        
        // Update session user with new password hash
        currentUser.setPassword(hashedPassword);
        
        response.sendRedirect("edit_profile.jsp?success=Password+changed+successfully");
    }

    private void updateSessionUser(User currentUser, User updatedUser) {
        currentUser.setFirstName(updatedUser.getFirstName());
        currentUser.setLastName(updatedUser.getLastName());
        currentUser.setAddress(updatedUser.getAddress());
        currentUser.setTelephone(updatedUser.getTelephone());
        currentUser.setUnitsConsumed(updatedUser.getUnitsConsumed());
    }
}