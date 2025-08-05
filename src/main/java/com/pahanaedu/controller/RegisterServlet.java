package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;
import com.pahanaedu.service.EmailService;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final EmailService emailService = new EmailService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            String content = "<h2>Thank you for registering!</h2>" +
                           "<p>Your account has been successfully created.</p>" +
                           "<p>You can now log in using your email address and the password you created.</p>" +
                           "<p><a href=\"http://yourwebsite.com/login.jsp\">Click here to log in</a></p>" +
                           "<p>Best regards,<br>Pahana Edu Team</p>";
            
            emailService.sendEmail(user.getEmail(), subject, content);
            
            // Redirect to login page with success message
            response.sendRedirect("login.jsp?success=Registration+successful.+Please+log+in.");
            
        } catch (Exception e) {
            // Handle errors (like duplicate email)
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show registration form
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}