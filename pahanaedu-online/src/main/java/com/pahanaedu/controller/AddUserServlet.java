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
    private final UserService userService = UserService.getInstance();
    private final EmailService emailService = EmailService.getInstance();
    
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
            
            // Send welcome email
            String subject = "Welcome to Pahana Edu - Your Account Credentials";
            String content = """
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Welcome to Pahana Edu</title>
                    <style>
                        body {
                            font-family: 'Inter', Arial, sans-serif;
                            background-color: #f4f4f4;
                            color: #333333;
                            line-height: 1.6;
                            margin: 0;
                            padding: 0;
                        }
                        .container {
                            max-width: 600px;
                            margin: 20px auto;
                            background-color: #ffffff;
                            border-radius: 12px;
                            overflow: hidden;
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                        }
                        .header {
                            background: linear-gradient(135deg, #ffd700, #ff6b6b);
                            padding: 20px;
                            text-align: center;
                        }
                        .header h1 {
                            margin: 0;
                            font-size: 24px;
                            color: #0f0f0f;
                        }
                        .content {
                            padding: 20px;
                            text-align: center;
                        }
                        .content p {
                            margin: 0 0 15px;
                            font-size: 16px;
                        }
                        .credentials {
                            background-color: #f5f0e8;
                            padding: 15px;
                            border-radius: 8px;
                            margin: 15px 0;
                            text-align: left;
                        }
                        .credentials p {
                            margin: 5px 0;
                            font-size: 14px;
                        }
                        .btn {
                            display: inline-block;
                            padding: 12px 24px;
                            background: linear-gradient(135deg, #ffd700, #ffed4e);
                            color: #0f0f0f;
                            text-decoration: none;
                            font-weight: 600;
                            border-radius: 50px;
                            transition: all 0.3s ease;
                            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                        }
                        .btn:hover {
                            background: linear-gradient(135deg, #ffed4e, #ffd700);
                            transform: translateY(-2px);
                        }
                        .footer {
                            background-color: #f4f4f4;
                            padding: 20px;
                            text-align: center;
                            font-size: 14px;
                            color: #666666;
                        }
                        .footer a {
                            color: #ffd700;
                            text-decoration: none;
                        }
                        .footer a:hover {
                            text-decoration: underline;
                        }
                        @media only screen and (max-width: 600px) {
                            .container {
                                margin: 10px;
                                padding: 10px;
                            }
                            .header h1 {
                                font-size: 20px;
                            }
                            .content p {
                                font-size: 14px;
                            }
                            .credentials p {
                                font-size: 12px;
                            }
                            .btn {
                                padding: 10px 20px;
                                font-size: 14px;
                            }
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>Welcome to Pahana Edu!</h1>
                        </div>
                        <div class="content">
                            <p>Dear %s,</p>
                            <p>Your Pahana Edu account has been successfully created. Below are your login credentials:</p>
                            <div class="credentials">
                                <p><strong>Email:</strong> %s</p>
                                <p><strong>Temporary Password:</strong> %s</p>
                            </div>
                            <p>For security, please log in and change your temporary password as soon as possible.</p>
                            <a href="%s" class="btn">Log In Now</a>
                            <p>Explore our educational resources and start your journey with Pahana Edu!</p>
                            <p>If you have any questions, please contact our support team.</p>
                        </div>
                        <div class="footer">
                            <p>Need help? <a href="mailto:support@pahanaedu.com">Contact our support team</a>.</p>
                            <p>&copy; 2025 Pahana Edu. All rights reserved.</p>
                        </div>
                    </div>
                </body>
                </html>
                """.formatted(
                    user.getFirstName() + " " + user.getLastName(),
                    user.getEmail(),
                    generatedPassword,
                    request.getRequestURL().toString().replace("AddUserServlet", "login.jsp")
                );
            
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