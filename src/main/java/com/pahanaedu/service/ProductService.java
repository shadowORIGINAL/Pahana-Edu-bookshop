// ProductService.java
package com.pahanaedu.service;

import com.pahanaedu.dao.ProductDAO;
import com.pahanaedu.model.Product;
import java.util.List;

public class ProductService {
    private static ProductService instance;
    private final ProductDAO productDAO;

    // Private constructor
    private ProductService() {
        this.productDAO = new ProductDAO();
    }

    // Singleton accessor
    public static synchronized ProductService getInstance() {
        if (instance == null) {
            instance = new ProductService();
        }
        return instance;
    }

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
