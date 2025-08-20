package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;
import com.pahanaedu.service.EmailService;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
	private final UserService userService = UserService.getInstance();
    private final EmailService emailService = EmailService.getInstance();


    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String role = request.getParameter("role");

        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Hash the password before storing in the User object
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // Create user object with hashed password
        User user = new User();
        user.setEmail(email);
        user.setPassword(hashedPassword); // Store hashed password
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setRole(role);
        user.setAddress(address);
        user.setTelephone(telephone);
        user.setActive(true);
        user.setUnitsConsumed(0); // New customers start with 0 units

        try {
            // Register the user
            userService.registerUser(user);
            
            // Send welcome email
            String subject = "Welcome to Pahana Edu!";
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
                            <p>Thank you for joining Pahana Edu! Your account has been successfully created.</p>
                            <p>You can now log in using your email address and the password you chose.</p>
                            <a href="%s" class="btn">Log In Now</a>
                            <p>Explore our wide range of educational resources and start your learning journey today!</p>
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
                    request.getRequestURL().toString().replace("RegisterServlet", "login.jsp")
                );
            
            emailService.sendEmail(user.getEmail(), subject, content);

            
            // Redirect to login page with success message
            response.sendRedirect("login.jsp?success=Registration+successful.+Please+log+in.");
            
        } catch (Exception e) {
            // Handle errors (like duplicate email)
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show registration form
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}