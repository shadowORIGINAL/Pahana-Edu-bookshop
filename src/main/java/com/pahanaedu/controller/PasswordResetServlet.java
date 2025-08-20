package com.pahanaedu.controller;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;
import com.pahanaedu.service.EmailService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

@WebServlet("/password-reset")
public class PasswordResetServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();
        
        try {
            // 1. Check if user exists
            User user = userDAO.getUserByEmail(email);
            if (user == null) {
                request.setAttribute("error", "No account found with that email.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // 2. Generate token
            String token = UUID.randomUUID().toString();
            LocalDateTime expiryDate = LocalDateTime.now().plus(24, ChronoUnit.HOURS);
            
            // 3. Store token in database
            userDAO.storePasswordResetToken(user.getId(), token, expiryDate);
            
            // 4. Send email
            EmailService emailService = EmailService.getInstance();

            String resetLink = request.getRequestURL().toString()
                .replace("password-reset", "reset-password.jsp") 
                + "?token=" + token;
            
            String emailContent = "Click this link to reset your password: <a href=\"" + resetLink + "\">Reset Password</a>";
            emailService.sendEmail(email, "Password Reset Request", emailContent);
            
            // 5. Redirect to login page with success message
            response.sendRedirect("login.jsp?message=Password+reset+link+has+been+sent+to+your+email.");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing password reset. Please try again.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}