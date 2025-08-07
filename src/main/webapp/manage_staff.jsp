<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.User" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null || !loggedInUser.getRole().equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<User> staffList = (List<User>) request.getAttribute("staffList");
    String success = request.getParameter("success");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management - Pahana Edu Admin</title>
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

        /* Main Content */
        .main-content {
            padding: 8rem 0;
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a2e 100%);
            min-height: 100vh;
            position: relative;
            z-index: 1;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .section-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .section-title {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .section-subtitle {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.6);
            max-width: 600px;
            margin: 0 auto;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 2rem;
            margin: 1rem 0;
            border-radius: 12px;
            font-weight: 500;
            text-align: center;
            animation: slideInUp 0.5s ease-out;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(76, 175, 80, 0.1), rgba(69, 160, 73, 0.05));
            color: #ffffff;
            border: 1px solid rgba(76, 175, 80, 0.3);
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(255, 107, 107, 0.1), rgba(255, 107, 107, 0.05));
            color: #ffffff;
            border: 1px solid rgba(255, 107, 107, 0.3);
        }

        /* Section Card */
        .section-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 2rem;
            border-radius: 24px;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        .section-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 215, 0, 0.2);
        }

        .section-card h3 {
            color: #ffd700;
            margin-bottom: 1.5rem;
            font-size: 1.4rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Button Styles */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.8rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            border-radius: 50px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: none;
            cursor: pointer;
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

        .btn-success {
            background: linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%);
            color: #ffffff;
        }

        .btn-success:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(78, 205, 196, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: #ffffff;
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 107, 107, 0.4);
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

        .btn-info {
            background: linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%);
            color: #ffffff;
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(78, 205, 196, 0.4);
        }

        .btn-small {
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
        }

        /* Search Form */
        .search-container {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input {
            flex: 1;
            min-width: 300px;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: #ffffff;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }

        /* Table Styles */
        .table-container {
            overflow-x: auto;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .staff-table {
            width: 100%;
            border-collapse: collapse;
        }

        .staff-table thead {
            background: rgba(255, 215, 0, 0.1);
        }

        .staff-table th,
        .staff-table td {
            padding: 1.5rem;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .staff-table th {
            color: #ffd700;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        .staff-table td {
            color: rgba(255, 255, 255, 0.9);
        }

        .staff-table tbody tr:hover {
            background: rgba(255, 215, 0, 0.05);
        }

        .staff-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Status Badge */
        .status-badge {
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-active {
            background: linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%);
            color: #ffffff;
        }

        .status-inactive {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: #ffffff;
        }

        /* Action Buttons Container */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .action-form {
            display: inline;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            animation: fadeIn 0.3s ease;
        }

        .modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 2rem;
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            width: 90%;
            max-width: 500px;
            max-height: 80vh;
            overflow-y: auto;
            animation: slideInModal 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideInModal {
            from { opacity: 0; transform: translate(-50%, -60%); }
            to { opacity: 1; transform: translate(-50%, -50%); }
        }

        .modal h3 {
            color: #ffd700;
            margin-bottom: 1.5rem;
            text-align: center;
            font-size: 1.5rem;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #ffffff;
        }

        .form-group input,
        .form-group select {
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
        .form-group select:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            transform: scale(1.2);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.7);
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        /* Loading State */
        .loading {
            text-align: center;
            padding: 2rem;
            color: rgba(255, 255, 255, 0.7);
        }

        .spinner {
            border: 3px solid rgba(255, 255, 255, 0.1);
            border-top: 3px solid #ffd700;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
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

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Scroll to top button */
        .scroll-top {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
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

            .section-title {
                font-size: 2rem;
            }

            .container {
                padding: 0 1rem;
            }

            .section-card {
                padding: 1.5rem;
            }

            .search-container {
                flex-direction: column;
                align-items: stretch;
            }

            .search-input {
                min-width: auto;
            }

            .action-buttons {
                justify-content: center;
            }

            .staff-table th,
            .staff-table td {
                padding: 1rem;
                font-size: 0.9rem;
            }

            .modal {
                padding: 1.5rem;
                margin: 1rem;
                width: calc(100% - 2rem);
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

        /* Page Loader */
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
            </ul>

            <div class="user-menu">
                <a href="admin_dashboard.jsp" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;">
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
    <section class="main-content">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Staff Management</h2>
                <p class="section-subtitle">
                    Manage your team members and their access permissions
                </p>
            </div>

            <!-- Alert Messages -->
            <% if (success != null) { %>
                <div class="alert alert-success">
                    ✅ <%= success %>
                </div>
            <% } %>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    ❌ <%= error %>
                </div>
            <% } %>

            <!-- Add Staff Section -->
            <div class="section-card">
                <h3>🆕 Quick Actions</h3>
                <a href="add_staff.jsp" class="btn btn-info">
                    ➕ Add New Staff Member
                </a>
            </div>

            <!-- Search Section -->
            <div class="section-card">
                <h3>🔍 Search Staff</h3>
                <form id="searchForm" method="get" action="ManageStaffServlet">
                    <div class="search-container">
                        <input type="text" 
                               name="search" 
                               id="searchInput" 
                               placeholder="Search by name, email, or phone number..." 
                               class="search-input"
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <button type="submit" class="btn btn-primary">🔍 Search</button>
                        <button type="button" onclick="clearSearch()" class="btn btn-secondary">🗑️ Clear</button>
                    </div>
                </form>
            </div>

            <!-- Staff List Section -->
            <div class="section-card">
                <h3>👥 Staff Directory</h3>
                <div id="staffTableContainer">
                    <% if (staffList == null || staffList.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="empty-state-icon">👤</div>
                            <h3>No Staff Members Found</h3>
                            <p>No staff members match your search criteria, or no staff have been added yet.</p>
                            <a href="add_staff.jsp" class="btn btn-info" style="margin-top: 1rem;">
                                ➕ Add Your First Staff Member
                            </a>
                        </div>
                    <% } else { %>
                        <div class="table-container">
                            <table class="staff-table" id="staffTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Phone</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (User staff : staffList) { %>
                                    <tr>
                                        <td><strong>#<%= staff.getId() %></strong></td>
                                        <td>
                                            <strong><%= staff.getFirstName() %> <%= staff.getLastName() %></strong>
                                        </td>
                                        <td>
                                            <a href="mailto:<%= staff.getEmail() %>" style="color: #ffd700; text-decoration: none;">
                                                <%= staff.getEmail() %>
                                            </a>
                                        </td>
                                        <td>
                                            <% if (staff.getTelephone() != null && !staff.getTelephone().isEmpty()) { %>
                                                <a href="tel:<%= staff.getTelephone() %>" style="color: #ffd700; text-decoration: none;">
                                                    <%= staff.getTelephone() %>
                                                </a>
                                            <% } else { %>
                                                <span style="color: rgba(255, 255, 255, 0.7);">N/A</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="status-badge <%= staff.isActive() ? "status-active" : "status-inactive" %>">
                                                <%= staff.isActive() ? "Active" : "Inactive" %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <button onclick="openEditModal(<%= staff.getId() %>, '<%= staff.getEmail().replace("'", "\\'") %>', 
                                                    '<%= staff.getFirstName().replace("'", "\\'") %>', '<%= staff.getLastName().replace("'", "\\'") %>', 
                                                    '<%= staff.getAddress() != null ? staff.getAddress().replace("'", "\\'") : "" %>', 
                                                    '<%= staff.getTelephone() != null ? staff.getTelephone() : "" %>', 
                                                    <%= staff.isActive() %>)" 
                                                    class="btn btn-success btn-small">
                                                    ✏️ Edit
                                                </button>
                                                <form class="action-form" method="post" action="ManageStaffServlet">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="<%= staff.getId() %>">
                                                    <button type="submit" 
                                                            onclick="return confirmDelete('<%= staff.getFirstName() %> <%= staff.getLastName() %>')" 
                                                            class="btn btn-danger btn-small">
                                                        🗑️ Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Navigation -->
            <div style="text-align: center; margin-top: 2rem;">
                <a href="admin_dashboard.jsp" class="btn btn-secondary">
                    🏠 Back to Admin Dashboard
                </a>
            </div>
        </div>
    </section>

    <!-- Edit Modal -->
    <div id="editModalOverlay" class="modal-overlay">
        <div class="modal">
            <h3>✏️ Edit Staff Member</h3>
            <form method="post" action="ManageStaffServlet">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editId">
                
                <div class="form-group">
                    <label for="editEmail">📧 Email Address:</label>
                    <input type="email" name="email" id="editEmail" required>
                </div>
                
                <div class="form-group">
                    <label for="editFirstName">👤 First Name:</label>
                    <input type="text" name="first_name" id="editFirstName" required>
                </div>
                
                <div class="form-group">
                    <label for="editLastName">👤 Last Name:</label>
                    <input type="text" name="last_name" id="editLastName" required>
                </div>
                
                <div class="form-group">
                    <label for="editAddress">🏠 Address:</label>
                    <input type="text" name="address" id="editAddress">
                </div>
                
                <div class="form-group">
                    <label for="editTelephone">📱 Telephone:</label>
                    <input type="tel" name="telephone" id="editTelephone">
                </div>
                
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" name="is_active" id="editIsActive" value="true">
                        <label for="editIsActive">✅ Active Status</label>
                    </div>
                </div>
                
                <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 2rem;">
                    <button type="submit" class="btn btn-success">💾 Update Staff</button>
                    <button type="button" onclick="closeEditModal()" class="btn btn-secondary">❌ Cancel</button>
                </div>
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
                        <li><a href="index.jsp#home">Home</a></li>
                        <li><a href="store">Browse Resources</a></li>
                        <li><a href="ManageOrdersServlet?action=history">Order History</a></li>
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

        // Enhanced button interactions with ripple effect
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

        document.querySelectorAll('.section-card, .empty-state').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'all 0.6s ease-out';
            observer.observe(el);
        });

        // Modal functions
        function openEditModal(id, email, firstName, lastName, address, telephone, isActive) {
            document.getElementById('editId').value = id;
            document.getElementById('editEmail').value = email;
            document.getElementById('editFirstName').value = firstName;
            document.getElementById('editLastName').value = lastName;
            document.getElementById('editAddress').value = address || '';
            document.getElementById('editTelephone').value = telephone || '';
            document.getElementById('editIsActive').checked = isActive;
            document.getElementById('editModalOverlay').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }
        
        function closeEditModal() {
            document.getElementById('editModalOverlay').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
        
        // Close modal when clicking overlay
        document.getElementById('editModalOverlay').onclick = function(event) {
            if (event.target === this) {
                closeEditModal();
            }
        }
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeEditModal();
            }
        });
        
        function clearSearch() {
            document.getElementById('searchInput').value = '';
            window.location.href = 'ManageStaffServlet';
        }
        
        function confirmDelete(staffName) {
            return confirm('⚠️ Are you sure you want to delete ' + staffName + '?\n\nThis action cannot be undone.');
        }
        
        // Auto-refresh functionality with loading indicator
        let refreshInterval;
        
        function startAutoRefresh() {
            refreshInterval = setInterval(function() {
                fetchStaffData();
            }, 30000); // 30 seconds
        }
        
        function stopAutoRefresh() {
            if (refreshInterval) {
                clearInterval(refreshInterval);
            }
        }
        
        function showLoading() {
            document.getElementById('staffTableContainer').innerHTML = `
                <div class="loading">
                    <div class="spinner"></div>
                    <p>Refreshing staff data...</p>
                </div>
            `;
        }
        
        function fetchStaffData() {
            const searchTerm = document.getElementById('searchInput').value;
            const formData = new FormData();
            if (searchTerm) {
                formData.append('search', searchTerm);
            }
            
            showLoading();
            
            fetch('ManageStaffServlet', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.text();
            })
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const newTableContainer = doc.getElementById('staffTableContainer');
                if (newTableContainer) {
                    document.getElementById('staffTableContainer').innerHTML = newTableContainer.innerHTML;
                } else {
                    throw new Error('Could not find staff table in response');
                }
            })
            .catch(error => {
                console.error('Error refreshing staff data:', error);
                document.getElementById('staffTableContainer').innerHTML = `
                    <div class="empty-state">
                        <div class="empty-state-icon">⚠️</div>
                        <h3>Error Loading Data</h3>
                        <p>There was a problem refreshing the staff data. Please refresh the page manually.</p>
                        <button onclick="location.reload()" class="btn btn-primary" style="margin-top: 1rem;">
                            🔄 Refresh Page
                        </button>
                    </div>
                `;
            });
        }
        
        // Start auto-refresh when page loads
        document.addEventListener('DOMContentLoaded', function() {
            startAutoRefresh();
        });
        
        // Stop auto-refresh when page is hidden
        document.addEventListener('visibilitychange', function() {
            if (document.hidden) {
                stopAutoRefresh();
            } else {
                startAutoRefresh();
            }
        });
        
        // Enhanced form submission with better UX
        document.addEventListener('submit', function(e) {
            if (e.target.closest('form') && e.target.closest('form').action.includes('ManageStaffServlet')) {
                const submitBtn = e.target.querySelector('button[type="submit"], input[type="submit"]');
                if (submitBtn && !submitBtn.classList.contains('btn-danger')) {
                    const originalText = submitBtn.textContent || submitBtn.value;
                    submitBtn.disabled = true;
                    if (submitBtn.textContent) {
                        submitBtn.textContent = '⏳ Processing...';
                    } else {
                        submitBtn.value = 'Processing...';
                    }
                    
                    setTimeout(() => {
                        submitBtn.disabled = false;
                        if (submitBtn.textContent) {
                            submitBtn.textContent = originalText;
                        } else {
                            submitBtn.value = originalText;
                        }
                    }, 5000);
                }
            }
        });
        
        // Search enhancement - search as you type (with debounce)
        let searchTimeout;
        document.getElementById('searchInput').addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                if (this.value.length >= 2 || this.value.length === 0) {
                    document.getElementById('searchForm').submit();
                }
            }, 500);
        });
    </script>
</body>
</html>