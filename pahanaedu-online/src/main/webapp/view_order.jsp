<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Order" %>
<%@ page import="com.pahanaedu.model.User" %>
<%@ page import="com.pahanaedu.model.OrderItem" %>
<%
    Order order = (Order) request.getAttribute("order");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - Pahana Edu</title>
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

        .btn-print {
            background: linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%);
            color: #ffffff;
        }

        .btn-print:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(78, 205, 196, 0.4);
        }

        /* Order Info Section */
        .order-info {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .info-section {
            flex: 1;
            min-width: 300px;
        }

        .info-section h3 {
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding-bottom: 0.5rem;
            margin-bottom: 1rem;
            color: #ffd700;
        }

        .info-row {
            display: flex;
            margin-bottom: 0.8rem;
            color: rgba(255, 255, 255, 0.9);
        }

        .info-label {
            font-weight: 600;
            width: 120px;
            color: #ffd700;
        }

        /* Table Styles */
        .table-container {
            overflow-x: auto;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1.5rem;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        th {
            background: rgba(255, 215, 0, 0.1);
            color: #ffd700;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        td {
            color: rgba(255, 255, 255, 0.9);
        }

        tbody tr:hover {
            background: rgba(255, 215, 0, 0.05);
        }

        .total-row {
            font-weight: bold;
            background: rgba(255, 215, 0, 0.1);
        }

        .discount {
            color: #4ecdc4;
        }

        /* Actions */
        .actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
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

        /* Responsive Design */
        @media (max-width: 768px) {
            .section-title {
                font-size: 2rem;
            }

            .container {
                padding: 0 1rem;
            }

            .section-card {
                padding: 1.5rem;
            }

            .order-info {
                flex-direction: column;
                align-items: stretch;
            }

            th, td {
                padding: 1rem;
                font-size: 0.9rem;
            }
        }

        /* Print-specific styles */
        @media print {
            .no-print {
                display: none;
            }

            body {
                background: #fff;
                color: #000;
                font-size: 12pt;
            }

            .container {
                box-shadow: none;
                border: none;
                padding: 0;
            }

            .section-card {
                background: none;
                backdrop-filter: none;
                border: none;
                padding: 1rem;
            }

            .section-title {
                background: none;
                -webkit-text-fill-color: #000;
            }

            .info-label, th, td {
                color: #000;
            }

            .table-container {
                background: none;
                border: none;
            }

            table {
                border: 1px solid #000;
            }

            th, td {
                border: 1px solid #000;
            }

            .total-row {
                background: none;
            }
        }
    </style>
</head>
<body>
    <section class="main-content">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Order Details - #<%= order.getOrderId() %></h2>
                <p class="section-subtitle">Bill Number: <%= order.getBillNumber() %></p>
            </div>

            <% if (error != null) { %>
                <div class="alert alert-error">
                    ❌ <%= error %>
                </div>
            <% } %>

            <div class="section-card">
                <div class="order-info">
                    <div class="info-section">
                        <h3>👤 Customer Information</h3>
                        <div class="info-row">
                            <div class="info-label">Name:</div>
                            <div><%= order.getCustomer().getFirstName() %> <%= order.getCustomer().getLastName() %></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Email:</div>
                            <div><%= order.getCustomer().getEmail() %></div>
                        </div>
                        <% if (order.getCustomer().getTelephone() != null && !order.getCustomer().getTelephone().isEmpty()) { %>
                            <div class="info-row">
                                <div class="info-label">Phone:</div>
                                <div><%= order.getCustomer().getTelephone() %></div>
                            </div>
                        <% } %>
                    </div>

                    <div class="info-section">
                        <h3>📋 Order Information</h3>
                        <div class="info-row">
                            <div class="info-label">Date:</div>
                            <div><%= order.getOrderDate() %></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Status:</div>
                            <div><%= order.getStatus() %></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Created By:</div>
                            <div><%= order.getCreatedByUser().getFirstName() %> <%= order.getCreatedByUser().getLastName() %></div>
                        </div>
                    </div>
                </div>

                <h3>🛒 Order Items</h3>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Discount</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (OrderItem item : order.getItems()) { %>
                                <tr>
                                    <td><%= item.getProduct().getTitle() %> by <%= item.getProduct().getAuthor() %></td>
                                    <td><%= item.getQuantity() %></td>
                                    <td>$<%= String.format("%.2f", item.getUnitPrice()) %></td>
                                    <td class="discount">
                                        <% if (item.getDiscountPercentage() > 0) { %>
                                            <%= item.getDiscountPercentage() %>%
                                        <% } else { %>
                                            -
                                        <% } %>
                                    </td>
                                    <td>$<%= String.format("%.2f", item.getUnitPrice() * item.getQuantity() * (1 - (item.getDiscountPercentage() / 100))) %></td>
                                </tr>
                            <% } %>
                        </tbody>
                        <tfoot>
                            <tr class="total-row">
                                <td colspan="4" style="text-align: right;">Total:</td>
                                <td>$<%= String.format("%.2f", order.getTotalAmount()) %></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="actions">
                    <button onclick="window.print()" class="btn btn-print no-print">🖨️ Print Bill</button>
                    <a href="ManageOrdersServlet" class="btn btn-primary no-print">📋 Back to Orders</a>
                    <a href="admin_dashboard.jsp" class="btn btn-secondary no-print">🏠 Back to Dashboard</a>
                </div>
            </div>
        </div>
    </section>
</body>
</html>