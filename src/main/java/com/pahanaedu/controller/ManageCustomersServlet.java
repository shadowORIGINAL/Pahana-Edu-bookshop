package com.pahanaedu.controller;

import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ManageCustomersServlet extends HttpServlet {
    private final UserService userService = new UserService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String searchTerm = request.getParameter("search");
            String success = request.getParameter("success");
            
            List<User> customerList;
            
            if (searchTerm != null && !searchTerm.isEmpty()) {
                customerList = userService.searchCustomers(searchTerm);
            } else {
                customerList = userService.getAllCustomers();
            }
            
            // Set success message if present
            if (success != null) {
                request.setAttribute("success", "Customer added successfully!");
            }
            
            request.setAttribute("customerList", customerList);
            request.getRequestDispatcher("manage_customers.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading customers: " + e.getMessage());
            request.getRequestDispatcher("manage_customers.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                userService.deleteUser(id);
                request.setAttribute("success", "Customer deleted successfully!");
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
                request.setAttribute("success", "Customer updated successfully!");
            }
            
            // Redirect back to customer list
            response.sendRedirect("ManageCustomersServlet");
            
        } catch (Exception e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("manage_customers.jsp").forward(request, response);
        }
    }
}