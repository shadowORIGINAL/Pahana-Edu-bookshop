package com.pahanaedu.controller;

import com.pahanaedu.factory.UserFactory;
import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;
import com.pahanaedu.service.EmailService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AddUserServlet extends HttpServlet {

    private final UserService userService = UserService.getInstance();
    private final EmailService emailService = EmailService.getInstance();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	UserFactory.UserWithPlainPassword result = UserFactory.createUserFromRequest(request);
    	User user = result.getUser();
    	String tempPassword = result.getPlainPassword(); // use this for email

        try {
            userService.registerUser(user);

            // Send welcome email
            String subject = "Your Pahana Edu Account Credentials";
            String content = "<h2>Welcome to Pahana Edu!</h2>" +
                    "<p>Your account has been created:</p>" +
                    "<p><strong>Email:</strong> " + user.getEmail() + "</p>" +
                    "<p><strong>Temporary Password:</strong> " + tempPassword + "</p>" +
                    "<p>Please log in and change your password as soon as possible.</p>" +
                    "<p><a href=\"http://yourwebsite.com/login.jsp\">Login here</a></p>" +
                    "<p>Best regards,<br>Pahana Edu Team</p>";

            emailService.sendEmail(user.getEmail(), subject, content);

            // Redirect based on role
            if ("STAFF".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("ManageStaffServlet?success=Staff+added+and+credentials+emailed");
            } else if ("CUSTOMER".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("ManageCustomersServlet?success=Customer+added+and+credentials+emailed");
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
