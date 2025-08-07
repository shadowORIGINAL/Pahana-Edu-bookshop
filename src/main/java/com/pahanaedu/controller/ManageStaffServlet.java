package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ManageStaffServlet extends HttpServlet {
    private final UserService userService = new UserService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String searchTerm = request.getParameter("search");
            List<User> staffList;
            
            if (searchTerm != null && !searchTerm.isEmpty()) {
                staffList = userService.searchStaff(searchTerm);
            } else {
                staffList = userService.getAllStaff();
            }
            
            // Ensure we never pass null
            if (staffList == null) {
                staffList = new ArrayList<>();
            }
            
            request.setAttribute("staffList", staffList);
            request.getRequestDispatcher("manage_staff.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error and set an empty list
            e.printStackTrace();
            request.setAttribute("staffList", new ArrayList<User>());
            request.setAttribute("error", "Error loading staff data: " + e.getMessage());
            request.getRequestDispatcher("manage_staff.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                userService.deleteUser(id);
            } else if ("update".equals(action)) {
                User user = new User();
                user.setId(Long.parseLong(request.getParameter("id")));
                user.setEmail(request.getParameter("email"));
                user.setFirstName(request.getParameter("first_name"));
                user.setLastName(request.getParameter("last_name"));
                user.setAddress(request.getParameter("address"));
                user.setTelephone(request.getParameter("telephone"));
                user.setActive(Boolean.parseBoolean(request.getParameter("is_active")));
                
                userService.updateUser(user);
            }
            
            response.sendRedirect("ManageStaffServlet");
            
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}