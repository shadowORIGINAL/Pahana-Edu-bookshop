package com.pahanaedu.controller;

import com.pahanaedu.model.*;
import com.pahanaedu.service.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;


public class CheckoutServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final ProductService productService = new ProductService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        
        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Get cart from session
            Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                response.sendRedirect("cart.jsp");
                return;
            }

            // Create order
            Order order = new Order();
            order.setCustomerId(user.getId());
            order.setCreatedBy(user.getId());
            
            // Convert cart items to order items
            List<OrderItem> items = new ArrayList<>();
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                try {
                    Product product = productService.getProductById(entry.getKey());
                    if (product == null) {
                        throw new ServletException("Product with ID " + entry.getKey() + " not found");
                    }
                    
                    if (product.getStockQuantity() < entry.getValue()) {
                        throw new ServletException("Not enough stock for product: " + product.getTitle() + 
                                ". Available: " + product.getStockQuantity() + ", Requested: " + entry.getValue());
                    }

                    OrderItem item = new OrderItem();
                    item.setProductId(product.getProductId());
                    item.setQuantity(entry.getValue());
                    item.setUnitPrice(product.getPrice());
                    item.setDiscountPercentage(product.getDiscountPercentage());
                    items.add(item);
                } catch (Exception e) {
                    throw new ServletException("Error processing product with ID " + entry.getKey() + ": " + e.getMessage(), e);
                }
            }

            // Create the order
            Order createdOrder = orderService.createOrder(order, items);
            
            // Update user in session with new units consumed
            User sessionUser = (User) session.getAttribute("user");
            sessionUser.setUnitsConsumed(createdOrder.getNewUnitsConsumed());
            session.setAttribute("user", sessionUser);
            
            // Clear the cart
            session.removeAttribute("cart");
            session.removeAttribute("cartCount");
            
            // Redirect to index with success message
            session.setAttribute("orderSuccess", "Your order #" + createdOrder.getOrderId() + " has been placed successfully! Total books purchased: " + createdOrder.getNewUnitsConsumed());
            response.sendRedirect("index.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing your order: " + e.getMessage());
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}