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
    <title>Create New Order</title>
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
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group select, .form-group input {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .product-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            align-items: center;
        }
        .product-select { flex: 3; }
        .quantity-input { flex: 1; }
        .price-display { flex: 2; }
        .stock-display { flex: 1; text-align: center; }
        .btn {
            padding: 8px 15px;
            background: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-secondary { background: #777; }
        .btn-danger { background: #f44336; }
        #addProduct { margin-bottom: 15px; }
        #productContainer { margin-bottom: 20px; }
        .actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
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
                            <%= customer.getFirstName() %> <%= customer.getLastName() %> (<%= customer.getEmail() %>)
                        </option>
                    <% } %>
                </select>
            </div>
            
            <h3>Order Items</h3>
            <button type="button" id="addProduct" class="btn">Add Product</button>
            
            <div id="productContainer">
                <!-- Product rows will be added here -->
            </div>
            
            <div class="actions">
                <input type="submit" value="Create Order" class="btn">
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
                option.textContent = `${product.title} by ${product.author} ($${product.price.toFixed(2)})`;
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
    </script>
</body>
</html>