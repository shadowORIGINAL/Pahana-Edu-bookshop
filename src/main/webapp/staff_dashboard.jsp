<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.pahanaedu.model.User" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    
    if (user == null || !user.getRole().equals("STAFF")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Pahana Edu</title>
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

        /* Navigation Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            left: -300px;
            width: 300px;
            height: 100vh;
            background: rgba(15, 15, 15, 0.98);
            backdrop-filter: blur(20px);
            border-right: 1px solid rgba(255, 255, 255, 0.1);
            z-index: 1000;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .sidebar.active {
            left: 0;
        }

        .sidebar-header {
            padding: 2rem 2rem 0 2rem;
            margin-bottom: 2rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 2rem;
            flex-shrink: 0;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffd700;
            text-decoration: none;
            margin-bottom: 0.5rem;
        }

        .admin-badge {
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            color: #0f0f0f;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .sidebar-nav {
            padding: 0 1rem;
            flex: 1;
            overflow-y: auto;
            margin-bottom: 1rem;
        }

        .nav-section {
            margin-bottom: 2rem;
        }

        .nav-section-title {
            color: rgba(255, 255, 255, 0.5);
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 1rem;
            padding: 0 1rem;
        }

        .nav-item {
            margin-bottom: 0.5rem;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 12px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 215, 0, 0.1), transparent);
            transition: all 0.5s ease;
        }

        .nav-link:hover::before {
            left: 100%;
        }

        .nav-link:hover {
            background: rgba(255, 215, 0, 0.1);
            color: #ffd700;
            transform: translateX(5px);
        }

        .nav-link.active {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.2) 0%, rgba(255, 107, 107, 0.1) 100%);
            color: #ffd700;
            border: 1px solid rgba(255, 215, 0, 0.3);
        }

        .nav-icon {
            font-size: 1.2rem;
            width: 24px;
            text-align: center;
        }

        .user-section {
            position: sticky;
            bottom: 0;
            margin-top: auto;
            margin-left: 1rem;
            margin-right: 1rem;
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: #0f0f0f;
            font-weight: bold;
        }

        .user-details h4 {
            color: #ffd700;
            font-size: 1rem;
            margin-bottom: 0.2rem;
        }

        .user-details p {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.8rem;
        }

        .logout-btn {
            width: 100%;
            padding: 0.8rem;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
        }

        /* Main Content */
        .main-content {
            margin-left: 0;
            min-height: 100vh;
            transition: all 0.3s ease;
        }

        .main-content.shifted {
            margin-left: 300px;
        }

        /* Top Bar */
        .top-bar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: 80px;
            background: rgba(15, 15, 15, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            z-index: 999;
            display: flex;
            align-items: center;
            padding: 0 2rem;
            transition: all 0.3s ease;
        }

        .hamburger-btn {
            background: none;
            border: none;
            color: #ffd700;
            font-size: 1.5rem;
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .hamburger-btn:hover {
            background: rgba(255, 215, 0, 0.1);
            transform: scale(1.1);
        }

        .top-bar-title {
            margin-left: 2rem;
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffffff;
        }

        .top-bar-actions {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .notification-btn {
            position: relative;
            background: rgba(255, 255, 255, 0.1);
            border: none;
            color: #ffffff;
            padding: 0.8rem;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .notification-btn:hover {
            background: rgba(255, 215, 0, 0.2);
            color: #ffd700;
        }

        .notification-badge {
            position: absolute;
            top: 0;
            right: 0;
            background: #ff6b6b;
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Content Area */
        .content-area {
            padding: 100px 2rem 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Dashboard Cards */
        .welcome-section {
            text-align: center;
            margin-bottom: 3rem;
            padding: 3rem;
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1) 0%, rgba(255, 107, 107, 0.1) 100%);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
        }

        .welcome-section h1 {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 50%, #4ecdc4 100%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .welcome-section p {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 2rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: conic-gradient(from 0deg, transparent, rgba(255, 215, 0, 0.1), transparent);
            transition: all 0.3s ease;
            opacity: 0;
        }

        .stat-card:hover {
            transform: translateY(-10px);
            border-color: rgba(255, 215, 0, 0.3);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .stat-card:hover::before {
            opacity: 1;
            animation: rotate 2s linear infinite;
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            display: block;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: #ffd700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            margin: 3rem 0;
        }

        .dashboard-card {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(20px);
            padding: 3rem;
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .dashboard-card::before {
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

        .dashboard-card:hover::before {
            transform: scaleX(1);
        }

        .dashboard-card:hover {
            transform: translateY(-10px);
            border-color: rgba(255, 215, 0, 0.3);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .card-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            display: block;
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 1rem;
        }

        .card-description {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .card-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f0f;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 8px 32px rgba(255, 215, 0, 0.3);
            position: relative;
            overflow: hidden;
        }

        .card-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: all 0.5s ease;
        }

        .card-button:hover::before {
            left: 100%;
        }

        .card-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 215, 0, 0.4);
            text-decoration: none;
            color: #0f0f0f;
        }

        /* Quick Actions */
        .quick-actions {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(20px);
            padding: 2rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            margin: 2rem 0;
        }

        .quick-actions h3 {
            color: #ffd700;
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            text-align: center;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .action-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.8rem 1.5rem;
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .action-btn:hover {
            background: rgba(255, 215, 0, 0.2);
            border-color: rgba(255, 215, 0, 0.3);
            color: #ffd700;
            transform: translateY(-2px);
            text-decoration: none;
        }

        /* Recent Activity */
        .activity-item {
            padding: 1rem;
            margin: 0.5rem 0;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            border-left: 4px solid #ffd700;
            transition: all 0.3s ease;
        }

        .activity-item:hover {
            background: rgba(255, 215, 0, 0.1);
            transform: translateX(5px);
        }

        .activity-item strong {
            color: #ffd700;
        }

        .activity-time {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.5);
            margin-top: 0.3rem;
        }

        /* Overlay */
        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .sidebar-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        /* Animations */
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

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

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                width: 280px;
            }

            .main-content.shifted {
                margin-left: 0;
            }

            .content-area {
                padding: 100px 1rem 2rem;
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .action-buttons {
                flex-direction: column;
            }

            .welcome-section h1 {
                font-size: 2rem;
            }

            .top-bar-title {
                display: none;
            }
        }

        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .dashboard-card {
                padding: 2rem;
            }

            .welcome-section {
                padding: 2rem;
            }
        }

        /* Dark mode scrollbar */
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
    <!-- Sidebar Overlay -->
    <div class="sidebar-overlay" id="sidebarOverlay"></div>

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <a href="#" class="sidebar-logo">
                📖 Pahana Edu
            </a>
            <div class="admin-badge">👑 Staff Panel</div>
        </div>

        <div class="sidebar-nav">
            <div class="nav-section">
                <div class="nav-section-title">Dashboard</div>
                <div class="nav-item">
                    <a href="#" class="nav-link active">
                        <span class="nav-icon">🏠</span>
                        <span>Overview</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="view_reports.jsp" class="nav-link">
                        <span class="nav-icon">📊</span>
                        <span>Analytics</span>
                    </a>
                </div>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Management</div>
                <div class="nav-item">
                    <a href="manage_staff.jsp" class="nav-link">
                        <span class="nav-icon">👥</span>
                        <span>Staff Management</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="manage_customers.jsp" class="nav-link">
                        <span class="nav-icon">👤</span>
                        <span>Customer Management</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="ManageProductsServlet" class="nav-link">
                        <span class="nav-icon">📚</span>
                        <span>Inventory Control</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="ManageOrdersServlet" class="nav-link">
                        <span class="nav-icon">📦</span>
                        <span>Order Management</span>
                    </a>
                </div>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Operations</div>
                <div class="nav-item">
                    <a href="add_staff.jsp" class="nav-link">
                        <span class="nav-icon">➕</span>
                        <span>Add New Staff</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="system_settings.jsp" class="nav-link">
                        <span class="nav-icon">⚙️</span>
                        <span>System Settings</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="backup_data.jsp" class="nav-link">
                        <span class="nav-icon">💾</span>
                        <span>Backup Data</span>
                    </a>
                </div>
            </div>

            <div class="nav-section">
                <div class="nav-section-title">Store</div>
                <div class="nav-item">
                    <a href="../index.jsp" class="nav-link">
                        <span class="nav-icon">🏪</span>
                        <span>View Store</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="../store" class="nav-link">
                        <span class="nav-icon">🛍️</span>
                        <span>Browse Products</span>
                    </a>
                </div>
            </div>
        </div>

        <div class="user-section">
            <div class="user-info">
                <div class="user-avatar">
                    <%= user.getFirstName().substring(0, 1).toUpperCase() %>
                </div>
                <div class="user-details">
                    <h4><%= user.getFirstName() %> <%= user.getLastName() %></h4>
                    <p>System Administrator</p>
                </div>
            </div>
            <a href="LogoutServlet" class="logout-btn" onclick="return confirmLogout()">
                🚪 Logout
            </a>
        </div>
    </nav>

    <!-- Top Bar -->
	<div class="top-bar">
	    <button class="hamburger-btn" id="hamburgerBtn">☰</button>
	    <h1 class="top-bar-title">Staff Dashboard</h1>
	    <div class="top-bar-actions">
	        <a href="profile.jsp" class="profile-btn" title="Edit Profile">
	            <span class="profile-icon">👤</span>
	            <span class="profile-text">Profile</span>
	        </a>
	        <button class="notification-btn">
	            🔔
	            <span class="notification-badge">3</span>
	        </button>
	    </div>
	</div>

    <!-- Main Content -->
    <main class="main-content" id="mainContent">
        <div class="content-area">
            <!-- Welcome Section -->
            <section class="welcome-section">
                <h1>Staff Control Center</h1>
                <p>Manage your bookshop's operations, staff, and customers from one central location</p>
                <div style="font-size: 0.9rem; color: rgba(255, 255, 255, 0.5); margin-top: 1rem;">
                    Last accessed: <span id="currentTime"></span>
                </div>
            </section>

            <!-- Quick Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-icon">👥</span>
                    <div class="stat-number">24</div>
                    <div class="stat-label">Total Staff</div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">👤</span>
                    <div class="stat-number">156</div>
                    <div class="stat-label">Active Customers</div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">📚</span>
                    <div class="stat-number">2.5K</div>
                    <div class="stat-label">Books in Stock</div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">📦</span>
                    <div class="stat-number">89</div>
                    <div class="stat-label">Pending Orders</div>
                </div>
            </div>

            <!-- Main Dashboard Cards -->
            <div class="dashboard-grid">

                <div class="dashboard-card">
                    <span class="card-icon">👤</span>
                    <h3 class="card-title">Customer Management</h3>
                    <p class="card-description">
                        View and manage customer accounts, orders, and support requests. Keep your customers happy and engaged.
                    </p>
                    <a href="manage_customers.jsp" class="card-button">
                        👥 Manage Customers
                    </a>
                </div>

                <div class="dashboard-card">
                    <span class="card-icon">📚</span>
                    <h3 class="card-title">Inventory Control</h3>
                    <p class="card-description">
                        Monitor book inventory, track sales, and manage your catalog. Keep your shelves perfectly stocked.
                    </p>
                    <a href="ManageProductsServlet" class="card-button">
                        📦 Manage Inventory
                    </a>
                </div>

                <div class="dashboard-card">
                    <span class="card-icon">📋</span>
                    <h3 class="card-title">Order Management</h3>
                    <p class="card-description">
                        Process orders, track shipments, and manage the entire order lifecycle from purchase to delivery.
                    </p>
                    <a href="ManageOrdersServlet" class="card-button">
                        🚚 Manage Orders
                    </a>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <h3>⚡ Quick Actions</h3>
                <div class="action-buttons">
                    <a href="view_reports.jsp" class="action-btn">📈 View Reports</a>
                    <a href="system_settings.jsp" class="action-btn">⚙️ System Settings</a>
                    <a href="backup_data.jsp" class="action-btn">💾 Backup Data</a>
                </div>
            </div>

            <!-- Recent Activity Section -->
            <div class="quick-actions">
                <h3>📋 Recent Activity</h3>
                <div style="text-align: left; margin-top: 1rem;">
                    <div class="activity-item">
                        <strong>Customer registration:</strong> 5 new customers registered today
                        <div class="activity-time">4 hours ago</div>
                    </div>
                    <div class="activity-item">
                        <strong>System update:</strong> Database backup completed successfully
                        <div class="activity-time">6 hours ago</div>
                    </div>
                    <div class="activity-item">
                        <strong>Order processed:</strong> 12 orders shipped to customers
                        <div class="activity-time">8 hours ago</div>
                    </div>
                </div>
            </div>

            <!-- System Status -->
            <div class="quick-actions">
                <h3>🔧 System Status</h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-top: 1rem;">
                    <div style="padding: 1rem; background: rgba(40, 167, 69, 0.2); border-radius: 12px; border-left: 4px solid #28a745; text-align: center;">
                        <div style="color: #28a745; font-weight: bold;">Server Status</div>
                        <div style="color: rgba(255, 255, 255, 0.8); font-size: 0.9rem;">Online</div>
                    </div>
                    <div style="padding: 1rem; background: rgba(40, 167, 69, 0.2); border-radius: 12px; border-left: 4px solid #28a745; text-align: center;">
                        <div style="color: #28a745; font-weight: bold;">Database</div>
                        <div style="color: rgba(255, 255, 255, 0.8); font-size: 0.9rem;">Connected</div>
                    </div>
                    <div style="padding: 1rem; background: rgba(255, 193, 7, 0.2); border-radius: 12px; border-left: 4px solid #ffc107; text-align: center;">
                        <div style="color: #ffc107; font-weight: bold;">Backup</div>
                        <div style="color: rgba(255, 255, 255, 0.8); font-size: 0.9rem;">Scheduled</div>
                    </div>
                    <div style="padding: 1rem; background: rgba(40, 167, 69, 0.2); border-radius: 12px; border-left: 4px solid #28a745; text-align: center;">
                        <div style="color: #28a745; font-weight: bold;">Security</div>
                        <div style="color: rgba(255, 255, 255, 0.8); font-size: 0.9rem;">Secure</div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        // Sidebar toggle functionality
        const hamburgerBtn = document.getElementById('hamburgerBtn');
        const sidebar = document.getElementById('sidebar');
        const sidebarOverlay = document.getElementById('sidebarOverlay');
        const mainContent = document.getElementById('mainContent');

        function toggleSidebar() {
            sidebar.classList.toggle('active');
            sidebarOverlay.classList.toggle('active');
            
            // Update hamburger icon
            hamburgerBtn.innerHTML = sidebar.classList.contains('active') ? '✕' : '☰';
            
            // For desktop, shift main content
            if (window.innerWidth > 768) {
                mainContent.classList.toggle('shifted');
            }
        }

        hamburgerBtn.addEventListener('click', toggleSidebar);
        sidebarOverlay.addEventListener('click', toggleSidebar);

        // Close sidebar when clicking nav links on mobile
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => {
                if (window.innerWidth <= 768) {
                    toggleSidebar();
                }
            });
        });

        // Handle window resize
        window.addEventListener('resize', () => {
            if (window.innerWidth <= 768) {
                mainContent.classList.remove('shifted');
            } else if (sidebar.classList.contains('active')) {
                mainContent.classList.add('shifted');
            }
        });

        // Update current time
        function updateTime() {
            const now = new Date();
            const timeString = now.toLocaleString();
            const timeElement = document.getElementById('currentTime');
            if (timeElement) {
                timeElement.textContent = timeString;
            }
        }

        updateTime();
        setInterval(updateTime, 1000);

        // Logout confirmation
        function confirmLogout() {
            return confirm('Are you sure you want to logout from the Staff panel?');
        }

        // Add keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Toggle sidebar with Ctrl/Cmd + B
            if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
                e.preventDefault();
                toggleSidebar();
            }
            
            // Other shortcuts
            if (e.ctrlKey || e.metaKey) {
                switch(e.key) {
                    case '1':
                        e.preventDefault();
                        window.location.href = 'manage_customers.jsp';
                        break;
                    case '2':
                        e.preventDefault();
                        window.location.href = 'ManageProductsServlet';
                        break;
                    case '3':
                        e.preventDefault();
                        window.location.href = 'ManageOrdersServlet';
                        break;
                    case 'q':
                        e.preventDefault();
                        if (confirmLogout()) {
                            window.location.href = 'LogoutServlet';
                        }
                        break;
                }
            }
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

        // Observe elements for animation
        document.querySelectorAll('.stat-card, .dashboard-card, .quick-actions').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'all 0.6s ease-out';
            observer.observe(el);
        });

        // Enhanced button interactions with ripple effect
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.card-button, .action-btn, .logout-btn');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
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

        // Real-time updates simulation (you can replace with actual WebSocket connections)
        function simulateRealTimeUpdates() {
            // Simulate notification updates
            const notificationBadge = document.querySelector('.notification-badge');
            let count = 3;
            
            setInterval(() => {
                // Random chance to add notification
                if (Math.random() > 0.97) {
                    count++;
                    notificationBadge.textContent = count;
                    
                    // Add visual feedback
                    notificationBadge.style.animation = 'none';
                    setTimeout(() => {
                        notificationBadge.style.animation = 'pulse 0.5s ease-in-out';
                    }, 10);
                }
            }, 5000);
        }

        // Add pulse animation for notifications
        const pulseStyle = document.createElement('style');
        pulseStyle.textContent = `
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.2); }
                100% { transform: scale(1); }
            }
        `;
        document.head.appendChild(pulseStyle);

        // Initialize real-time updates
        simulateRealTimeUpdates();

        // Add smooth scrolling for any anchor links
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

        // Add loading states for navigation
        document.querySelectorAll('.nav-link, .card-button').forEach(link => {
            link.addEventListener('click', function(e) {
                if (this.href && !this.href.includes('#')) {
                    // Add loading state
                    const originalText = this.innerHTML;
                    this.innerHTML = this.innerHTML.replace(/^([^<]*?)/, '⏳ Loading...');
                    this.style.opacity = '0.7';
                    this.style.pointerEvents = 'none';
                    
                    // Reset after a short delay if navigation fails
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.style.opacity = '1';
                        this.style.pointerEvents = 'auto';
                    }, 3000);
                }
            });
        });
    </script>
</body>
</html>