package com.pahanaedu.controllertest;

import com.pahanaedu.controller.LoginServlet;
import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import static org.junit.jupiter.api.Assertions.fail;
import static org.mockito.Mockito.*;

public class LoginServletTest {

    private LoginServlet loginServlet;
    private UserService userService; // Mocked
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        loginServlet = new LoginServlet();

        // Mock dependencies
        userService = mock(UserService.class);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);

        // Inject mocked UserService using reflection
        try {
            var field = LoginServlet.class.getDeclaredField("userService");
            field.setAccessible(true);
            field.set(loginServlet, userService);
        } catch (Exception e) {
            fail("Failed to inject mock UserService: " + e.getMessage());
        }
    }

    // -------------------- Successful login tests --------------------
//    @Test
//    void testSuccessfulLoginAdmin() throws Exception {
//        when(request.getParameter("email")).thenReturn("admin@example.com");
//        when(request.getParameter("password")).thenReturn("admin123");
//        when(request.getSession()).thenReturn(session);
//
//        User adminUser = new User();
//        adminUser.setEmail("admin@example.com");
//        adminUser.setRole("ADMIN");
//
//        when(userService.authenticate("admin@example.com", "admin123")).thenReturn(adminUser);
//
//        loginServlet.doPost(request, response);
//
//        verify(session).setAttribute("user", adminUser);
//        verify(session).setAttribute("role", "ADMIN");
//        verify(response).sendRedirect("admin_dashboard.jsp");
//    }

//    @Test
//    void testSuccessfulLoginStaff() throws Exception {
//        when(request.getParameter("email")).thenReturn("staff@example.com");
//        when(request.getParameter("password")).thenReturn("staff123");
//        when(request.getSession()).thenReturn(session);
//
//        User staffUser = new User();
//        staffUser.setEmail("staff@example.com");
//        staffUser.setRole("STAFF");
//
//        when(userService.authenticate("staff@example.com", "staff123")).thenReturn(staffUser);
//
//        loginServlet.doPost(request, response);
//
//        verify(session).setAttribute("user", staffUser);
//        verify(session).setAttribute("role", "STAFF");
//        verify(response).sendRedirect("staff_dashboard.jsp");
//    }
//
//    // -------------------- Failed login tests --------------------
//    @Test
//    void testFailedLoginInvalidCredentials() throws Exception {
//        when(request.getParameter("email")).thenReturn("wrong@example.com");
//        when(request.getParameter("password")).thenReturn("wrongpass");
//        when(request.getRequestDispatcher("login.jsp")).thenReturn(dispatcher);
//
//        when(userService.authenticate("wrong@example.com", "wrongpass"))
//                .thenReturn(null); // login fails
//
//        loginServlet.doPost(request, response);
//
//        verify(request).setAttribute(eq("error"), eq("Invalid email or password"));
//        verify(dispatcher).forward(request, response);
//    }
//
//    @Test
//    void testLoginThrowsException() throws Exception {
//        when(request.getParameter("email")).thenReturn("error@example.com");
//        when(request.getParameter("password")).thenReturn("errorpass");
//        when(request.getRequestDispatcher("login.jsp")).thenReturn(dispatcher);
//
//        when(userService.authenticate("error@example.com", "errorpass"))
//                .thenThrow(new RuntimeException("DB error"));
//
//        loginServlet.doPost(request, response);
//
//        verify(request).setAttribute(eq("error"), eq("Login failed. Please try again."));
//        verify(dispatcher).forward(request, response);
//    }
//
//    // -------------------- Optional intentionally failing test --------------------
    @Test
    void testFailedLoginIntentionalFailure() throws Exception {
        when(request.getParameter("email")).thenReturn("wrong@example.com");
        when(request.getParameter("password")).thenReturn("wrongpass");
        when(request.getSession()).thenReturn(session);

        User fakeUser = new User();
        fakeUser.setEmail("wrong@example.com");
        fakeUser.setRole("CUSTOMER");

        when(userService.authenticate("wrong@example.com", "wrongpass")).thenReturn(fakeUser);

        loginServlet.doPost(request, response);

        // Correct expectation is redirect for unknown roles
        verify(response).sendRedirect("index.jsp");
    }
}
