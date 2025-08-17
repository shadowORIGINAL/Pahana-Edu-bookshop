<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Order" %>
<%@ page import="com.pahanaedu.model.User" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    boolean isAdminOrStaff = loggedInUser.getRole().equals("ADMIN") || loggedInUser.getRole().equals("STAFF");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isAdminOrStaff ? "Order Management" : "My Order History" %></title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Georgia', serif;
            background: linear-gradient(135deg, #faf7f2 0%, #f5f0e8 100%);
            color: #5d4e37;
            line-height: 1.6;
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
            color: #faf7f2;
            padding: 1rem 0;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
            margin-bottom: 2rem;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .logo {
            font-size: 2rem;
            font-weight: bold;
            color: #ffd700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            text-decoration: none;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .welcome-msg {
            color: #ffd700;
            font-size: 0.9rem;
        }

        .back-btn {
            display: inline-block;
            margin-bottom: 1rem;
            color: #8b4513;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        .back-btn:hover {
            color: #d2691e;
            text-decoration: underline;
        }

        .page-title {
            color: #8b4513;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #e6d7c3;
            padding-bottom: 0.5rem;
        }

        .alert-error {
            background: linear-gradient(135deg, #f2dede 0%, #ebccd1 100%);
            color: #a94442;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            text-align: center;
            border: 1px solid #ebccd1;
        }

        .empty-message {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin: 2rem 0;
        }

        .empty-message h3 {
            color: #8b4513;
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }

        .empty-message p {
            color: #666;
            font-size: 1.1rem;
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin: 1.5rem 0;
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .order-table th, 
        .order-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e6d7c3;
        }

        .order-table th {
            background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
            color: #ffd700;
            font-weight: bold;
        }

        .order-table tr:hover {
            background-color: #f5f0e8;
        }

        .status {
            font-weight: bold;
            padding: 0.3rem 0.6rem;
            border-radius: 15px;
            font-size: 0.9rem;
        }

        .status-completed {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-pending {
            background-color: #fff8e1;
            color: #ff8f00;
        }

        .status-cancelled {
            background-color: #ffebee;
            color: #c62828;
        }

        .action-btn {
            padding: 0.5rem 1rem;
            background: linear-gradient(135deg, #228b22 0%, #32cd32 100%);
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            font-size: 0.9rem;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(34, 139, 34, 0.3);
        }

        .action-btn-secondary {
            background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
        }

        .action-btn-secondary:hover {
            box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
        }

        .actions {
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        @media (max-width: 768px) {
            .order-table {
                display: block;
                overflow-x: auto;
            }
            
            .actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container">
            <div class="header-content">
                <a href="home.jsp" class="logo">📚 Pahana Edu</a>
                <div class="header-right">
                    <span class="welcome-msg">Welcome, <%= loggedInUser.getFirstName() %></span>
                    <a href="LogoutServlet" class="action-btn action-btn-secondary">Logout</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">
        <a href="<%= isAdminOrStaff ? "admin_dashboard.jsp" : "home.jsp" %>" class="back-btn">← Back to <%= isAdminOrStaff ? "Dashboard" : "Home" %></a>
        
        <h1 class="page-title"><%= isAdminOrStaff ? "Order Management" : "My Order History" %></h1>
        
        <% if (error != null) { %>
            <div class="alert-error">
                <strong>Error:</strong> <%= error %>
            </div>
        <% } %>
        
        <% if (orders == null || orders.isEmpty()) { %>
            <div class="empty-message">
                <h3>📭 No Orders Found</h3>
                <p><%= isAdminOrStaff ? "There are no orders in the system." : "You haven't placed any orders yet." %></p>
            </div>
        <% } else { %>
            <table class="order-table">
                <thead>
                    <tr>
                        <th>Order #</th>
                        <% if (isAdminOrStaff) { %>
                            <th>Bill #</th>
                            <th>Customer</th>
                            <th>Created By</th>
                        <% } %>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Order order : orders) { %>
                    <tr>
                        <td><%= order.getOrderId() %></td>
                        <% if (isAdminOrStaff) { %>
                            <td><%= order.getBillNumber() %></td>
                            <td><%= order.getCustomer().getFirstName() %> <%= order.getCustomer().getLastName() %></td>
                            <td><%= order.getCreatedByUser().getFirstName() %> <%= order.getCreatedByUser().getLastName() %></td>
                        <% } %>
                        <td><%= order.getOrderDate() %></td>
                        <td>$<%= String.format("%.2f", order.getTotalAmount()) %></td>
                        <td>
                            <span class="status status-<%= order.getStatus().toLowerCase() %>">
                                <%= order.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <a href="ManageOrdersServlet?action=view&id=<%= order.getOrderId() %>" class="action-btn">View</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
        
        <% if (isAdminOrStaff) { %>
            <div class="actions">
                <a href="ManageOrdersServlet?action=new" class="action-btn">➕ Create New Order</a>
                <a href="admin_dashboard.jsp" class="action-btn action-btn-secondary">📊 Dashboard</a>
            </div>
        <% } else { %>
            <div class="actions">
                <a href="store.jsp" class="action-btn">🛍️ Continue Shopping</a>
            </div>
        <% } %>
    </main>
</body>
</html>