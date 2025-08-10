package com.pahanaedu.controller;

import com.pahanaedu.model.Product;
import com.pahanaedu.service.ProductService;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ProductServlet extends HttpServlet {
    private final ProductService productService = new ProductService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Product> products = productService.getAllProducts(true);
            request.setAttribute("products", products);
            request.getRequestDispatcher("store.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error
            e.printStackTrace();
            // Set error message and forward to error page or back to store
            request.setAttribute("error", "Error loading products: " + e.getMessage());
            request.getRequestDispatcher("store.jsp").forward(request, response);
        }
    }
}