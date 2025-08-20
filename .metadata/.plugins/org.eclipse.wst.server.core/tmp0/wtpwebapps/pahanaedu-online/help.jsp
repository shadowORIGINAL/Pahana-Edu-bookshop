<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        role = "CUSTOMER"; // Default to Customer for non-logged-in users
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Support - Pahana Edu</title>
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
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* Particle Animation Background */
        .particle {
            position: fixed;
            color: rgba(255, 215, 0, 0.3);
            font-size: 1.2rem;
            pointer-events: none;
            z-index: 0;
            animation: floatParticle 10s ease-in-out infinite;
        }

        @keyframes floatParticle {
            0%, 100% { transform: translate(0, 0); opacity: 0.3; }
            50% { transform: translate(20px, -30px); opacity: 0.7; }
        }

        /* Navigation */
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

        /* Main Content */
        .container {
            max-width: 800px;
            margin: 120px auto 2rem;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            position: relative;
            z-index: 1;
        }

        h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 2rem;
            text-align: center;
            background: linear-gradient(135deg, #ffd700, #ff6b6b);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        h2 {
            font-size: 1.8rem;
            font-weight: 600;
            margin: 1.5rem 0 1rem;
            color: #ffffff;
        }

        /* Accordion Styles */
        .faq-item {
            margin-bottom: 1rem;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .faq-item input[type="checkbox"] {
            display: none;
        }

        .faq-item label {
            display: block;
            padding: 1rem;
            font-size: 1.2rem;
            font-weight: 600;
            color: #ffd700;
            cursor: pointer;
            position: relative;
            transition: all 0.3s ease;
        }

        .faq-item label::after {
            content: '▼';
            position: absolute;
            right: 1rem;
            font-size: 0.8rem;
            transition: transform 0.3s ease;
        }

        .faq-item input:checked + label::after {
            transform: rotate(180deg);
        }

        .faq-item .faq-content {
            max-height: 0;
            overflow: hidden;
            padding: 0 1rem;
            transition: max-height 0.3s ease, padding 0.3s ease;
        }

        .faq-item input:checked + label + .faq-content {
            max-height: 200px; /* Adjust based on content size */
            padding: 1rem;
        }

        .faq-item:hover {
            background: rgba(255, 215, 0, 0.05);
            transform: translateY(-2px);
        }

        .faq-content p {
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.9);
        }

        /* Contact Form */
        .contact-form {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 2rem;
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            color: #ffffff;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: #ffffff;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        /* Buttons */
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
            background: linear-gradient(135deg, #ffd700, #ffed4e);
            color: #0f0f0f;
            box-shadow: 0 8px 32px rgba(255, 215, 0, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 215, 0, 0.4);
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

        .btn-danger {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            color: #ffffff;
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 107, 107, 0.4);
        }

        .btn-info {
            background: linear-gradient(135deg, #4ecdc4, #44a08d);
            color: #ffffff;
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(78, 205, 196, 0.4);
        }

        /* Footer */
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

        /* Scroll to top button */
        .scroll-top {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ffd700, #ffed4e);
            color: #0f0f0f;
            border: none;
            border-radius: 50%;
            font-size: 1.2rem;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .scroll-top.visible {
            opacity: 1;
            visibility: visible;
        }

        .scroll-top:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 215, 0, 0.4);
        }

        /* Loading animation */
        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #0f0f0f, #1a1a2e);
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

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
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

            .container {
                margin: 100px 1rem 1rem;
                padding: 1rem;
            }

            h1 {
                font-size: 2rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            .user-menu {
                gap: 0.5rem;
            }

            .contact-form {
                padding: 1.5rem;
            }
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

        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }

        /* Custom scrollbar */
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
                <li><a href="index.jsp" class="nav-link">Home</a></li>
                <li><a href="index.jsp#features" class="nav-link">Features</a></li>
                <li><a href="products.jsp" class="nav-link">Store</a></li>
                <li><a href="index.jsp#services" class="nav-link">Services</a></li>
                <li><a href="index.jsp#contact" class="nav-link">Contact</a></li>
                <li><a href="help.jsp" class="nav-link">Help</a></li>
            </ul>

            <div class="user-menu">
                <% 
                    User user = (User) session.getAttribute("user");
                    boolean isLoggedIn = (user != null);
                    String firstName = isLoggedIn ? user.getFirstName() : "Guest";
                %>
                <% if (isLoggedIn) { %>
                    <% 
                        String roleBasedLink;
                        if ("ADMIN".equalsIgnoreCase(role)) {
                            roleBasedLink = "admin_dashboard.jsp";
                        } else if ("STAFF".equalsIgnoreCase(role)) {
                            roleBasedLink = "staff_dashboard.jsp";
                        } else {
                            roleBasedLink = "profile.jsp";
                        }
                    %>
                    <a href="<%= roleBasedLink %>" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;">
                        👤 <%= firstName %>
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

    <div class="container">
        <h1 id="helpTitle">Help & Support</h1>

        <% if (role.equalsIgnoreCase("ADMIN")) { %>
            <h2>Admin FAQs</h2>
            <div class="faq-item">
                <input type="checkbox" id="faq1" name="faq">
                <label for="faq1">How do I add a new staff member?</label>
                <div class="faq-content">
                    <p>Navigate to the "Manage Staff" page from the admin dashboard, click "Add Staff," and fill out the form with the staff member's details. A temporary password will be emailed to them.</p>
                </div>
            </div>
            <div class="faq-item">
                <input type="checkbox" id="faq2" name="faq">
                <label for="faq2">How can I manage products?</label>
                <div class="faq-content">
                    <p>Go to the admin dashboard and select "Manage Products." You can add, edit, or delete products, including setting prices and stock quantities.</p>
                </div>
            </div>
            <div class="faq-item">
                <input type="checkbox" id="faq3" name="faq">
                <label for="faq3">How do I view all orders?</label>
                <div class="faq-content">
                    <p>From the admin dashboard, click "View Orders" to see a paginated list of all orders, including customer details and order statuses.</p>
                </div>
            </div>
        <% } else if (role.equalsIgnoreCase("STAFF")) { %>
            <h2>Staff FAQs</h2>
            <div class="faq-item">
                <input type="checkbox" id="faq1" name="faq">
                <label for="faq1">How do I add a new customer?</label>
                <div class="faq-content">
                    <p>Go to the "Manage Customers" page from the staff dashboard, click "Add Customer," and complete the form. The customer will receive an email with their login credentials.</p>
                </div>
            </div>
            <div class="faq-item">
                <input type="checkbox" id="faq2" name="faq">
                <label for="faq2">Can I update product stock?</label>
                <div class="faq-content">
                    <p>Yes, from the staff dashboard, navigate to "Manage Products" to update stock quantities or other product details as authorized.</p>
                </div>
            </div>
            <div class="faq-item">
                <input type="checkbox" id="faq3" name="faq">
                <label for="faq3">How do I assist with customer orders?</label>
                <div class="faq-content">
                    <p>Access the "View Orders" section to see customer orders, check their status, and contact customers for any clarifications.</p>
                </div>
            </div>
        <% } else { %>
            <h2>Customer FAQs</h2>
            <div class="faq-item">
                <input type="checkbox" id="faq1" name="faq">
                <label for="faq1">How do I place an order?</label>
                <div class="faq-content">
                    <p>Browse products on the "Browse Products" page, add items to your cart, and proceed to checkout to place your order.</p>
                </div>
            </div>
            <div class="faq-item">
                <input type="checkbox" id="faq2" name="faq">
                <label for="faq2">How can I reset my password?</label>
                <div class="faq-content">
                    <p>Click "Forgot Password" on the login page, enter your email, and follow the link sent to your email to reset your password.</p>
                </div>
            </div>
            <div class="faq-item">
                <input type="checkbox" id="faq3" name="faq">
                <label for="faq3">Where can I view my order history?</label>
                <div class="faq-content">
                    <p>Log in and go to the "My Orders" page to see a list of your past orders, including details and statuses.</p>
                </div>
            </div>
        <% } %>

        <div class="contact-form">
            <h2>Quick Contact</h2>
            <form id="quickContactForm">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="question">Your Question</label>
                    <textarea id="question" name="question" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">📨 Submit Question</button>
            </form>
        </div>
    </div>

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
                        <li><a href="index.jsp">Home</a></li>
                        <li><a href="products.jsp">Browse Resources</a></li>
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
                        <li><a href="products.jsp?category=fiction">Fiction</a></li>
                        <li><a href="products.jsp?category=non-fiction">Non-Fiction</a></li>
                        <li><a href="products.jsp?category=science">Science & Technology</a></li>
                        <li><a href="products.jsp?category=biography">Biography</a></li>
                        <li><a href="products.jsp?category=children">Children's Books</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Customer Service</h4>
                    <ul>
                        <li><a href="help.jsp">Help Center</a></li>
                        <li><a href="index.jsp#services">Shipping Info</a></li>
                        <li><a href="index.jsp#services">Returns & Refunds</a></li>
                        <li><a href="index.jsp#contact">Privacy Policy</a></li>
                        <li><a href="index.jsp#contact">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 Pahana Edu. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Scroll to Top Button -->
    <button class="scroll-top" id="scrollTop">↑</button>

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
            const scrollTop = document.getElementById('scrollTop');
            
            if (window.scrollY > 100) {
                navbar.classList.add('scrolled');
                scrollTop.classList.add('visible');
            } else {
                navbar.classList.remove('scrolled');
                scrollTop.classList.remove('visible');
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

        // Scroll to top functionality
        document.getElementById('scrollTop').addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });

        // Button ripple effect
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn');
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

        // Observe container and FAQ items for animation
        const container = document.querySelector('.container');
        container.style.opacity = '0';
        container.style.transform = 'translateY(30px)';
        container.style.transition = 'all 0.6s ease-out';
        observer.observe(container);

        const faqItems = document.querySelectorAll('.faq-item');
        faqItems.forEach(item => {
            item.style.opacity = '0';
            item.style.transform = 'translateY(30px)';
            item.style.transition = 'all 0.6s ease-out';
            observer.observe(item);
        });

        // Dynamic typing effect for help title
        function typeWriter(element, text, speed = 100) {
            let i = 0;
            element.innerHTML = '';
            
            function type() {
                if (i < text.length) {
                    element.innerHTML += text.charAt(i);
                    i++;
                    setTimeout(type, speed);
                }
            }
            
            type();
        }

        setTimeout(() => {
            const helpTitle = document.getElementById('helpTitle');
            if (helpTitle) {
                const originalText = helpTitle.textContent;
                typeWriter(helpTitle, originalText, 50);
            }
        }, 2000);

        // Particle animation for background
        const particles = ['📚', '✏️', '📖', '🎓'];
        function createParticle() {
            const particle = document.createElement('div');
            particle.classList.add('particle');
            particle.innerHTML = particles[Math.floor(Math.random() * particles.length)];
            particle.style.left = `${Math.random() * 100}vw`;
            particle.style.top = `${Math.random() * 100}vh`;
            particle.style.animationDelay = `${Math.random() * 5}s`;
            document.body.appendChild(particle);
            setTimeout(() => particle.remove(), 10000);
        }

        setInterval(createParticle, 2000);

        // Quick contact form submission
        document.getElementById('quickContactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const successMsg = document.createElement('div');
            successMsg.innerHTML = `
                <div style="background: linear-gradient(135deg, #4CAF50, #45a049); color: white; padding: 1rem 2rem; border-radius: 12px; margin: 1rem 0; text-align: center; animation: slideInUp 0.5s ease-out;">
                    ✅ Question submitted successfully! We'll get back to you soon.
                </div>
            `;
            
            this.parentNode.insertBefore(successMsg, this.nextSibling);
            this.reset();
            
            setTimeout(() => {
                successMsg.remove();
            }, 5000);
        });
    </script>
</body>
</html>