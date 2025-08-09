package com.pahanaedu.service;

import com.pahanaedu.config.DBConnection;
import com.pahanaedu.dao.*;
import com.pahanaedu.model.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderService {
    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final UserDAO userDAO = new UserDAO();
    private final EmailService emailService = new EmailService();

    public Order createOrder(Order order, List<OrderItem> items) throws Exception {
        // Validate stock
        validateStock(items);
        
        // Calculate and set order total
        calculateOrderTotal(order, items);
        
        // Set order metadata
        order.setBillNumber(orderDAO.generateBillNumber());
        order.setStatus("COMPLETED");
        
        // Create order in database
        Long orderId = orderDAO.createOrder(order);
        order.setOrderId(orderId);
        
        // Process order items
        processOrderItems(orderId, items);
        
        // Calculate and update customer's units consumed
        int totalUnits = items.stream()
                             .mapToInt(OrderItem::getQuantity)
                             .sum();
        
        User customer = userDAO.getUserById(order.getCustomerId());
        if (customer != null) {
            int newUnits = customer.getUnitsConsumed() + totalUnits;
            customer.setUnitsConsumed(newUnits);
            userDAO.updateUser(customer);
            order.setNewUnitsConsumed(newUnits);
            order.setCustomer(customer); // Make sure customer is set in the order
        }
        
        // Get complete order details
        Order completeOrder = orderDAO.getOrderById(orderId);
        
        // Send confirmation email
        sendOrderConfirmation(completeOrder);
        
        return completeOrder;
    }

    private void updateCustomerUnitsConsumed(Long customerId, List<OrderItem> items) throws Exception {
        // Calculate total units from this order
        int totalUnits = items.stream()
                             .mapToInt(OrderItem::getQuantity)
                             .sum();
        
        // Update customer record
        User customer = userDAO.getUserById(customerId);
        if (customer != null) {
            customer.setUnitsConsumed(customer.getUnitsConsumed() + totalUnits);
            userDAO.updateUser(customer);
        }
    }

    private void validateStock(List<OrderItem> items) throws Exception {
        for (OrderItem item : items) {
            Product product = productDAO.getProductById(item.getProductId());
            if (product.getStockQuantity() < item.getQuantity()) {
                throw new Exception("Insufficient stock for: " + product.getTitle());
            }
        }
    }

    private void calculateOrderTotal(Order order, List<OrderItem> items) throws Exception {
        double total = 0;
        for (OrderItem item : items) {
            Product product = productDAO.getProductById(item.getProductId());
            double discountedPrice = product.getPrice() * (1 - (item.getDiscountPercentage() / 100));
            total += discountedPrice * item.getQuantity();
            
            item.setUnitPrice(product.getPrice());
            item.setDiscountPercentage(product.getDiscountPercentage());
        }
        order.setTotalAmount(total);
    }

    private void processOrderItems(Long orderId, List<OrderItem> items) throws Exception {
        for (OrderItem item : items) {
            item.setOrderId(orderId);
            orderDAO.addOrderItem(item);
            orderDAO.updateProductStock(item.getProductId(), item.getQuantity());
        }
    }

    private void sendOrderConfirmation(Order order) {
        try {
            if (order.getCustomer() == null || order.getCustomer().getEmail() == null) {
                System.err.println("No customer email available for order: " + order.getOrderId());
                return;
            }

            String emailContent = buildEmailContent(order);
            emailService.sendEmail(
                order.getCustomer().getEmail(),
                "Your Order Confirmation - #" + order.getBillNumber(),
                emailContent
            );
        } catch (Exception e) {
            System.err.println("Failed to send confirmation email for order: " + order.getOrderId());
            e.printStackTrace();
        }
    }

    private String buildEmailContent(Order order) {
        StringBuilder content = new StringBuilder();
        content.append("<html><body style='font-family: Arial, sans-serif;'>");
        content.append("<h2 style='color: #8b4513;'>Thank you for your order!</h2>");
        content.append("<p>Order #").append(order.getBillNumber()).append("</p>");
        content.append("<p>Date: ").append(order.getOrderDate()).append("</p>");
        
        // Items table
        content.append("<table border='1' cellpadding='5' style='border-collapse: collapse; width: 100%;'>");
        content.append("<tr style='background-color: #f5f0e8;'>")
              .append("<th>Item</th><th>Qty</th><th>Price</th><th>Total</th></tr>");
        
        for (OrderItem item : order.getItems()) {
            double itemTotal = item.getUnitPrice() * item.getQuantity() * 
                             (1 - (item.getDiscountPercentage() / 100));
            content.append("<tr>")
                  .append("<td>").append(item.getProduct().getTitle()).append("</td>")
                  .append("<td>").append(item.getQuantity()).append("</td>")
                  .append("<td>$").append(String.format("%.2f", item.getUnitPrice())).append("</td>")
                  .append("<td>$").append(String.format("%.2f", itemTotal)).append("</td>")
                  .append("</tr>");
        }
        
        // Order summary
        content.append("<tr style='background-color: #f5f0e8;'>")
              .append("<td colspan='3'><strong>Subtotal:</strong></td>")
              .append("<td><strong>$").append(String.format("%.2f", order.getTotalAmount())).append("</strong></td>")
              .append("</tr>");
        
        content.append("</table>");
        content.append("<p style='margin-top: 20px;'>Thank you for shopping with us!</p>");
        content.append("</body></html>");
        
        return content.toString();
    }

    private void sendOrderConfirmationEmail(Order order) {
        try {
            String subject = "Your Order Confirmation - #" + order.getBillNumber();
            
            // Create HTML email content with bill details
            StringBuilder content = new StringBuilder();
            content.append("<html><body style='font-family: Arial, sans-serif;'>");
            content.append("<h2 style='color: #8b4513;'>Thank you for your order!</h2>");
            content.append("<p>Your order #").append(order.getBillNumber()).append(" has been confirmed.</p>");
            content.append("<h3 style='color: #8b4513;'>Order Details</h3>");
            content.append("<p><strong>Order Date:</strong> ").append(order.getOrderDate()).append("</p>");
            
            // Order items table
            content.append("<table border='1' cellpadding='5' cellspacing='0' width='100%' style='border-collapse: collapse;'>");
            content.append("<tr style='background-color: #f5f0e8;'>")
                  .append("<th>Item</th><th>Quantity</th><th>Price</th><th>Discount</th><th>Total</th></tr>");
            
            for (OrderItem item : order.getItems()) {
                double itemTotal = item.getUnitPrice() * item.getQuantity() * 
                                 (1 - (item.getDiscountPercentage() / 100));
                
                content.append("<tr>");
                content.append("<td>").append(item.getProduct().getTitle()).append("</td>");
                content.append("<td>").append(item.getQuantity()).append("</td>");
                content.append("<td>$").append(String.format("%.2f", item.getUnitPrice())).append("</td>");
                content.append("<td>").append(item.getDiscountPercentage()).append("%</td>");
                content.append("<td>$").append(String.format("%.2f", itemTotal)).append("</td>");
                content.append("</tr>");
            }
            
            content.append("<tr style='background-color: #f5f0e8;'>")
                  .append("<td colspan='4' align='right'><strong>Subtotal:</strong></td>")
                  .append("<td><strong>$").append(String.format("%.2f", order.getTotalAmount()))
                  .append("</strong></td></tr>");
            
            double tax = order.getTotalAmount() * 0.1;
            double total = order.getTotalAmount() + tax;
            
            content.append("<tr style='background-color: #f5f0e8;'>")
                  .append("<td colspan='4' align='right'><strong>Tax (10%):</strong></td>")
                  .append("<td><strong>$").append(String.format("%.2f", tax))
                  .append("</strong></td></tr>");
            
            content.append("<tr style='background-color: #f5f0e8;'>")
                  .append("<td colspan='4' align='right'><strong>Total:</strong></td>")
                  .append("<td><strong>$").append(String.format("%.2f", total))
                  .append("</strong></td></tr>");
            content.append("</table>");
            
            content.append("<p style='margin-top: 20px;'>You can print this email as your receipt.</p>");
            content.append("<p>If you have any questions about your order, please contact us.</p>");
            content.append("<p>Thank you for shopping with us!</p>");
            content.append("</body></html>");
            
            // Send email
            emailService.sendEmail(
                order.getCustomer().getEmail(),
                subject,
                content.toString()
            );
            
        } catch (Exception e) {
            System.err.println("Error sending order confirmation email: " + e.getMessage());
            // Don't fail the order if email fails, but log the error
        }
    }

    public List<Order> getAllOrders() throws Exception {
        return orderDAO.getAllOrders();
    }

    public Order getOrderById(long id) throws Exception {
        return orderDAO.getOrderById(id);
    }
    
    public List<Order> getOrdersByCustomer(Long customerId) throws Exception {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM orders WHERE customer_id = ? ORDER BY order_date DESC";
            List<Order> orders = new ArrayList<>();
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setLong(1, customerId);
                ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getLong("order_id"));
                    order.setCustomerId(rs.getLong("customer_id"));
                    order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setStatus(rs.getString("status"));
                    // Set other fields as needed
                    orders.add(order);
                }
            }
            return orders;
        }
    }
    
    

    
}