package com.pahanaedu.controllertest;

import com.pahanaedu.controller.RegisterServlet;
import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;
import com.pahanaedu.service.EmailService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static org.mockito.Mockito.*;

public class RegisterServletTest {

    private RegisterServlet registerServlet;
    private UserService userService;
    private EmailService emailService;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() throws Exception {
        registerServlet = new RegisterServlet();

        userService = mock(UserService.class);
        emailService = mock(EmailService.class);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        dispatcher = mock(RequestDispatcher.class);

        var userServiceField = RegisterServlet.class.getDeclaredField("userService");
        userServiceField.setAccessible(true);
        userServiceField.set(registerServlet, userService);

        var emailServiceField = RegisterServlet.class.getDeclaredField("emailService");
        emailServiceField.setAccessible(true);
        emailServiceField.set(registerServlet, emailService);

        when(request.getRequestDispatcher("register.jsp")).thenReturn(dispatcher);
    }

//    @Test
//    void testSuccessfulRegistration() throws Exception {
//        when(request.getParameter("email")).thenReturn("newuser@example.com");
//        when(request.getParameter("password")).thenReturn("validPass123");
//        when(request.getParameter("confirmPassword")).thenReturn("validPass123");
//        when(request.getParameter("first_name")).thenReturn("John");
//        when(request.getParameter("last_name")).thenReturn("Doe");
//        when(request.getParameter("address")).thenReturn("Colombo");
//        when(request.getParameter("telephone")).thenReturn("0771234567");
//        when(request.getParameter("role")).thenReturn("CUSTOMER");
//        when(request.getRequestURL()).thenReturn(new StringBuffer("http://localhost/RegisterServlet"));
//
//        registerServlet.doPost(request, response);
//
//        verify(userService).registerUser(any(User.class));
//        verify(emailService).sendEmail(eq("newuser@example.com"), anyString(), anyString());
//        verify(response).sendRedirect(contains("login.jsp?success"));
//    }

    @Test
    void testPasswordMismatch() throws Exception {
        when(request.getParameter("email")).thenReturn("user@example.com");
        when(request.getParameter("password")).thenReturn("pass12345");
        when(request.getParameter("confirmPassword")).thenReturn("differentPass");

        registerServlet.doPost(request, response);

        verify(request).setAttribute(eq("error"), eq("Passwords do not match"));
        verify(dispatcher).forward(request, response);
    }
//
//    @Test
//    void testWeakPassword() throws Exception {
//        when(request.getParameter("email")).thenReturn("user@example.com");
//        when(request.getParameter("password")).thenReturn("short");
//        when(request.getParameter("confirmPassword")).thenReturn("short");
//
//        registerServlet.doPost(request, response);
//
//        verify(request).setAttribute(eq("error"), eq("Password must be at least 8 characters"));
//        verify(dispatcher).forward(request, response);
//    }
//
//    @Test
//    void testDuplicateEmail() throws Exception {
//        when(request.getParameter("email")).thenReturn("existing@example.com");
//        when(request.getParameter("password")).thenReturn("validPass123");
//        when(request.getParameter("confirmPassword")).thenReturn("validPass123");
//        when(request.getParameter("first_name")).thenReturn("Jane");
//        when(request.getParameter("last_name")).thenReturn("Smith");
//        when(request.getParameter("address")).thenReturn("Kandy");
//        when(request.getParameter("telephone")).thenReturn("0777654321");
//        when(request.getParameter("role")).thenReturn("CUSTOMER");
//
//        // Simulate duplicate email error
//        doThrow(new RuntimeException("Duplicate email"))
//                .when(userService).registerUser(any(User.class));
//
//        registerServlet.doPost(request, response);
//
//        verify(request).setAttribute(eq("error"), eq("Registration failed. Please try again."));
//        verify(dispatcher).forward(request, response);
//    }
//
//    @Test
//    void testDoGet() throws Exception {
//        registerServlet.doGet(request, response);
//        verify(request).getRequestDispatcher("register.jsp");
//        verify(dispatcher).forward(request, response);
//    }
}
