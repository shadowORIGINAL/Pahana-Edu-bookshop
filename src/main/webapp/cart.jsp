<%@ page import="java.util.*" %>
<%@ page import="com.pahanaedu.model.Product" %>
<%@ page import="com.pahanaedu.dao.ProductDAO" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if (cart == null) cart = new HashMap<>();
    ProductDAO dao = new ProductDAO();
    double subtotal = 0.0;
    boolean outOfStockFlag = false;
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart - Pahana Edu</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #0f0f0f;
            color: #ffffff;
            line-height: 1.6;
            overflow-x: hidden;
        }

        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(15, 15, 15, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            background: rgba(15, 15, 15, 0.98);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 80px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffd700;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.05);
            filter: drop-shadow(0 0 20px rgba(255, 215, 0, 0.5));
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
            align-items: center;
        }

        .nav-link {
            color: #ffffff;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 50%;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, #ffd700, #ff6b6b);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::before {
            width: 100%;
        }

        .nav-link:hover {
            color: #ffd700;
            background: rgba(255, 215, 0, 0.1);
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            color: #ffffff;
            font-size: 1.5rem;
            cursor: pointer;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .cart-section {
            padding: 8rem 0;
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a2e 100%);
            position: relative;
            z-index: 1;
        }

        .cart-title {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
        }

        .cart-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 3rem;
            margin: 2rem 0;
        }

        .cart-items {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .cart-item {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 2rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            gap: 2rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .cart-item:hover {
            transform: translateY(-10px);
            border-color: rgba(255, 215, 0, 0.3);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .cart-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #ffd700, #ff6b6b, #4ecdc4);
            transform: scaleX(0);
            transition: all 0.3s ease;
        }

        .cart-item:hover::before {
            transform: scaleX(1);
        }

        .cart-item-image {
            width: 120px;
            height: 160px;
            object-fit: cover;
            border-radius: 12px;
        }

        .no-image {
            width: 120px;
            height: 160px;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #0f0f0f;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 12px;
            text-align: center;
            padding: 1rem;
        }

        .cart-item-details {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .cart-item-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffffff;
        }

        .cart-item-author {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.95rem;
            font-style: italic;
        }

        .cart-item-price {
            font-weight: 600;
            color: #ffd700;
            font-size: 1.2rem;
        }

        .cart-item-discount {
            text-decoration: line-through;
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.9rem;
            margin-left: 0.5rem;
        }

        .out-of-stock {
            color: #ff6b6b;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .cart-item-controls {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-top: 1rem;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .quantity-btn {
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            color: #ffffff;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .quantity-btn:hover {
            background: rgba(255, 215, 0, 0.2);
            border-color: #ffd700;
        }

        .quantity-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .quantity-input {
            width: 60px;
            padding: 0.5rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            color: #ffffff;
            text-align: center;
            font-size: 1rem;
        }

        .remove-item {
            color: #ff6b6b;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .remove-item:hover {
            color: #ffed4e;
            text-decoration: underline;
        }

        .cart-summary {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 2rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: sticky;
            top: 100px;
            transition: all 0.3s ease;
        }

        .summary-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffd700;
            margin-bottom: 1.5rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.8rem;
            padding-bottom: 0.8rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.8);
        }

        .summary-total {
            font-weight: 700;
            font-size: 1.3rem;
            color: #ffffff;
            margin-top: 1rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            border-radius: 50px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: none;
            cursor: pointer;
            white-space: nowrap;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: all 0.5s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f0f;
            box-shadow: 0 8px 32px rgba(255, 215, 0, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 215, 0, 0.4);
        }

        .btn-primary:disabled {
            background: rgba(255, 255, 255, 0.2);
            color: rgba(255, 255, 255, 0.5);
            cursor: not-allowed;
            box-shadow: none;
            transform: none;
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border: 2px solid rgba(255, 255, 255, 0.2);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.4);
            transform: translateY(-3px);
        }

        .empty-cart {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 4rem 2rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            margin: 2rem 0;
        }

        .empty-cart h3 {
            font-size: 2rem;
            font-weight: 700;
            color: #ffd700;
            margin-bottom: 1rem;
        }

        .empty-cart p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }

        .footer {
            background: #0a0a0a;
            padding: 4rem 0 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 3rem;
            margin-bottom: 3rem;
        }

        .footer-section h4 {
            color: #ffd700;
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .footer-section p,
        .footer-section a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            line-height: 1.8;
            transition: all 0.3s ease;
        }

        .footer-section a:hover {
            color: #ffd700;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 0.5rem;
        }

        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.2rem;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: #ffd700;
            color: #0f0f0f;
            transform: translateY(-3px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.5);
        }

        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a2e 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            transition: opacity 0.5s ease, visibility 0.5s ease;
        }

        .page-loader.hidden {
            opacity: 0;
            visibility: hidden;
        }

        .loader-content {
            text-align: center;
            color: #ffd700;
        }

        .loader-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            animation: spin 2s linear infinite;
        }

        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #0f0f0f;
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #ffd700, #ff6b6b);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #ffed4e, #ff6b6b);
        }

        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            text-align: center;
            font-weight: 500;
            animation: slideInUp 0.5s ease-out;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(76, 175, 80, 0.2), rgba(76, 175, 80, 0.1));
            border: 1px solid rgba(76, 175, 80, 0.3);
            color: #4CAF50;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .nav-menu {
                position: fixed;
                top: 80px;
                left: 0;
                right: 0;
                background: rgba(15, 15, 15, 0.98);
                backdrop-filter: blur(20px);
                flex-direction: column;
                padding: 2rem;
                display: none;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
                z-index: 999;
            }

            .nav-menu.active {
                display: flex;
            }

            .mobile-menu-btn {
                display: block;
            }

            .cart-container {
                grid-template-columns: 1fr;
            }

            .cart-summary {
                position: static;
            }

            .cart-item {
                flex-direction: column;
            }

            .cart-item-image, .no-image {
                width: 100%;
                height: 200px;
            }

            .container {
                padding: 0 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Page Loader -->
    <div class="page-loader" id="pageLoader">
        <div class="loader-content">
            <div class="loader-icon">📚</div>
            <h3>Loading Pahana Edu...</h3>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="navbar" id="navbar">
        <div class="nav-container">
            <a href="index.jsp" class="logo">
                📖 Pahana Edu
            </a>
            
            <ul class="nav-menu" id="navMenu">
                <li><a href="index.jsp#home" class="nav-link">Home</a></li>
                <li><a href="index.jsp#features" class="nav-link">Features</a></li>
                <li><a href="store" class="nav-link">Store</a></li>
                <li><a href="index.jsp#services" class="nav-link">Services</a></li>
                <li><a href="index.jsp#contact" class="nav-link">Contact</a></li>
                <li><a href="cart.jsp" class="nav-link">🛒 Cart (<%= session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0 %>)</a></li>
            </ul>

            <div class="user-menu">
                <% if (isLoggedIn) { %>
                    <% 
                        String roleBasedLink;
                        if ("ADMIN".equals(user.getRole())) {
                            roleBasedLink = "admin_dashboard.jsp";
                        } else if ("STAFF".equals(user.getRole())) {
                            roleBasedLink = "staff_dashboard.jsp";
                        } else {
                            roleBasedLink = "edit_profile.jsp";
                        }
                    %>
                    <a href="<%= roleBasedLink %>" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;">
                        👤 <%= user.getFirstName() %>
                    </a>
                    <a href="LogoutServlet" class="btn btn-danger" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;" 
                       onclick="return confirm('Are you sure you want to logout?')">
                        🚪 Logout
                    </a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-info" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;">
                        🔑 Login
                    </a>
                <% } %>
            </div>

            <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
        </div>
    </nav>

    <!-- Cart Section -->
    <section class="cart-section">
        <div class="container">
            <h1 class="cart-title">Your Shopping Cart</h1>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            <% if (cart.isEmpty()) { %>
                <div class="empty-cart">
                    <h3>📚 Your Cart is Empty</h3>
                    <p>Looks like you haven't added any items to your cart yet.</p>
                    <a href="store" class="btn btn-primary">🛍️ Continue Shopping</a>
                </div>
            <% } else { %>
                <div class="cart-container">
                    <div class="cart-items">
                        <% for (Map.Entry<Integer, Integer> entry : cart.entrySet()) { 
                            Product p = dao.getProductById(entry.getKey());
                            if (p == null) continue;
                            
                            int quantity = entry.getValue();
                            double price = p.getDiscountedPrice() > 0 ? p.getDiscountedPrice() : p.getPrice();
                            subtotal += price * quantity;
                            
                            boolean outOfStock = p.getStockQuantity() <= 0;
                            boolean exceedsStock = quantity > p.getStockQuantity();
                            if (exceedsStock) outOfStockFlag = true;
                        %>
                            <div class="cart-item">
                                <% if (p.getImagePath() != null && !p.getImagePath().isEmpty()) { %>
                                    <img src="<%= request.getContextPath() + "/" + p.getImagePath() %>" 
                                         alt="<%= p.getTitle() %>" class="cart-item-image">
                                <% } else { %>
                                    <div class="no-image">
                                        <%= p.getTitle().length() > 15 ? 
                                            p.getTitle().substring(0, 15) + "..." : 
                                            p.getTitle() %>
                                    </div>
                                <% } %>
                                
                                <div class="cart-item-details">
                                    <h3 class="cart-item-title"><%= p.getTitle() %></h3>
                                    <p class="cart-item-author">by <%= p.getAuthor() %></p>
                                    
                                    <div class="cart-item-price">
                                        $<%= String.format("%.2f", price) %>
                                        <% if (p.getDiscountedPrice() > 0) { %>
                                            <span class="cart-item-discount">$<%= String.format("%.2f", p.getPrice()) %></span>
                                        <% } %>
                                    </div>
                                    
                                    <% if (outOfStock) { %>
                                        <p class="out-of-stock">This item is currently out of stock</p>
                                    <% } else if (exceedsStock) { %>
                                        <p class="out-of-stock">Only <%= p.getStockQuantity() %> available (you have <%= quantity %>)</p>
                                    <% } else { %>
                                        <p>Available: <%= p.getStockQuantity() %></p>
                                    <% } %>
                                    
                                    <div class="cart-item-controls">
                                        <div class="quantity-control">
                                            <button class="quantity-btn minus" onclick="updateQuantity(<%= p.getProductId() %>, -1)" <%= quantity <= 1 ? "disabled" : "" %>>-</button>
                                            <input type="number" class="quantity-input" 
                                                   value="<%= quantity %>" min="1" max="<%= p.getStockQuantity() %>"
                                                   onchange="updateQuantityInput(<%= p.getProductId() %>, this)">
                                            <button class="quantity-btn plus" onclick="updateQuantity(<%= p.getProductId() %>, 1)" <%= quantity >= p.getStockQuantity() ? "disabled" : "" %>>+</button>
                                        </div>
                                        <span class="remove-item" onclick="removeItem(<%= p.getProductId() %>)">Remove</span>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        
                        <a href="store" class="btn btn-secondary">← Continue Shopping</a>
                    </div>
                    
                    <div class="cart-summary">
                        <h3 class="summary-title">Order Summary</h3>
                        <div class="summary-row">
                            <span>Subtotal (<%= cart.values().stream().mapToInt(Integer::intValue).sum() %> items)</span>
                            <span>$<%= String.format("%.2f", subtotal) %></span>
                        </div>
                        <div class="summary-row">
                            <span>Shipping</span>
                            <span>Free</span>
                        </div>
                        <div class="summary-row">
                            <span>Tax</span>
                            <span>$<%= String.format("%.2f", subtotal * 0.1) %></span>
                        </div>
                        <div class="summary-row summary-total">
                            <span>Total</span>
                            <span>$<%= String.format("%.2f", subtotal * 1.1) %></span>
                        </div>
                        
                        <form action="CheckoutServlet" method="post" id="checkoutForm">
                            <button type="submit" class="btn btn-primary" <%= outOfStockFlag ? "disabled" : "" %>>
                                <%= outOfStockFlag ? "Adjust quantities to checkout" : "Proceed to Checkout" %>
                            </button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>Pahana Edu</h4>
                    <p>
                        Your premier destination for educational resources and learning experiences. 
                        We're passionate about connecting learners with their next great educational adventure.
                    </p>
                    <div class="social-links">
                        <a href="#" title="Facebook">📘</a>
                        <a href="#" title="Twitter">🐦</a>
                        <a href="#" title="Instagram">📷</a>
                        <a href="#" title="LinkedIn">💼</a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="index.jsp#home">Home</a></li>
                        <li><a href="store">Browse Resources</a></li>
                        <% if (isLoggedIn) { %>
                            <li><a href="ManageOrdersServlet?action=history">Order History</a></li>
                        <% } else { %>
                            <li><a href="login.jsp">Login</a></li>
                        <% } %>
                        <li><a href="index.jsp#services">Services</a></li>
                        <li><a href="index.jsp#contact">Contact Us</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Categories</h4>
                    <ul>
                        <li><a href="store?category=fiction">Fiction</a></li>
                        <li><a href="store?category=non-fiction">Non-Fiction</a></li>
                        <li><a href="store?category=science">Science & Technology</a></li>
                        <li><a href="store?category=biography">Biography</a></li>
                        <li><a href="store?category=children">Children's Books</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Customer Service</h4>
                    <ul>
                        <li><a href="index.jsp#contact">Help Center</a></li>
                        <li><a href="index.jsp#services">Shipping Info</a></li>
                        <li><a href="index.jsp#services">Returns & Refunds</a></li>
                        <li><a href="index.jsp#contact">Privacy Policy</a></li>
                        <li><a href="index.jsp#contact">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 Pahana Edu. All rights reserved. Made with ❤️ for learners.</p>
            </div>
        </div>
    </footer>

    <script>
        // Page loader
        window.addEventListener('load', function() {
            setTimeout(() => {
                document.getElementById('pageLoader').classList.add('hidden');
            }, 1500);
        });

        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 100) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Mobile menu toggle
        document.getElementById('mobileMenuBtn').addEventListener('click', function() {
            const navMenu = document.getElementById('navMenu');
            navMenu.classList.toggle('active');
            this.innerHTML = navMenu.classList.contains('active') ? '✕' : '☰';
        });

        // Close mobile menu when clicking on a link
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', function() {
                const navMenu = document.getElementById('navMenu');
                const mobileMenuBtn = document.getElementById('mobileMenuBtn');
                navMenu.classList.remove('active');
                mobileMenuBtn.innerHTML = '☰';
            });
        });

        // Smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Enhanced button interactions with ripple effect
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn, .quantity-btn');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    const ripple = document.createElement('span');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;
                    
                    ripple.style.cssText = `
                        position: absolute;
                        width: ${size}px;
                        height: ${size}px;
                        left: ${x}px;
                        top: ${y}px;
                        background: rgba(255, 255, 255, 0.3);
                        border-radius: 50%;
                        transform: scale(0);
                        animation: ripple 0.6s linear;
                        pointer-events: none;
                        z-index: 10;
                    `;
                    
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                });
            });
        });

        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.cart-item, .cart-summary').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'all 0.6s ease-out';
            observer.observe(el);
        });

        // Add ripple animation keyframes
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);

        // Sparkle effects on mouse movement
        document.addEventListener('mousemove', function(e) {
            if (Math.random() > 0.995) {
                createSparkle(e.clientX, e.clientY);
            }
        });

        function createSparkle(x, y) {
            const sparkle = document.createElement('div');
            sparkle.innerHTML = '✨';
            sparkle.style.cssText = `
                position: fixed;
                left: ${x}px;
                top: ${y}px;
                font-size: ${Math.random() * 10 + 10}px;
                pointer-events: none;
                z-index: 10;
                animation: sparkleAnim 1s ease-out forwards;
            `;
            
            document.body.appendChild(sparkle);
            
            setTimeout(() => {
                sparkle.remove();
            }, 1000);
        }

        const sparkleStyleSheet = document.createElement('style');
        sparkleStyleSheet.textContent = `
            @keyframes sparkleAnim {
                0% {
                    transform: scale(0) rotate(0deg);
                    opacity: 1;
                }
                50% {
                    transform: scale(1) rotate(180deg);
                    opacity: 1;
                }
                100% {
                    transform: scale(0) rotate(360deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(sparkleStyleSheet);

        // Existing cart functionality
        function updateQuantity(productId, change) {
            const input = document.querySelector(`input[onchange="updateQuantityInput(${productId}, this)"]`);
            const newValue = parseInt(input.value) + change;
            const max = parseInt(input.max);
            
            if (newValue >= 1 && newValue <= max) {
                input.value = newValue;
                sendQuantityUpdate(productId, newValue);
            }
        }
        
        function updateQuantityInput(productId, input) {
            let value = parseInt(input.value);
            const max = parseInt(input.max);
            
            if (isNaN(value) || value < 1) {
                value = 1;
            } else if (value > max) {
                value = max;
            }
            
            input.value = value;
            sendQuantityUpdate(productId, value);
        }
        
        function sendQuantityUpdate(productId, quantity) {
            fetch('updateCart?productId=' + productId + '&quantity=' + quantity, {
                method: 'POST',
                credentials: 'include'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.querySelectorAll('.nav-menu .nav-link[href="cart.jsp"]')
                        .forEach(el => {
                            el.textContent = `🛒 Cart (${data.cartCount})`;
                        });
                    window.location.reload();
                } else {
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'alert alert-error';
                    errorDiv.textContent = data.message || "Failed to update quantity.";
                    document.querySelector('.cart-title').insertAdjacentElement('afterend', errorDiv);
                    setTimeout(() => errorDiv.remove(), 3000);
                }
            })
            .catch(err => {
                console.error("Update quantity error", err);
                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-error';
                errorDiv.textContent = "Failed to update quantity. Please try again.";
                document.querySelector('.cart-title').insertAdjacentElement('afterend', errorDiv);
                setTimeout(() => errorDiv.remove(), 3000);
            });
        }
        
        function removeItem(productId) {
            if (confirm('Are you sure you want to remove this item from your cart?')) {
                fetch('removeFromCart?productId=' + productId, {
                    method: 'POST',
                    credentials: 'include'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.querySelectorAll('.nav-menu .nav-link[href="cart.jsp"]')
                            .forEach(el => {
                                el.textContent = `🛒 Cart (${data.cartCount})`;
                            });
                        window.location.reload();
                    } else {
                        const errorDiv = document.createElement('div');
                        errorDiv.className = 'alert alert-error';
                        errorDiv.textContent = data.message || "Failed to remove item.";
                        document.querySelector('.cart-title').insertAdjacentElement('afterend', errorDiv);
                        setTimeout(() => errorDiv.remove(), 3000);
                    }
                })
                .catch(err => {
                    console.error("Remove item error", err);
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'alert alert-error';
                    errorDiv.textContent = "Failed to remove item. Please try again.";
                    document.querySelector('.cart-title').insertAdjacentElement('afterend', errorDiv);
                    setTimeout(() => errorDiv.remove(), 3000);
                });
            }
        }

        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const checkoutButton = this.querySelector('button[type="submit"]');
            checkoutButton.classList.add('loading');
            checkoutButton.innerHTML = 'Processing...';
            
            fetch('CheckoutServlet', {
                method: 'POST',
                credentials: 'include'
            })
            .then(response => {
                if (response.redirected) {
                    window.location.href = response.url;
                } else {
                    return response.json();
                }
            })
            .then(data => {
                if (data && data.success) {
                    const successDiv = document.createElement('div');
                    successDiv.className = 'alert alert-success';
                    successDiv.textContent = 'Checkout successful!';
                    document.querySelector('.cart-title').insertAdjacentElement('afterend', successDiv);
                    setTimeout(() => {
                        window.location.href = "index.jsp";
                    }, 2000);
                } else if (data) {
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'alert alert-error';
                    errorDiv.textContent = data.message || "Checkout failed";
                    document.querySelector('.cart-title').insertAdjacentElement('afterend', errorDiv);
                    setTimeout(() => errorDiv.remove(), 3000);
                    checkoutButton.classList.remove('loading');
                    checkoutButton.innerHTML = '<%= outOfStockFlag ? "Adjust quantities to checkout" : "Proceed to Checkout" %>';
                }
            })
            .catch(err => {
                console.error("Checkout error", err);
                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-error';
                errorDiv.textContent = "Error during checkout. Please try again.";
                document.querySelector('.cart-title').insertAdjacentElement('afterend', errorDiv);
                setTimeout(() => errorDiv.remove(), 3000);
                checkoutButton.classList.remove('loading');
                checkoutButton.innerHTML = '<%= outOfStockFlag ? "Adjust quantities to checkout" : "Proceed to Checkout" %>';
            });
        });
    </script>
</body>
</html></html>