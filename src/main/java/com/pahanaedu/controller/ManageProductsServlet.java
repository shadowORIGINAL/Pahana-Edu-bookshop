package com.pahanaedu.controller;

import com.pahanaedu.model.Product;
import com.pahanaedu.model.User;
import com.pahanaedu.service.ProductService;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class ManageProductsServlet extends HttpServlet {
    private final ProductService productService = new ProductService();
    private static final String UPLOAD_DIR = "images";  // Changed from "images/products"

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        
        if (user == null || (!user.getRole().equals("ADMIN") && !user.getRole().equals("STAFF"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            List<Product> productList = productService.getAllProducts(false);
            request.setAttribute("productList", productList);
            request.getRequestDispatcher("manage_products.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading products: " + e.getMessage());
            request.getRequestDispatcher("manage_products.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        
        if (user == null || (!user.getRole().equals("ADMIN") && !user.getRole().equals("STAFF"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                handleAddProduct(request, response);
            } else if ("update".equals(action)) {
                handleUpdateProduct(request, response);
            } else if ("delete".equals(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                productService.deleteProduct(id);
                response.sendRedirect("ManageProductsServlet?success=Product+deleted+successfully");
            } else if ("toggleActive".equals(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                Product product = productService.getProductById(id);
                product.setActive(!product.isActive());
                productService.updateProduct(product);
                response.sendRedirect("ManageProductsServlet?success=Product+status+updated");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("manage_products.jsp").forward(request, response);
        }
    }

    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException, ServletException {
        // Get application path
        String appPath = request.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;
        
        // Create upload directory if it doesn't exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Process image upload
        Part filePart = request.getPart("image");
        String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
        String filePath = uploadPath + File.separator + fileName;
        String relativeImagePath = UPLOAD_DIR + File.separator + fileName;
        
        if (filePart != null && filePart.getSize() > 0) {
            filePart.write(filePath);
        } else {
            relativeImagePath = null; // No image uploaded
        }

        // Create and save product
        Product product = new Product();
        product.setTitle(request.getParameter("title"));
        product.setDescription(request.getParameter("description"));
        product.setAuthor(request.getParameter("author"));
        product.setPublisher(request.getParameter("publisher"));
        String pubDateStr = request.getParameter("publication_date");
        product.setPublicationDate(pubDateStr != null && !pubDateStr.isEmpty() ? 
                                 LocalDate.parse(pubDateStr) : null);
        product.setCategory(request.getParameter("category"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));
        product.setStockQuantity(Integer.parseInt(request.getParameter("stock_quantity")));
        product.setImagePath(relativeImagePath);
        product.setActive(request.getParameter("is_active") != null);
        product.setDiscountPercentage(Double.parseDouble(
            request.getParameter("discount_percentage")));
        product.setFeatured(request.getParameter("featured") != null);

        productService.addProduct(product);
        response.sendRedirect("ManageProductsServlet?success=Product+added+successfully");
    }

    private void handleUpdateProduct(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException, ServletException {
        long id = Long.parseLong(request.getParameter("id"));
        Product product = productService.getProductById(id);
        
        // Update basic fields
        product.setTitle(request.getParameter("title"));
        product.setDescription(request.getParameter("description"));
        product.setAuthor(request.getParameter("author"));
        product.setPublisher(request.getParameter("publisher"));
        String pubDateStr = request.getParameter("publication_date");
        product.setPublicationDate(pubDateStr != null && !pubDateStr.isEmpty() ? 
                                 LocalDate.parse(pubDateStr) : null);
        product.setCategory(request.getParameter("category"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));
        product.setStockQuantity(Integer.parseInt(request.getParameter("stock_quantity")));
        product.setActive(request.getParameter("is_active") != null);
        product.setDiscountPercentage(Double.parseDouble(
            request.getParameter("discount_percentage")));
        product.setFeatured(request.getParameter("featured") != null);

        // Handle image update if a new image was uploaded
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            // Get application path
            String appPath = request.getServletContext().getRealPath("");
            String uploadPath = appPath + File.separator + UPLOAD_DIR;
            
            // Create upload directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Process new image upload
            String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
            String filePath = uploadPath + File.separator + fileName;
            String relativeImagePath = UPLOAD_DIR + File.separator + fileName;
            
            filePart.write(filePath);
            product.setImagePath(relativeImagePath);
        }

        productService.updateProduct(product);
        response.sendRedirect("ManageProductsServlet?success=Product+updated+successfully");
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}