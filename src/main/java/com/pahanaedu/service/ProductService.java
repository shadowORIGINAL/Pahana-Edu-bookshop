// ProductService.java
package com.pahanaedu.service;

import com.pahanaedu.dao.ProductDAO;
import com.pahanaedu.model.Product;
import java.util.List;

public class ProductService {
    private final ProductDAO productDAO = new ProductDAO();

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