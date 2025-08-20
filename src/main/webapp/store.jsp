<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pahanaedu.model.User" %>

<%
    @SuppressWarnings("unchecked")
    List<Product> products = (List<Product>) request.getAttribute("products");
    String error = (String) request.getAttribute("error");
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
    String firstName = isLoggedIn ? user.getFirstName() : "Guest";
    String role = (user != null) ? user.getRole() : null;
    Integer cartCount = (Integer) session.getAttribute("cartCount");
    if (cartCount == null) cartCount = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu - Literary Store</title>
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

        /* Navigation - Enhanced from index.jsp */
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

        .nav-link.active {
            color: #ffd700;
            background: rgba(255, 215, 0, 0.1);
        }

        .nav-link.active::before {
            width: 100%;
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50px;
            font-size: 0.9rem;
        }

        .cart-icon {
            background: rgba(255, 215, 0, 0.2);
            color: #ffd700;
            padding: 0.8rem;
            border-radius: 50%;
            text-decoration: none;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .cart-icon:hover {
            background: rgba(255, 215, 0, 0.3);
            transform: scale(1.1);
        }

        .cart-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #e74c3c;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            color: #ffffff;
            font-size: 1.5rem;
            cursor: pointer;
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.8rem 1.5rem;
            font-size: 0.9rem;
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

        .btn-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: #ffffff;
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 107, 107, 0.4);
        }

        .btn-info {
            background: linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%);
            color: #ffffff;
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(78, 205, 196, 0.4);
        }

        /* Main Content Styling */
        .main-content {
            margin-top: 80px;
            min-height: calc(100vh - 80px);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        /* Store Hero Section */
        .store-hero {
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a2e 50%, #16213e 100%);
            padding: 6rem 0 4rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .store-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><radialGradient id="grad" cx="50%" cy="50%" r="50%"><stop offset="0%" style="stop-color:rgba(255,215,0,0.1);stop-opacity:1" /><stop offset="100%" style="stop-color:rgba(255,215,0,0);stop-opacity:0" /></radialGradient></defs><circle cx="20" cy="20" r="2" fill="url(%23grad)"><animate attributeName="opacity" values="0;1;0" dur="3s" repeatCount="indefinite"/></circle><circle cx="80" cy="40" r="1.5" fill="url(%23grad)"><animate attributeName="opacity" values="0;1;0" dur="4s" repeatCount="indefinite" begin="1s"/></circle><circle cx="40" cy="80" r="1" fill="url(%23grad)"><animate attributeName="opacity" values="0;1;0" dur="2s" repeatCount="indefinite" begin="2s"/></circle></svg>') repeat;
            animation: float 20s ease-in-out infinite;
        }

        .store-hero-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .store-hero h1 {
            font-size: clamp(2.5rem, 6vw, 4rem);
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 50%, #4ecdc4 100%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: slideInUp 1s ease-out;
        }

        .store-hero-subtitle {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 2rem;
            animation: slideInUp 1s ease-out 0.2s both;
        }

        /* Search Section */
        .search-section {
            background: rgba(255, 255, 255, 0.02);
            padding: 3rem 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .search-container {
            max-width: 600px;
            margin: 0 auto;
            position: relative;
        }

        .search-bar {
            width: 100%;
            padding: 1.2rem 4rem 1.2rem 1.5rem;
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 50px;
            font-size: 1.1rem;
            font-family: inherit;
            outline: none;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            backdrop-filter: blur(20px);
        }

        .search-bar::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .search-bar:focus {
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
            background: rgba(255, 255, 255, 0.15);
        }

        .search-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f0f;
            border: none;
            border-radius: 50px;
            padding: 0.8rem 1.5rem;
            cursor: pointer;
            font-weight: bold;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            transform: translateY(-50%) scale(1.05);
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
        }

        /* Filters Section */
        .filters-section {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(20px);
            padding: 2rem 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .filters {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            align-items: center;
            justify-content: center;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .filter-group label {
            font-weight: 600;
            color: #ffd700;
            font-size: 0.95rem;
        }

        .filter-group select {
            padding: 0.8rem 1rem;
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            font-family: inherit;
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            font-size: 0.9rem;
            outline: none;
            transition: all 0.3s ease;
            backdrop-filter: blur(20px);
        }

        .filter-group select:focus {
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }

        .filter-group select option {
            background: #1a1a2e;
            color: #ffffff;
        }

        /* Alert Styles */
        .alert-error {
            background: linear-gradient(135deg, rgba(255, 107, 107, 0.2) 0%, rgba(231, 76, 60, 0.2) 100%);
            color: #ff6b6b;
            padding: 1.5rem;
            border-radius: 15px;
            margin: 2rem 0;
            text-align: center;
            border: 1px solid rgba(255, 107, 107, 0.3);
            backdrop-filter: blur(20px);
        }

        .empty-message {
            text-align: center;
            padding: 6rem 2rem;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            margin: 3rem 0;
        }

        .empty-message h3 {
            color: #ffd700;
            margin-bottom: 1rem;
            font-size: 2rem;
            font-weight: 800;
        }

        .empty-message p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.2rem;
        }

        /* Products Section */
        .products-section {
            padding: 4rem 0;
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a2e 100%);
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2.5rem;
            margin-top: 2rem;
        }

        .product-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            position: relative;
            cursor: pointer;
        }

        .product-card::before {
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

        .product-card:hover::before {
            transform: scaleX(1);
        }

        .product-card:hover {
            transform: translateY(-10px);
            border-color: rgba(255, 215, 0, 0.3);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .product-image {
            width: 100%;
            height: 280px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        .no-image {
            height: 280px;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #0f0f0f;
            font-size: 1.2rem;
            font-weight: bold;
            text-align: center;
            padding: 1rem;
        }

        .product-info {
            padding: 2rem;
        }

        .product-badges {
            position: absolute;
            top: 15px;
            left: 15px;
            display: flex;
            flex-direction: column;
            gap: 8px;
            z-index: 2;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            color: white;
            text-transform: uppercase;
            backdrop-filter: blur(10px);
        }

        .discount-badge {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        .featured-badge {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            box-shadow: 0 4px 15px rgba(243, 156, 18, 0.3);
        }

        .product-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 0.8rem;
            color: #ffffff;
            line-height: 1.3;
        }

        .product-author {
            color: rgba(255, 255, 255, 0.7);
            font-size: 1rem;
            margin-bottom: 1.5rem;
            font-style: italic;
        }

        .product-price {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .current-price {
            font-weight: 800;
            color: #ffd700;
            font-size: 1.4rem;
        }

        .original-price {
            text-decoration: line-through;
            color: rgba(255, 255, 255, 0.5);
            font-size: 1.1rem;
        }

        .stock-info {
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .in-stock {
            color: #4ecdc4;
        }

        .out-of-stock {
            color: #ff6b6b;
        }

        .add-to-cart {
            width: 100%;
            background: linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%);
            color: white;
            border: none;
            padding: 1rem 1.5rem;
            border-radius: 50px;
            cursor: pointer;
            font-weight: 700;
            font-size: 1rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .add-to-cart::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: all 0.5s ease;
        }

        .add-to-cart:hover::before {
            left: 100%;
        }

        .add-to-cart:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(78, 205, 196, 0.4);
        }

        .add-to-cart:disabled {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .add-to-cart:disabled::before {
            display: none;
        }

        /* Promotional Banner */
        .promo-banner {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 4rem 0;
            margin: 4rem 0;
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            overflow: hidden;
        }

        .promo-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y="0.9em" font-size="20" opacity="0.1">📚</text></svg>') repeat;
            opacity: 0.1;
        }

        .promo-content {
            position: relative;
            z-index: 1;
            text-align: center;
            max-width: 600px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .promo-banner h2 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .promo-banner p {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 2rem;
        }

        .promo-btn {
            display: inline-block;
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f0f;
            padding: 1.2rem 2.5rem;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(255, 215, 0, 0.3);
        }

        .promo-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(255, 215, 0, 0.4);
        }

        /* Footer */
        .footer {
            background: #0a0a0a;
            padding: 4rem 0 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 4rem;
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
            margin-bottom: 0.8rem;
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 2rem;
            text-align: center;
            color: rgba(255, 255, 255, 0.5);
        }

        /* Animations */
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
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

        /* Responsive Design */
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

            .store-hero h1 {
                font-size: 2.5rem;
            }

            .filters {
                flex-direction: column;
                align-items: stretch;
                gap: 1rem;
            }

            .filter-group {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 2rem;
            }

            .promo-banner h2 {
                font-size: 2rem;
            }

            .container {
                padding: 0 1rem;
            }

            .user-menu {
                gap: 0.5rem;
            }

            .user-info {
                font-size: 0.8rem;
                padding: 0.3rem 0.8rem;
            }
        }

        /* Loading states and micro-interactions */
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar" id="navbar">
        <div class="nav-container">
            <a href="index.jsp" class="logo">
                📖 Pahana Edu
            </a>
            
            <ul class="nav-menu" id="navMenu">
                <li><a href="index.jsp" class="nav-link">Home</a></li>
                <li><a href="#features" class="nav-link">Features</a></li>
                <li><a href="store" class="nav-link active">Store</a></li>
                <li><a href="index.jsp#services" class="nav-link">Services</a></li>
                <li><a href="index.jsp#contact" class="nav-link">Contact</a></li>
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

    <!-- Main Content -->
    <main class="main-content">
        <!-- Store Hero Section -->
        <section class="store-hero">
            <div class="store-hero-content">
                <h1>Literary Store</h1>
                <p class="store-hero-subtitle">Discover thousands of books across all genres. From bestsellers to hidden gems, find your next great read in our carefully curated collection.</p>
            </div>
        </section>

        <!-- Search Section -->
        <section class="search-section">
            <div class="container">
                <div class="search-container">
                    <input type="text" class="search-bar" placeholder="Search by title, author, or genre..." id="searchInput">
                    <button class="search-btn" onclick="searchBooks()">🔍</button>
                </div>
            </div>
        </section>

        <!-- Filters Section -->
        <section class="filters-section">
            <div class="container">
                <div class="filters">
                    <div class="filter-group">
                        <label for="genreFilter">📚 Genre:</label>
                        <select id="genreFilter" onchange="filterProducts()">
                            <option value="">All Genres</option>
                            <option value="fiction">Fiction</option>
                            <option value="mystery">Mystery</option>
                            <option value="romance">Romance</option>
                            <option value="sci-fi">Science Fiction</option>
                            <option value="fantasy">Fantasy</option>
                            <option value="biography">Biography</option>
                            <option value="history">History</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="priceFilter">💰 Price:</label>
                        <select id="priceFilter" onchange="filterProducts()">
                            <option value="">All Prices</option>
                            <option value="0-15">Under $15</option>
                            <option value="15-25">$15 - $25</option>
                            <option value="25-35">$25 - $35</option>
                            <option value="35+">Over $35</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="sortFilter">🔽 Sort:</label>
                        <select id="sortFilter" onchange="sortProducts()">
                            <option value="title">Title A-Z</option>
                            <option value="price-low">Price: Low to High</option>
                            <option value="price-high">Price: High to Low</option>
                            <option value="featured">Featured First</option>
                        </select>
                    </div>
                </div>
            </div>
        </section>

        <!-- Error Display -->
        <% if (error != null) { %>
            <div class="container">
                <div class="alert-error">
                    <strong>⚠️ Oops!</strong> <%= error %>
                </div>
            </div>
        <% } %>

        <!-- Products Section -->
        <section class="products-section">
            <div class="container">
                <% if (products == null || products.isEmpty()) { %>
                    <div class="empty-message">
                        <h3>📚 No Books Found</h3>
                        <p>We're currently updating our collection. Please check back soon for new arrivals!</p>
                    </div>
                <% } else { %>
                    <div class="product-grid" id="productGrid">
                        <% for (Product product : products) { %>
                        <div class="product-card fade-in" data-title="<%= product.getTitle().toLowerCase() %>" 
                             data-author="<%= product.getAuthor().toLowerCase() %>" 
                             data-price="<%= product.getPrice() %>"
                             data-featured="<%= product.isFeatured() %>">
                            
                            <!-- Product Badges -->
                            <div class="product-badges">
                                <% if (product.getDiscountPercentage() > 0) { %>
                                    <span class="badge discount-badge">
                                        <%= (int) product.getDiscountPercentage() %>% OFF
                                    </span>
                                <% } %>
                                <% if (product.isFeatured()) { %>
                                    <span class="badge featured-badge">⭐ Featured</span>
                                <% } %>
                            </div>

                            <!-- Product Image -->
                            <% if (product.getImagePath() != null && !product.getImagePath().isEmpty()) { %>
                                <img src="<%= request.getContextPath() + "/" + product.getImagePath() %>" 
                                     alt="<%= product.getTitle() %>" class="product-image">
                            <% } else { %>
                                <div class="no-image">
                                    📖 <%= product.getTitle().length() > 25 ? 
                                        product.getTitle().substring(0, 25) + "..." : 
                                        product.getTitle() %>
                                </div>
                            <% } %>

                            <!-- Product Info -->
                            <div class="product-info">
                                <h3 class="product-title"><%= product.getTitle() %></h3>
                                <p class="product-author">by <%= product.getAuthor() %></p>

                                <div class="product-price">
                                    <% if (product.getDiscountPercentage() > 0) { %>
                                        <span class="current-price">
                                            $<%= String.format("%.2f", product.getDiscountedPrice()) %>
                                        </span>
                                        <span class="original-price">
                                            $<%= String.format("%.2f", product.getPrice()) %>
                                        </span>
                                    <% } else { %>
                                        <span class="current-price">
                                            $<%= String.format("%.2f", product.getPrice()) %>
                                        </span>
                                    <% } %>
                                </div>

                                <div class="stock-info">
                                    <% if (product.getStockQuantity() <= 0) { %>
                                        <span class="out-of-stock">❌ Out of Stock</span>
                                    <% } else if (product.getStockQuantity() <= 5) { %>
                                        <span class="in-stock">⚠️ Only <%= product.getStockQuantity() %> left!</span>
                                    <% } else { %>
                                        <span class="in-stock">✅ In Stock (<%= product.getStockQuantity() %> available)</span>
                                    <% } %>
                                </div>

                                <% if (user != null && "CUSTOMER".equals(role)) { %>
                                    <button class="add-to-cart" 
                                        <%= product.getStockQuantity() <= 0 ? "disabled" : "" %>
                                        onclick="addToCart(<%= product.getProductId() %>)">
                                        <%= product.getStockQuantity() <= 0 ? "❌ Out of Stock" : "🛒 Add to Cart" %>
                                    </button>
                                <% } else if (user != null) { %>
                                    <button class="add-to-cart" disabled title="Only customers can add to cart">
                                        🚫 Not Available
                                    </button>
                                <% } else { %>
                                    <button class="add-to-cart" 
                                        onclick="window.location.href='login.jsp'">
                                        🔑 Login to Add
                                    </button>
                                <% } %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                <% } %>

                <!-- Promotional Banner -->
                <div class="promo-banner">
                    <div class="promo-content">
                        <h2>📚 Book Lover's Special!</h2>
                        <p>Join our reading community and get 20% off your first order plus free shipping on orders over $25!</p>
                        <% if (!isLoggedIn) { %>
                            <a href="register.jsp" class="promo-btn">🎁 Join Now & Save</a>
                        <% } else { %>
                            <a href="index.jsp#services" class="promo-btn">📖 Explore Services</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>Pahana Edu</h4>
                    <p>
                        Your premier destination for books, literature, and literary experiences. 
                        We're passionate about connecting readers with their next great adventure.
                    </p>
                </div>
                
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="index.jsp">🏠 Home</a></li>
                        <li><a href="store">📚 Browse Books</a></li>
                        <% if (isLoggedIn) { %>
                            <li><a href="ManageOrdersServlet?action=history">📋 Order History</a></li>
                        <% } else { %>
                            <li><a href="login.jsp">🔑 Login</a></li>
                        <% } %>
                        <li><a href="index.jsp#services">🎯 Services</a></li>
                        <li><a href="index.jsp#contact">📞 Contact Us</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Popular Categories</h4>
                    <ul>
                        <li><a href="store?category=fiction">📖 Fiction</a></li>
                        <li><a href="store?category=non-fiction">📚 Non-Fiction</a></li>
                        <li><a href="store?category=science">🔬 Science & Technology</a></li>
                        <li><a href="store?category=biography">👤 Biography</a></li>
                        <li><a href="store?category=children">🧸 Children's Books</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Customer Service</h4>
                    <ul>
                        <li><a href="index.jsp#contact">❓ Help Center</a></li>
                        <li><a href="index.jsp#services">🚚 Shipping Info</a></li>
                        <li><a href="index.jsp#services">🔄 Returns & Refunds</a></li>
                        <li><a href="index.jsp#contact">🔒 Privacy Policy</a></li>
                        <li><a href="index.jsp#contact">📋 Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 Pahana Edu. All rights reserved. Made with ❤️ for book lovers.</p>
            </div>
        </div>
    </footer>

    <script>
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
            
            // Change hamburger icon
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

        // Search functionality
        function searchBooks() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const productCards = document.querySelectorAll('.product-card');
            let visibleCount = 0;
            
            productCards.forEach(card => {
                const title = card.getAttribute('data-title');
                const author = card.getAttribute('data-author');
                if (title.includes(searchTerm) || author.includes(searchTerm) || searchTerm === '') {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Show no results message if no products found
            updateResultsDisplay(visibleCount);
        }

        // Enhanced search with Enter key support
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchBooks();
            }
        });

        // Real-time search as user types (debounced)
        let searchTimeout;
        document.getElementById('searchInput').addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(searchBooks, 300);
        });

        // Filter functionality
        function filterProducts() {
            const genreFilter = document.getElementById('genreFilter').value.toLowerCase();
            const priceFilter = document.getElementById('priceFilter').value;
            const productCards = document.querySelectorAll('.product-card');
            let visibleCount = 0;

            productCards.forEach(card => {
                const title = card.getAttribute('data-title');
                const author = card.getAttribute('data-author');
                const price = parseFloat(card.getAttribute('data-price'));
                let showCard = true;

                // Apply search filter if search term exists
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                if (searchTerm && !title.includes(searchTerm) && !author.includes(searchTerm)) {
                    showCard = false;
                }

                // Apply genre filter
                if (genreFilter && !title.includes(genreFilter) && !author.includes(genreFilter)) {
                    showCard = false;
                }

                // Apply price filter
                if (priceFilter) {
                    const [min, max] = priceFilter.split('-');
                    if (max) {
                        showCard = showCard && (price >= parseFloat(min) && price <= parseFloat(max));
                    } else if (min.endsWith('+')) {
                        showCard = showCard && price >= parseFloat(min.replace('+', ''));
                    } else {
                        showCard = showCard && price <= parseFloat(min);
                    }
                }

                if (showCard) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            updateResultsDisplay(visibleCount);
        }

        // Sort functionality
        function sortProducts() {
            const sortBy = document.getElementById('sortFilter').value;
            const productGrid = document.getElementById('productGrid');
            const productCards = Array.from(document.querySelectorAll('.product-card'));

            productCards.sort((a, b) => {
                switch (sortBy) {
                    case 'title':
                        return a.getAttribute('data-title').localeCompare(b.getAttribute('data-title'));
                    case 'price-low':
                        return parseFloat(a.getAttribute('data-price')) - parseFloat(b.getAttribute('data-price'));
                    case 'price-high':
                        return parseFloat(b.getAttribute('data-price')) - parseFloat(a.getAttribute('data-price'));
                    case 'featured':
                        const aFeatured = a.getAttribute('data-featured') === 'true';
                        const bFeatured = b.getAttribute('data-featured') === 'true';
                        if (aFeatured && !bFeatured) return -1;
                        if (!aFeatured && bFeatured) return 1;
                        return 0;
                    default:
                        return 0;
                }
            });

            // Add animation when reordering
            productGrid.style.opacity = '0.7';
            setTimeout(() => {
                productCards.forEach(card => productGrid.appendChild(card));
                productGrid.style.opacity = '1';
            }, 150);
        }

        // Update results display
        function updateResultsDisplay(count) {
            const existingMessage = document.querySelector('.search-results-message');
            if (existingMessage) {
                existingMessage.remove();
            }

            if (count === 0) {
                const message = document.createElement('div');
                message.className = 'empty-message search-results-message';
                message.innerHTML = `
                    <h3>🔍 No Results Found</h3>
                    <p>Try adjusting your search terms or filters to find what you're looking for.</p>
                `;
                document.getElementById('productGrid').parentNode.insertBefore(message, document.getElementById('productGrid'));
            }
        }

        // Enhanced add to cart functionality
        function addToCart(productId) {
            const button = event.target;
            const originalText = button.textContent;
            
            // Add loading state
            button.classList.add('loading');
            button.textContent = '⏳ Adding...';
            
            fetch('addToCart?productId=' + productId, {
                credentials: 'include'
            })
            .then(response => {
                if (response.status === 401) {
                    window.location.href = 'login.jsp?returnUrl=' + encodeURIComponent(window.location.pathname);
                    return Promise.reject('Unauthorized');
                }
                return response.json();
            })
            .then(data => {
                button.classList.remove('loading');
                
                if (data.success) {
                    button.textContent = '✅ Added!';
                    button.style.background = 'linear-gradient(135deg, #27ae60 0%, #2ecc71 100%)';
                    
                    // Update cart count with animation
                    const cartCounts = document.querySelectorAll('.cart-count');
                    cartCounts.forEach(el => {
                        el.style.transform = 'scale(1.3)';
                        el.textContent = data.cartCount;
                        setTimeout(() => {
                            el.style.transform = 'scale(1)';
                        }, 200);
                    });

                    // Handle stock updates
                    if (data.stockUpdated !== undefined) {
                        const stockInfo = button.parentNode.querySelector('.stock-info span');
                        if (data.stockUpdated === 0) {
                            button.disabled = true;
                            button.textContent = '❌ Out of Stock';
                            button.style.background = 'linear-gradient(135deg, #6c757d 0%, #5a6268 100%)';
                            if (stockInfo) {
                                stockInfo.textContent = '❌ Out of Stock';
                                stockInfo.className = 'out-of-stock';
                            }
                        } else if (data.stockUpdated <= 5) {
                            if (stockInfo) {
                                stockInfo.textContent = `⚠️ Only ${data.stockUpdated} left!`;
                                stockInfo.className = 'in-stock';
                            }
                        } else {
                            if (stockInfo) {
                                stockInfo.textContent = `✅ In Stock (${data.stockUpdated} available)`;
                                stockInfo.className = 'in-stock';
                            }
                        }
                    }

                    // Reset button after delay
                    if (!button.disabled) {
                        setTimeout(() => {
                            button.textContent = originalText;
                            button.style.background = 'linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%)';
                        }, 2000);
                    }
                } else {
                    button.textContent = '❌ Error';
                    setTimeout(() => {
                        button.textContent = originalText;
                    }, 2000);
                    alert(data.message || "Failed to add to cart.");
                }
            })
            .catch(err => {
                button.classList.remove('loading');
                if (err !== 'Unauthorized') {
                    console.error("Add to cart error", err);
                    button.textContent = '❌ Error';
                    setTimeout(() => {
                        button.textContent = originalText;
                    }, 2000);
                }
            });
        }

        // Enhanced button interactions with ripple effect
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn, .add-to-cart, .promo-btn');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    if (this.disabled) return;
                    
                    // Create ripple effect
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

            // Initialize URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('search')) {
                document.getElementById('searchInput').value = urlParams.get('search');
                searchBooks();
            }
            if (urlParams.has('genre')) {
                document.getElementById('genreFilter').value = urlParams.get('genre');
                filterProducts();
            }
            if (urlParams.has('price')) {
                document.getElementById('priceFilter').value = urlParams.get('price');
                filterProducts();
            }
            if (urlParams.has('sort')) {
                document.getElementById('sortFilter').value = urlParams.get('sort');
                sortProducts();
            }

            // Animate product cards on scroll
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

            // Observe product cards for animation
            document.querySelectorAll('.product-card').forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                card.style.transition = 'all 0.6s ease-out';
                observer.observe(card);
            });
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
            
            .loading {
                opacity: 0.7 !important;
                pointer-events: none !important;
            }
        `;
        document.head.appendChild(style);

        // Smooth scrolling for anchor links
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
    </script>
</body>
</html>