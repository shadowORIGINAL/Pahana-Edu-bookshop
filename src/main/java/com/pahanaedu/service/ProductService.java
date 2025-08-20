// ProductService.java
package com.pahanaedu.service;

import com.pahanaedu.dao.ProductDAO;
import com.pahanaedu.model.Product;
import java.util.List;

public class ProductService {

    // 1. Single instance
    private static ProductService instance;

    // 2. Private constructor prevents external instantiation
    private ProductService() {}

    // 3. Public method to provide access to the instance (thread-safe)
    public static synchronized ProductService getInstance() {
        if (instance == null) {
            instance = new ProductService();
        }
        return instance;
    }

    // DAO dependency
    private final ProductDAO productDAO = new ProductDAO();

    // Service methods
    public void addProduct(Product product) throws Exception {
        productDAO.saveProduct(product);
    }

    public List<Product> getAllProducts(boolean activeOnly) throws Exception {
        return productDAO.getAllProducts(activeOnly);
    }

    public Product getProductById(long id) throws Exception {
        return productDAO.getProductById(id);
    }

    public void updateProduct(Product product) throws Exception {
        productDAO.updateProduct(product);
    }

    public void deleteProduct(long id) throws Exception {
        productDAO.deleteProduct(id);
    }
}
