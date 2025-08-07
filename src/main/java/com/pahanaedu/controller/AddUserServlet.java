package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;
import com.pahanaedu.service.EmailService;
import java.security.SecureRandom;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

public class AddUserServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final EmailService emailService = new EmailService();
    
    private String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(10);
        for (int i = 0; i < 10; i++) {
            int randomIndex = random.nextInt(chars.length());
            sb.append(chars.charAt(randomIndex));
        }
        return sb.toString();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = new User();
        String generatedPassword = generateRandomPassword();
        String hashedPassword = BCrypt.hashpw(generatedPassword, BCrypt.gensalt());
        
        
        user.setEmail(request.getParameter("email"));
        user.setPassword(hashedPassword); // Store hashed password only
        user.setFirstName(request.getParameter("first_name"));
        user.setLastName(request.getParameter("last_name"));
        user.setRole(request.getParameter("role"));
        user.setAddress(request.getParameter("address"));
        user.setTelephone(request.getParameter("telephone"));
        user.setActive(true);
        
        // Handle units_consumed
        String unitsConsumedStr = request.getParameter("units_consumed");
        int unitsConsumed = 0;
        if (unitsConsumedStr != null && !unitsConsumedStr.isEmpty()) {
            try {
                unitsConsumed = Integer.parseInt(unitsConsumedStr);
            } catch (NumberFormatException e) {
                // Keep default 0
            }
        }
        user.setUnitsConsumed(unitsConsumed);

        try {
            userService.registerUser(user);
            
            // Send welcome email (still shows plaintext password for initial login)
            String subject = "Your Pahana Edu Account Credentials";
            String content = "<h2>Welcome to Pahana Edu!</h2>" +
                           "<p>Your account has been created with the following details:</p>" +
                           "<p><strong>Email:</strong> " + user.getEmail() + "</p>" +
                           "<p><strong>Temporary Password:</strong> " + generatedPassword + "</p>" +
                           "<p>Please log in and change your password as soon as possible.</p>" +
                           "<p><a href=\"http://yourwebsite.com/login.jsp\">Click here to log in</a></p>" +
                           "<p>Best regards,<br>Pahana Edu Team</p>";
            
            emailService.sendEmail(user.getEmail(), subject, content);
            
            // Redirect based on role
            if ("STAFF".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("ManageStaffServlet?success=Staff+member+added+successfully+and+credentials+emailed");
            } else if ("CUSTOMER".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("ManageCustomersServlet?success=Customer+added+successfully+and+credentials+emailed");
            } else {
                response.sendRedirect("admin_dashboard.jsp");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Failed to create user: " + e.getMessage());
            
            if ("STAFF".equalsIgnoreCase(request.getParameter("role"))) {
                request.getRequestDispatcher("add_staff.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("add_customer.jsp").forward(request, response);
            }
        }
    }
}