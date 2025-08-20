package com.pahanaedu.dao;

import com.pahanaedu.config.DBConnection;
import com.pahanaedu.model.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO {
    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());
    private static final String BILL_NUMBER_PREFIX = "BIL-";

    public Long createOrder(Order order) throws Exception {
        validateOrder(order);
        String sql = "INSERT INTO orders (customer_id, total_amount, status, bill_number, created_by) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setLong(1, order.getCustomerId());
            ps.setDouble(2, order.getTotalAmount());
            ps.setString(3, order.getStatus());
            ps.setString(4, order.getBillNumber());
            ps.setLong(5, order.getCreatedBy());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                } else {
                    throw new SQLException("Creating order failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating order", e);
            throw new Exception("Database error while creating order: " + e.getMessage());
        }
    }

    public void addOrderItem(OrderItem item) throws Exception {
        validateOrderItem(item);
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_percentage) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, item.getOrderId());
            ps.setLong(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getUnitPrice());
            ps.setDouble(5, item.getDiscountPercentage());
            
            ps.executeUpdate();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, String.format("Error adding order item for order ID: %d, product ID: %d", 
                item.getOrderId(), item.getProductId()), e);
            throw new Exception("Database error while adding order item: " + e.getMessage());
        }
    }

    public void updateProductStock(Long productId, int quantity) throws Exception {
        if (productId == null || productId <= 0) {
            throw new IllegalArgumentException("Invalid product ID: " + productId);
        }
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive: " + quantity);
        }

        String sql = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quantity);
            ps.setLong(2, productId);
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Updating product stock failed, no rows affected. Product ID: " + productId);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating product stock for product ID: " + productId, e);
            throw new Exception("Database error while updating product stock: " + e.getMessage());
        }
    }

    public String generateBillNumber() throws Exception {
        String sql = "SELECT COUNT(*) FROM orders WHERE bill_number LIKE ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, BILL_NUMBER_PREFIX + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return BILL_NUMBER_PREFIX + String.format("%06d", rs.getInt(1) + 1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error generating bill number", e);
            throw new Exception("Database error while generating bill number: " + e.getMessage());
        }
        return BILL_NUMBER_PREFIX + "000001";
    }

    public List<Order> getAllOrders() throws Exception {
        String sql = "SELECT o.*, u.email as customer_email, u.first_name as customer_first_name, " +
                     "u.last_name as customer_last_name, cu.email as created_by_email, " +
                     "cu.first_name as created_by_first_name, cu.last_name as created_by_last_name " +
                     "FROM orders o " +
                     "JOIN users u ON o.customer_id = u.id " +
                     "JOIN users cu ON o.created_by = cu.id " +
                     "ORDER BY o.order_date DESC";
        
        List<Order> orders = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                orders.add(mapOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting all orders", e);
            throw new Exception("Database error while fetching orders: " + e.getMessage());
        }
        return orders;
    }

    public Order getOrderById(long id) throws Exception {
        if (id <= 0) {
            throw new IllegalArgumentException("Invalid order ID: " + id);
        }

        String sql = "SELECT o.*, u.email as customer_email, u.first_name as customer_first_name, " +
                     "u.last_name as customer_last_name, cu.email as created_by_email, " +
                     "cu.first_name as created_by_first_name, cu.last_name as created_by_last_name " +
                     "FROM orders o " +
                     "JOIN users u ON o.customer_id = u.id " +
                     "JOIN users cu ON o.created_by = cu.id " +
                     "WHERE o.order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapOrderFromResultSet(rs);
                    order.setItems(getOrderItems(order.getOrderId()));
                    return order;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting order by ID: " + id, e);
            throw new Exception("Database error while fetching order: " + e.getMessage());
        }
        return null;
    }

    private List<OrderItem> getOrderItems(long orderId) throws Exception {
        if (orderId <= 0) {
            throw new IllegalArgumentException("Invalid order ID: " + orderId);
        }

        String sql = "SELECT oi.*, p.title as product_title, p.author as product_author, " +
                     "p.price as product_price, p.discount_percentage as product_discount " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.product_id " +
                     "WHERE oi.order_id = ?";
        
        List<OrderItem> items = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapOrderItemFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting order items for order ID: " + orderId, e);
            throw new Exception("Database error while fetching order items: " + e.getMessage());
        }
        return items;
    }

    private Order mapOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getLong("order_id"));
        order.setCustomerId(rs.getLong("customer_id"));
        order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setBillNumber(rs.getString("bill_number"));
        order.setCreatedBy(rs.getLong("created_by"));
        
        // Set customer details
        User customer = new User();
        customer.setId(rs.getLong("customer_id"));
        customer.setEmail(rs.getString("customer_email"));
        customer.setFirstName(rs.getString("customer_first_name"));
        customer.setLastName(rs.getString("customer_last_name"));
        order.setCustomer(customer);
        
        // Set created by user details
        User createdBy = new User();
        createdBy.setId(rs.getLong("created_by"));
        createdBy.setEmail(rs.getString("created_by_email"));
        createdBy.setFirstName(rs.getString("created_by_first_name"));
        createdBy.setLastName(rs.getString("created_by_last_name"));
        order.setCreatedByUser(createdBy);
        
        return order;
    }

    private OrderItem mapOrderItemFromResultSet(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setItemId(rs.getLong("item_id"));
        item.setOrderId(rs.getLong("order_id"));
        item.setProductId(rs.getLong("product_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getDouble("unit_price"));
        item.setDiscountPercentage(rs.getDouble("discount_percentage"));
        
        // Set product details
        Product product = new Product();
        product.setProductId(rs.getLong("product_id"));
        product.setTitle(rs.getString("product_title"));
        product.setAuthor(rs.getString("product_author"));
        product.setPrice(rs.getDouble("product_price"));
        product.setDiscountPercentage(rs.getDouble("product_discount"));
        item.setProduct(product);
        
        return item;
    }

    private void validateOrder(Order order) {
        if (order == null) {
            throw new IllegalArgumentException("Order cannot be null");
        }
        if (order.getCustomerId() <= 0) {
            throw new IllegalArgumentException("Invalid customer ID: " + order.getCustomerId());
        }
        if (order.getTotalAmount() < 0) {
            throw new IllegalArgumentException("Total amount cannot be negative: " + order.getTotalAmount());
        }
        if (order.getCreatedBy() <= 0) {
            throw new IllegalArgumentException("Invalid created by user ID: " + order.getCreatedBy());
        }
        if (order.getBillNumber() == null || order.getBillNumber().isEmpty()) {
            throw new IllegalArgumentException("Bill number cannot be null or empty");
        }
    }

    private void validateOrderItem(OrderItem item) {
        if (item == null) {
            throw new IllegalArgumentException("Order item cannot be null");
        }
        if (item.getOrderId() <= 0) {
            throw new IllegalArgumentException("Invalid order ID: " + item.getOrderId());
        }
        if (item.getProductId() <= 0) {
            throw new IllegalArgumentException("Invalid product ID: " + item.getProductId());
        }
        if (item.getQuantity() <= 0) {
            throw new IllegalArgumentException("Quantity must be positive: " + item.getQuantity());
        }
        if (item.getUnitPrice() < 0) {
            throw new IllegalArgumentException("Unit price cannot be negative: " + item.getUnitPrice());
        }
        if (item.getDiscountPercentage() < 0 || item.getDiscountPercentage() > 100) {
            throw new IllegalArgumentException("Discount percentage must be between 0 and 100: " + 
                item.getDiscountPercentage());
        }
    }
}