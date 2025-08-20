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
    private final OrderDAO orderDAO;
    private final ProductDAO productDAO;
    private final UserDAO userDAO;
    private final EmailService emailService;

    // 🔹 Step 1: Singleton instance
    private static volatile OrderService instance;

    // 🔹 Step 2: Private constructor
    private OrderService() {
        this.orderDAO = new OrderDAO();
        this.productDAO = new ProductDAO();
        this.userDAO = new UserDAO();
        this.emailService = EmailService.getInstance(); // Already singleton
    }

    // 🔹 Step 3: Global access point
    public static OrderService getInstance() {
        if (instance == null) {
            synchronized (OrderService.class) {
                if (instance == null) {
                    instance = new OrderService();
                }
            }
        }
        return instance;
    }

    // ✅ All your business logic stays the same
    public Order createOrder(Order order, List<OrderItem> items) throws Exception {
        validateStock(items);
        calculateOrderTotal(order, items);

        order.setBillNumber(orderDAO.generateBillNumber());
        order.setStatus("COMPLETED");

        Long orderId = orderDAO.createOrder(order);
        order.setOrderId(orderId);

        processOrderItems(orderId, items);

        int totalUnits = items.stream()
                             .mapToInt(OrderItem::getQuantity)
                             .sum();

        User customer = userDAO.getUserById(order.getCustomerId());
        if (customer != null) {
            int newUnits = customer.getUnitsConsumed() + totalUnits;
            customer.setUnitsConsumed(newUnits);
            userDAO.updateUser(customer);
            order.setNewUnitsConsumed(newUnits);
            order.setCustomer(customer);
        }

        Order completeOrder = orderDAO.getOrderById(orderId);

        sendOrderConfirmation(completeOrder);

        return completeOrder;
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

        content.append("<tr style='background-color: #f5f0e8;'>")
              .append("<td colspan='3'><strong>Subtotal:</strong></td>")
              .append("<td><strong>$").append(String.format("%.2f", order.getTotalAmount())).append("</strong></td>")
              .append("</tr>");

        content.append("</table>");
        content.append("<p style='margin-top: 20px;'>Thank you for shopping with us!</p>");
        content.append("</body></html>");

        return content.toString();
    }

    public List<Order> getAllOrders() throws Exception {
        return orderDAO.getAllOrders();
    }

    public Order getOrderById(long id) throws Exception {
        return orderDAO.getOrderById(id);
    }

    public List<Order> getOrdersByCustomer(Long customerId) throws Exception {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
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
                    orders.add(order);
                }
            }
            return orders;
        }
    }
}
