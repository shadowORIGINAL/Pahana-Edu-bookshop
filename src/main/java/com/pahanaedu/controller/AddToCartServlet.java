package com.pahanaedu.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.pahanaedu.model.Product;
import com.pahanaedu.model.User;
import com.pahanaedu.dao.ProductDAO;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    HttpSession session = request.getSession(false);
	    User user = session != null ? (User) session.getAttribute("user") : null;
	    
	    response.setContentType("application/json");
	    PrintWriter out = response.getWriter();

	    if (user == null || !"CUSTOMER".equals(user.getRole())) {
	        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        out.write("{\"success\": false, \"message\": \"Please login as a customer to add items to cart.\"}");
	        return;
	    }

	    try {
	        int productId = Integer.parseInt(request.getParameter("productId"));
	        ProductDAO productDao = new ProductDAO();
	        Product product = productDao.getProductById(productId);

	        if (product == null) {
	            out.write("{\"success\": false, \"message\": \"Product not found.\"}");
	            return;
	        }

	        if (product.getStockQuantity() <= 0) {
	            out.write("{\"success\": false, \"message\": \"Product out of stock.\", \"stockUpdated\": 0}");
	            return;
	        }

	        // Get or create cart
	        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
	        if (cart == null) {
	            cart = new HashMap<>();
	            session.setAttribute("cart", cart);
	        }

	        // Add to cart
	        cart.put(productId, cart.getOrDefault(productId, 0) + 1);
	        
	        // Update cart count
	        int cartCount = cart.values().stream().mapToInt(Integer::intValue).sum();
	        session.setAttribute("cartCount", cartCount);

	        out.write("{\"success\": true, \"cartCount\": " + cartCount + ", \"stockUpdated\": " + product.getStockQuantity() + "}");

	    } catch (Exception e) {
	        e.printStackTrace();
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        out.write("{\"success\": false, \"message\": \"Internal server error.\"}");
	    }
	}
    
}
