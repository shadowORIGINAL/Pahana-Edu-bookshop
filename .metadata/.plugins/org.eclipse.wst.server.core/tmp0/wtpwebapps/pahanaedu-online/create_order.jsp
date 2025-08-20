<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.User" %>
<%@ page import="com.pahanaedu.model.Product" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null || (!loggedInUser.getRole().equals("ADMIN") && !loggedInUser.getRole().equals("STAFF"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<User> customers = (List<User>) request.getAttribute("customers");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Order - Pahana Edu</title>
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

        /* Container */
        .container {
            max-width: 1000px;
            margin: 100px auto 0;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
        }

        h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 1.5rem;
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(255, 107, 107, 0.1), rgba(238, 90, 111, 0.1));
            border: 1px solid rgba(255, 107, 107, 0.3);
            padding: 1rem 2rem;
            border-radius: 12px;
            margin: 1rem 0;
            text-align: center;
            color: rgba(255, 255, 255, 0.9);
        }

        .form-group {
            margin-bottom: 2rem;
        }

        .form-group label {
            display: block;
            color: #ffffff;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-group select,
        .form-group input {
            width: 100%;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: #ffffff;
            font-size: 1rem;
            transition: all 0.3s ease;
            position: relative;
            appearance: none; /* Remove default dropdown arrow */
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="%23ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>');
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 12px;
        }

        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }

        .form-group select:hover,
        .form-group input[type="number"]:hover {
            border-color: rgba(255, 215, 0, 0.3);
            background: rgba(255, 215, 0, 0.05);
        }

        .form-group select option {
            background: #1a1a2e;
            color: #ffffff;
            padding: 0.5rem;
        }

        .product-row {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            align-items: center;
            background: rgba(255, 255, 255, 0.03);
            padding: 1rem;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        .product-row:hover {
            border-color: rgba(255, 215, 0, 0.3);
            background: rgba(255, 215, 0, 0.05);
            transform: translateY(-3px);
        }

        .product-select {
            flex: 3;
            position: relative;
        }

        .quantity-input {
            flex: 1;
            position: relative;
        }

        .quantity-input input[type="number"] {
            -moz-appearance: textfield; /* Remove Firefox number spinners */
        }

        .quantity-input input::-webkit-outer-spin-button,
        .quantity-input input::-webkit-inner-spin-button {
            -webkit-appearance: none; /* Remove Chrome number spinners */
            margin: 0;
        }

        .quantity-input::after {
            content: 'Qty';
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
            pointer-events: none;
        }

        .price-display {
            flex: 2;
            color: #ffd700;
            font-weight: 500;
            text-align: center;
        }

        .stock-display {
            flex: 1;
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
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
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: #ffffff;
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 107, 107, 0.4);
        }

        #addProduct {
            margin-bottom: 2rem;
        }

        .actions {
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                margin: 80px 1rem 0;
                padding: 1rem;
            }

            h1 {
                font-size: 2rem;
            }

            .product-row {
                flex-direction: column;
                align-items: stretch;
            }

            .product-select,
            .quantity-input,
            .price-display,
            .stock-display {
                flex: none;
                width: 100%;
                text-align: center;
            }

            .quantity-input::after {
                display: none;
            }

            .actions {
                flex-direction: column;
                align-items: center;
            }

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
    <!-- Navigation -->
    <nav class="navbar" id="navbar">
        <div class="nav-container">
            <a href="index.jsp" class="logo">
                📖 Pahana Edu
            </a>
            
            <ul class="nav-menu" id="navMenu">
                <li><a href="index.jsp" class="nav-link">Home</a></li>
                <li><a href="index.jsp#features" class="nav-link">Features</a></li>
                <li><a href="store" class="nav-link">Store</a></li>
                <li><a href="index.jsp#services" class="nav-link">Services</a></li>
                <li><a href="index.jsp#contact" class="nav-link">Contact</a></li>
            </ul>

            <div class="user-menu">
                <a href="<%= loggedInUser.getRole().equals("ADMIN") ? "admin_dashboard.jsp" : "staff_dashboard.jsp" %>" 
                   class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;">
                    👤 <%= loggedInUser.getFirstName() %>
                </a>
                <a href="LogoutServlet" class="btn btn-danger" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;" 
                   onclick="return confirm('Are you sure you want to logout?')">
                    🚪 Logout
                </a>
            </div>

            <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container">
        <h1>Create New Order</h1>
        
        <% if (error != null) { %>
            <div class="alert-error">
                <%= error %>
            </div>
        <% } %>
        
        <form action="ManageOrdersServlet" method="post">
            <input type="hidden" name="action" value="create">
            
            <div class="form-group">
                <label for="customerId">Customer:</label>
                <select id="customerId" name="customerId" required>
                    <option value="">Select Customer</option>
                    <% for (User customer : customers) { %>
                        <option value="<%= customer.getId() %>">
                            <%= customer.getFirstName() %> <%= customer.getLastName() %> - <%= customer.getEmail() %>
                        </option>
                    <% } %>
                </select>
            </div>
            
            <h3>Order Items</h3>
            <button type="button" id="addProduct" class="btn btn-primary">Add Product</button>
            
            <div id="productContainer">
                <!-- Product rows will be added here -->
            </div>
            
            <div class="actions">
                <input type="submit" value="Create Order" class="btn btn-primary">
                <a href="ManageOrdersServlet" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <script>
        const products = [
            <% for (Product product : products) { %>
                {
                    id: <%= product.getProductId() %>,
                    title: '<%= product.getTitle().replace("'", "\\'") %>',
                    author: '<%= product.getAuthor().replace("'", "\\'") %>',
                    price: <%= product.getPrice() %>,
                    discount: <%= product.getDiscountPercentage() %>,
                    stock: <%= product.getStockQuantity() %>
                },
            <% } %>
        ];
        
        let productCounter = 0;
        
        document.getElementById('addProduct').addEventListener('click', function() {
            addProductRow();
        });
        
        function addProductRow() {
            const container = document.getElementById('productContainer');
            const rowId = 'productRow_' + productCounter;
            
            const row = document.createElement('div');
            row.className = 'product-row';
            row.id = rowId;
            
            // Product select
            const selectDiv = document.createElement('div');
            selectDiv.className = 'product-select';
            
            const select = document.createElement('select');
            select.name = 'productId';
            select.required = true;
            select.addEventListener('change', function() { updateProductInfo(rowId); });
            
            const defaultOption = document.createElement('option');
            defaultOption.value = '';
            defaultOption.textContent = 'Select Product';
            select.appendChild(defaultOption);
            
            products.forEach(product => {
                const option = document.createElement('option');
                option.value = product.id;
                option.textContent = `${product.title} by ${product.author} - $${product.price.toFixed(2)}`;
                option.dataset.price = product.price;
                option.dataset.discount = product.discount;
                option.dataset.stock = product.stock;
                select.appendChild(option);
            });
            
            selectDiv.appendChild(select);
            row.appendChild(selectDiv);
            
            // Quantity input
            const quantityDiv = document.createElement('div');
            quantityDiv.className = 'quantity-input';
            
            const quantityInput = document.createElement('input');
            quantityInput.type = 'number';
            quantityInput.name = 'quantity';
            quantityInput.min = '1';
            quantityInput.value = '1';
            quantityInput.required = true;
            quantityInput.addEventListener('input', function() { updateProductInfo(rowId); });
            
            quantityDiv.appendChild(quantityInput);
            row.appendChild(quantityDiv);
            
            // Stock display
            const stockDiv = document.createElement('div');
            stockDiv.className = 'stock-display';
            stockDiv.id = rowId + '_stock';
            stockDiv.textContent = 'Stock: 0';
            row.appendChild(stockDiv);
            
            // Price display
            const priceDiv = document.createElement('div');
            priceDiv.className = 'price-display';
            priceDiv.id = rowId + '_price';
            priceDiv.textContent = 'Total: $0.00';
            row.appendChild(priceDiv);
            
            // Remove button
            const removeDiv = document.createElement('div');
            
            const removeButton = document.createElement('button');
            removeButton.type = 'button';
            removeButton.className = 'btn btn-danger';
            removeButton.textContent = 'Remove';
            removeButton.addEventListener('click', function() {
                container.removeChild(row);
            });
            
            removeDiv.appendChild(removeButton);
            row.appendChild(removeDiv);
            
            container.appendChild(row);
            productCounter++;
            
            // Observe the new row for animation
            row.style.opacity = '0';
            row.style.transform = 'translateY(30px)';
            row.style.transition = 'all 0.6s ease-out';
            observer.observe(row);
        }
        
        function updateProductInfo(rowId) {
            const row = document.getElementById(rowId);
            const select = row.querySelector('select');
            const quantityInput = row.querySelector('input[type="number"]');
            const stockDisplay = document.getElementById(rowId + '_stock');
            const priceDisplay = document.getElementById(rowId + '_price');
            
            if (select.value && quantityInput.value) {
                const selectedOption = select.options[select.selectedIndex];
                const price = parseFloat(selectedOption.dataset.price);
                const discount = parseFloat(selectedOption.dataset.discount);
                const stock = parseInt(selectedOption.dataset.stock);
                const quantity = parseInt(quantityInput.value);
                
                // Update stock display
                stockDisplay.textContent = `Stock: ${stock}`;
                
                // Validate quantity against stock
                if (quantity > stock) {
                    alert(`Only ${stock} items available in stock`);
                    quantityInput.value = stock;
                    return;
                }
                
                // Calculate and display price
                const discountedPrice = price * (1 - (discount / 100));
                const total = discountedPrice * quantity;
                
                let priceText = `Total: $${total.toFixed(2)}`;
                if (discount > 0) {
                    priceText += ` ($${price.toFixed(2)} x ${quantity} - ${discount}% off)`;
                } else {
                    priceText += ` ($${price.toFixed(2)} x ${quantity})`;
                }
                
                priceDisplay.textContent = priceText;
            }
        }
        
        // Add first product row by default
        window.onload = function() {
            addProductRow();
        };

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
    </script>
</body>
</html>