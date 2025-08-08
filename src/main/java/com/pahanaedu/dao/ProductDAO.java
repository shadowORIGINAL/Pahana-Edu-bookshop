// ProductDAO.java
package com.pahanaedu.dao;

import com.pahanaedu.config.DBConnection;
import com.pahanaedu.model.Product;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductDAO {
    private static final Logger logger = Logger.getLogger(ProductDAO.class.getName());

    public void saveProduct(Product product) throws Exception {
        String sql = "INSERT INTO products (title, description, author, publisher, publication_date, " +
                     "category, price, stock_quantity, image_path, is_active, discount_percentage, featured) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, product.getTitle());
            ps.setString(2, product.getDescription());
            ps.setString(3, product.getAuthor());
            ps.setString(4, product.getPublisher());
            ps.setDate(5, product.getPublicationDate() != null ? 
                      Date.valueOf(product.getPublicationDate()) : null);
            ps.setString(6, product.getCategory());
            ps.setDouble(7, product.getPrice());
            ps.setInt(8, product.getStockQuantity());
            ps.setString(9, product.getImagePath());
            ps.setBoolean(10, product.isActive());
            ps.setDouble(11, product.getDiscountPercentage());
            ps.setBoolean(12, product.isFeatured());

            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating product failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    product.setProductId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating product failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving product", e);
            throw new Exception("Database error while saving product: " + e.getMessage());
        }
    }

    public List<Product> getAllProducts(boolean activeOnly) throws Exception {
        String sql = "SELECT * FROM products" + (activeOnly ? " WHERE is_active = TRUE" : "") + 
                     " ORDER BY title";
        List<Product> products = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting products", e);
            throw new Exception("Database error while fetching products");
        }
        return products;
    }

    public Product getProductById(long id) throws Exception {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting product by ID: " + id, e);
            throw new Exception("Database error while fetching product");
        }
        return null;
    }

    public void updateProduct(Product product) throws Exception {
        String sql = "UPDATE products SET title=?, description=?, author=?, publisher=?, " +
                     "publication_date=?, category=?, price=?, stock_quantity=?, image_path=?, " +
                     "is_active=?, discount_percentage=?, featured=? WHERE product_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, product.getTitle());
            ps.setString(2, product.getDescription());
            ps.setString(3, product.getAuthor());
            ps.setString(4, product.getPublisher());
            ps.setDate(5, product.getPublicationDate() != null ? 
                      Date.valueOf(product.getPublicationDate()) : null);
            ps.setString(6, product.getCategory());
            ps.setDouble(7, product.getPrice());
            ps.setInt(8, product.getStockQuantity());
            ps.setString(9, product.getImagePath());
            ps.setBoolean(10, product.isActive());
            ps.setDouble(11, product.getDiscountPercentage());
            ps.setBoolean(12, product.isFeatured());
            ps.setLong(13, product.getProductId());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Updating product failed, no rows affected.");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating product: " + product.getProductId(), e);
            throw new Exception("Database error while updating product: " + e.getMessage());
        }
    }

    public void deleteProduct(long id) throws Exception {
        String sql = "DELETE FROM products WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, id);
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Deleting product failed, no rows affected.");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting product: " + id, e);
            throw new Exception("Database error while deleting product: " + e.getMessage());
        }
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getLong("product_id"));
        product.setTitle(rs.getString("title"));
        product.setDescription(rs.getString("description"));
        product.setAuthor(rs.getString("author"));
        product.setPublisher(rs.getString("publisher"));
        Date pubDate = rs.getDate("publication_date");
        product.setPublicationDate(pubDate != null ? pubDate.toLocalDate() : null);
        product.setCategory(rs.getString("category"));
        product.setPrice(rs.getDouble("price"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setImagePath(rs.getString("image_path"));
        product.setActive(rs.getBoolean("is_active"));
        product.setDiscountPercentage(rs.getDouble("discount_percentage"));
        product.setFeatured(rs.getBoolean("featured"));
        return product;
    }
}