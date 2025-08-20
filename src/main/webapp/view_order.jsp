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
    <title>Order Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .alert-error {
            background-color: #f2dede;
            color: #a94442;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .order-header {
            margin-bottom: 30px;
        }
        .order-info {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            margin-bottom: 30px;
        }
        .info-section {
            flex: 1;
            min-width: 300px;
        }
        .info-section h3 {
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }
        .info-row {
            display: flex;
            margin-bottom: 8px;
        }
        .info-label {
            font-weight: bold;
            width: 120px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f8f8;
            font-weight: bold;
        }
        .total-row {
            font-weight: bold;
            background-color: #f8f8f8;
        }
        .discount {
            color: #4CAF50;
        }
        .actions {
            margin-top: 30px;
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 8px 15px;
            background: #2196F3;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-secondary {
            background: #777;
        }
        .btn-success {
            background: #4CAF50;
        }
        .btn-print {
		    padding: 8px 15px;
		    background: #4CAF50;
		    color: white;
		    border: none;
		    border-radius: 4px;
		    cursor: pointer;
		    margin: 10px 0;
		}
		@media print {
		    .no-print { display: none; }
		    body { font-size: 12pt; }
		    /* Add other print-specific styles */
		}
    </style>
</head>
<body>
    <div class="container">
        <div class="order-header">
            <h1>Order Details - #<%= order.getOrderId() %></h1>
            <p>Bill Number: <%= order.getBillNumber() %></p>
        </div>
        
        <% if (error != null) { %>
            <div class="alert-error">
                <%= error %>
            </div>
        <% } %>
        
        <div class="order-info">
            <div class="info-section">
                <h3>Customer Information</h3>
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
                <h3>Order Information</h3>
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
        
        <h3>Order Items</h3>
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
        
        <div class="actions">
            <button onclick="window.print()" class="btn-print">Print Bill</button>
            <a href="ManageOrdersServlet" class="btn">Back to Orders</a>
            <a href="admin_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>