<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.Product" %>
<%@ page import="com.pahanaedu.model.User" %>
<%@ page import="java.util.List" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null || (!loggedInUser.getRole().equals("ADMIN") && !loggedInUser.getRole().equals("STAFF"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    String success = request.getParameter("success");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - Pahana Edu Admin</title>
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

        /* Header */
        .admin-header {
            background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
            color: #faf7f2;
            padding: 1.5rem 0;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
            margin-bottom: 2rem;
        }

        .admin-header h1 {
            text-align: center;
            font-size: 2.2rem;
            color: #ffd700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .admin-header .subtitle {
            text-align: center;
            margin-top: 0.5rem;
            opacity: 0.9;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Alert Styles */
        .alert {
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            border-radius: 12px;
            border: none;
            font-weight: 500;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-error {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        /* Controls Section */
        .controls-section {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .search-container {
            flex: 1;
            max-width: 400px;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 0.8rem 1rem 0.8rem 2.5rem;
            border: 2px solid #e6d7c3;
            border-radius: 25px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #faf7f2;
        }

        .search-input:focus {
            outline: none;
            border-color: #d2691e;
            box-shadow: 0 0 10px rgba(210, 105, 30, 0.2);
            background: white;
        }

        .search-icon {
            position: absolute;
            left: 0.8rem;
            top: 50%;
            transform: translateY(-50%);
            color: #8b4513;
        }

        .add-product-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .add-product-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }

        /* Products Table */
        .table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .table-header {
            background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
            color: #ffd700;
            padding: 1.5rem;
            text-align: center;
        }

        .table-header h2 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        th {
            background: #f8f5f0;
            color: #8b4513;
            padding: 1rem 0.8rem;
            text-align: left;
            font-weight: bold;
            border-bottom: 2px solid #e6d7c3;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        td {
            padding: 1rem 0.8rem;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:hover {
            background: linear-gradient(135deg, #faf7f2 0%, #f5f0e8 100%);
            transform: scale(1.01);
        }

        .product-image {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .no-image {
            width: 60px;
            height: 80px;
            background: linear-gradient(135deg, #d2691e 0%, #cd853f 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            color: white;
            font-size: 0.8rem;
            text-align: center;
        }

        .product-title {
            font-weight: bold;
            color: #8b4513;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .product-author {
            color: #666;
            font-style: italic;
        }

        .price {
            font-weight: bold;
            color: #e74c3c;
            font-size: 1.1rem;
        }

        .stock {
            font-weight: bold;
        }

        .stock.low {
            color: #f39c12;
        }

        .stock.out {
            color: #e74c3c;
        }

        .stock.good {
            color: #27ae60;
        }

        .status {
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status.active {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }

        .status.inactive {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.4rem 0.8rem;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: bold;
            text-decoration: none;
            color: white;
            transition: all 0.3s ease;
            min-width: 60px;
            text-align: center;
        }

        .btn-edit {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
        }

        .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        }

        .btn-toggle {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: #212529;
        }

        .btn-activate {
            background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background: white;
            margin: 2% auto;
            padding: 0;
            border-radius: 20px;
            width: 90%;
            max-width: 700px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: modalSlideIn 0.3s ease-out;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .modal-header {
            background: linear-gradient(135deg, #8b4513 0%, #a0522d 100%);
            color: #ffd700;
            padding: 1.5rem 2rem;
            border-radius: 20px 20px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 1.5rem;
        }

        .close {
            color: #ffd700;
            font-size: 2rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            background: none;
        }

        .close:hover {
            color: white;
            transform: scale(1.1);
        }

        .modal-body {
            padding: 2rem;
        }

        /* Form Styles */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: #8b4513;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid #e6d7c3;
            border-radius: 10px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #faf7f2;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #d2691e;
            box-shadow: 0 0 10px rgba(210, 105, 30, 0.2);
            background: white;
        }

        .form-group textarea {
            height: 100px;
            resize: vertical;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            transform: scale(1.2);
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e6d7c3;
        }

        .btn-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #545b62 100%);
            color: white;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary:hover,
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .current-image {
            max-width: 120px;
            max-height: 150px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #8b4513;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .controls-section {
                flex-direction: column;
                align-items: stretch;
            }

            .search-container {
                max-width: none;
            }

            table {
                font-size: 0.8rem;
            }

            th, td {
                padding: 0.5rem 0.3rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .modal-content {
                width: 95%;
                margin: 5% auto;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="container">
            <h1>📚 Pahana Edu Admin</h1>
            <p class="subtitle">Product Management Dashboard</p>
        </div>
    </div>

    <div class="container">
        <!-- Alerts -->
        <% if (success != null) { %>
            <div class="alert alert-success">
                <strong>✅ Success!</strong> <%= success %>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <strong>❌ Error!</strong> <%= error %>
            </div>
        <% } %>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= productList != null ? productList.size() : 0 %></div>
                <div class="stat-label">Total Products</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <% 
                    int activeCount = 0;
                    if (productList != null) {
                        for (Product p : productList) {
                            if (p.isActive()) activeCount++;
                        }
                    }
                    %>
                    <%= activeCount %>
                </div>
                <div class="stat-label">Active Products</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <% 
                    int lowStockCount = 0;
                    if (productList != null) {
                        for (Product p : productList) {
                            if (p.getStockQuantity() <= 5 && p.getStockQuantity() > 0) lowStockCount++;
                        }
                    }
                    %>
                    <%= lowStockCount %>
                </div>
                <div class="stat-label">Low Stock Items</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <% 
                    int featuredCount = 0;
                    if (productList != null) {
                        for (Product p : productList) {
                            if (p.isFeatured()) featuredCount++;
                        }
                    }
                    %>
                    <%= featuredCount %>
                </div>
                <div class="stat-label">Featured Products</div>
            </div>
        </div>

        <!-- Controls Section -->
        <div class="controls-section">
            <div class="search-container">
                <span class="search-icon">🔍</span>
                <input type="text" id="searchInput" class="search-input" 
                       placeholder="Search by title or author..." onkeyup="filterTable()">
            </div>
            <button onclick="openAddModal()" class="add-product-btn">
                ➕ Add New Product
            </button>
        </div>

        <!-- Products Table -->
        <div class="table-container">
            <div class="table-header">
                <h2>Product Inventory</h2>
                <p>Manage your book collection with ease</p>
            </div>
            
            <table id="productsTable">
                <thead>
                    <tr>
                        <th>📷 Image</th>
                        <th>📖 Title</th>
                        <th>✍️ Author</th>
                        <th>💰 Price</th>
                        <th>📦 Stock</th>
                        <th>📈 Status</th>
                        <th>⚙️ Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (productList != null) { %>
                        <% for (Product product : productList) { %>
                        <tr>
                            <td>
                                <% if (product.getImagePath() != null && !product.getImagePath().isEmpty()) { %>
                                    <img src="<%= request.getContextPath() + "/" + product.getImagePath() %>" 
                                         alt="<%= product.getTitle() %>" class="product-image">
                                <% } else { %>
                                    <div class="no-image">No Image</div>
                                <% } %>
                            </td>
                            <td>
                                <div class="product-title" title="<%= product.getTitle() %>">
                                    <%= product.getTitle() %>
                                </div>
                            </td>
                            <td>
                                <div class="product-author"><%= product.getAuthor() %></div>
                            </td>
                            <td>
                                <div class="price">$<%= String.format("%.2f", product.getPrice()) %></div>
                            </td>
                            <td>
                                <div class="stock <%= product.getStockQuantity() == 0 ? "out" : 
                                                     product.getStockQuantity() <= 5 ? "low" : "good" %>">
                                    <%= product.getStockQuantity() %>
                                    <% if (product.getStockQuantity() == 0) { %>
                                        (Out)
                                    <% } else if (product.getStockQuantity() <= 5) { %>
                                        (Low)
                                    <% } %>
                                </div>
                            </td>
                            <td>
                                <span class="status <%= product.isActive() ? "active" : "inactive" %>">
                                    <%= product.isActive() ? "Active" : "Inactive" %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <button onclick="openEditModal(
                                        '<%= product.getProductId() %>',
                                        '<%= product.getTitle().replace("'", "\\'") %>',
                                        '<%= product.getDescription().replace("'", "\\'") %>',
                                        '<%= product.getAuthor().replace("'", "\\'") %>',
                                        '<%= product.getPublisher() != null ? product.getPublisher().replace("'", "\\'") : "" %>',
                                        '<%= product.getPublicationDate() != null ? product.getPublicationDate() : "" %>',
                                        '<%= product.getCategory().replace("'", "\\'") %>',
                                        '<%= product.getPrice() %>',
                                        '<%= product.getStockQuantity() %>',
                                        '<%= product.getImagePath() != null ? product.getImagePath().replace("'", "\\'") : "" %>',
                                        '<%= product.isActive() %>',
                                        '<%= product.getDiscountPercentage() %>',
                                        '<%= product.isFeatured() %>'
                                    )" class="btn btn-edit">✏️ Edit</button>
                                    
                                    <form action="ManageProductsServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= product.getProductId() %>">
                                        <button type="submit" onclick="return confirm('⚠️ Are you sure you want to delete this product? This action cannot be undone.')" 
                                                class="btn btn-delete">🗑️ Delete</button>
                                    </form>
                                    
                                    <form action="ManageProductsServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="toggleActive">
                                        <input type="hidden" name="id" value="<%= product.getProductId() %>">
                                        <button type="submit" class="btn <%= product.isActive() ? "btn-toggle" : "btn-activate" %>">
                                            <%= product.isActive() ? "⏸️ Deactivate" : "▶️ Activate" %>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Add Product Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>➕ Add New Product</h2>
                <button class="close" onclick="closeAddModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form action="ManageProductsServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="addTitle">📖 Book Title *</label>
                            <input type="text" id="addTitle" name="title" required 
                                   placeholder="Enter the book title">
                        </div>
                        
                        <div class="form-group">
                            <label for="addAuthor">✍️ Author *</label>
                            <input type="text" id="addAuthor" name="author" required 
                                   placeholder="Enter author name">
                        </div>
                        
                        <div class="form-group">
                            <label for="addCategory">🏷️ Category *</label>
                            <input type="text" id="addCategory" name="category" required 
                                   placeholder="e.g., Fiction, Mystery, Romance">
                        </div>
                        
                        <div class="form-group">
                            <label for="addPublisher">🏢 Publisher</label>
                            <input type="text" id="addPublisher" name="publisher" 
                                   placeholder="Enter publisher name">
                        </div>
                        
                        <div class="form-group">
                            <label for="addPrice">💰 Price *</label>
                            <input type="number" id="addPrice" name="price" step="0.01" min="0" required 
                                   placeholder="0.00">
                        </div>
                        
                        <div class="form-group">
                            <label for="addStockQuantity">📦 Stock Quantity *</label>
                            <input type="number" id="addStockQuantity" name="stock_quantity" min="0" required 
                                   placeholder="Enter stock quantity">
                        </div>
                        
                        <div class="form-group">
                            <label for="addDiscountPercentage">🏷️ Discount %</label>
                            <input type="number" id="addDiscountPercentage" name="discount_percentage" 
                                   step="0.01" min="0" max="100" value="0" placeholder="0.00">
                        </div>
                        
                        <div class="form-group">
                            <label for="addPublicationDate">📅 Publication Date</label>
                            <input type="date" id="addPublicationDate" name="publication_date">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="addDescription">📝 Description</label>
                        <textarea id="addDescription" name="description" 
                                  placeholder="Enter book description..."></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="addImage">📷 Product Image</label>
                        <input type="file" id="addImage" name="image" accept="image/*">
                    </div>
                    
                    <div style="display: flex; gap: 2rem;">
                        <div class="checkbox-group">
                            <input type="checkbox" id="addIsActive" name="is_active" checked>
                            <label for="addIsActive">✅ Active (Visible to customers)</label>
                        </div>
                        
                        <div class="checkbox-group">
                            <input type="checkbox" id="addFeatured" name="featured">
                            <label for="addFeatured">⭐ Featured Product</label>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" onclick="closeAddModal()" class="btn-secondary">❌ Cancel</button>
                        <button type="submit" class="btn-primary">✅ Add Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Product Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>✏️ Edit Product</h2>
                <button class="close" onclick="closeEditModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form action="ManageProductsServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editId" name="id">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="editTitle">📖 Book Title *</label>
                            <input type="text" id="editTitle" name="title" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editAuthor">✍️ Author *</label>
                            <input type="text" id="editAuthor" name="author" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editCategory">🏷️ Category *</label>
                            <input type="text" id="editCategory" name="category" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editPublisher">🏢 Publisher</label>
                            <input type="text" id="editPublisher" name="publisher">
                        </div>
                        
                        <div class="form-group">
                            <label for="editPrice">💰 Price *</label>
                            <input type="number" id="editPrice" name="price" step="0.01" min="0" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editStockQuantity">📦 Stock Quantity *</label>
                            <input type="number" id="editStockQuantity" name="stock_quantity" min="0" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="editDiscountPercentage">🏷️ Discount %</label>
                            <input type="number" id="editDiscountPercentage" name="discount_percentage" 
                                   step="0.01" min="0" max="100">
                        </div>
                        
                        <div class="form-group">
                            <label for="editPublicationDate">📅 Publication Date</label>
                            <input type="date" id="editPublicationDate" name="publication_date">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="editDescription">📝 Description</label>
                        <textarea id="editDescription" name="description"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>📷 Current Image</label>
                        <div id="currentImageContainer"></div>
                        <label for="editImage">Upload New Image</label>
                        <input type="file" id="editImage" name="image" accept="image/*">
                    </div>
                    
                    <div style="display: flex; gap: 2rem;">
                        <div class="checkbox-group">
                            <input type="checkbox" id="editIsActive" name="is_active">
                            <label for="editIsActive">✅ Active (Visible to customers)</label>
                        </div>
                        
                        <div class="checkbox-group">
                            <input type="checkbox" id="editFeatured" name="featured">
                            <label for="editFeatured">⭐ Featured Product</label>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" onclick="closeEditModal()" class="btn-secondary">❌ Cancel</button>
                        <button type="submit" class="btn-primary">💾 Update Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // Modal Functions
        function openAddModal() {
            document.getElementById('addModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeAddModal() {
            document.getElementById('addModal').style.display = 'none';
            document.body.style.overflow = 'auto';
            // Reset form
            document.querySelector('#addModal form').reset();
        }

        function openEditModal(id, title, description, author, publisher, pubDate,
                              category, price, stock, imagePath, isActive, discount, featured) {
            // Populate form fields
            document.getElementById('editId').value = id;
            document.getElementById('editTitle').value = title;
            document.getElementById('editDescription').value = description;
            document.getElementById('editAuthor').value = author;
            document.getElementById('editPublisher').value = publisher || '';
            document.getElementById('editPublicationDate').value = pubDate || '';
            document.getElementById('editCategory').value = category;
            document.getElementById('editPrice').value = price;
            document.getElementById('editStockQuantity').value = stock;
            document.getElementById('editDiscountPercentage').value = discount;
            document.getElementById('editIsActive').checked = (isActive === 'true');
            document.getElementById('editFeatured').checked = (featured === 'true');

            // Display current image
            const imageContainer = document.getElementById('currentImageContainer');
            imageContainer.innerHTML = '';
            if (imagePath && imagePath !== '') {
                const img = document.createElement('img');
                const contextPath = '<%= request.getContextPath() %>';
                const fullPath = imagePath.startsWith('/') ? contextPath + imagePath : contextPath + '/' + imagePath;
                img.src = fullPath;
                img.alt = 'Current Product Image';
                img.className = 'current-image';
                imageContainer.appendChild(img);
            } else {
                imageContainer.innerHTML = '<p style="color: #666; font-style: italic;">No current image</p>';
            }

            document.getElementById('editModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const addModal = document.getElementById('addModal');
            const editModal = document.getElementById('editModal');
            if (event.target === addModal) {
                closeAddModal();
            }
            if (event.target === editModal) {
                closeEditModal();
            }
        }

        // Search/Filter Function
        function filterTable() {
            const input = document.getElementById("searchInput");
            const filter = input.value.toLowerCase().trim();
            const table = document.getElementById("productsTable");
            const rows = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

            for (let i = 0; i < rows.length; i++) {
                const titleCell = rows[i].getElementsByTagName("td")[1];
                const authorCell = rows[i].getElementsByTagName("td")[2];
                
                if (titleCell && authorCell) {
                    const titleText = titleCell.textContent || titleCell.innerText;
                    const authorText = authorCell.textContent || authorCell.innerText;
                    
                    if (titleText.toLowerCase().indexOf(filter) > -1 || 
                        authorText.toLowerCase().indexOf(filter) > -1) {
                        rows[i].style.display = "";
                    } else {
                        rows[i].style.display = "none";
                    }
                }
            }
        }

        // Close modals with Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeAddModal();
                closeEditModal();
            }
        });

        // Form validation
        document.addEventListener('DOMContentLoaded', function() {
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const requiredFields = form.querySelectorAll('input[required], textarea[required], select[required]');
                    let isValid = true;
                    
                    requiredFields.forEach(field => {
                        if (!field.value.trim()) {
                            field.style.borderColor = '#dc3545';
                            isValid = false;
                        } else {
                            field.style.borderColor = '#e6d7c3';
                        }
                    });
                    
                    if (!isValid) {
                        e.preventDefault();
                        alert('⚠️ Please fill in all required fields.');
                    }
                });
            });
        });

        // Smooth animations
        document.addEventListener('DOMContentLoaded', function() {
            // Add loading animation to buttons
            const buttons = document.querySelectorAll('.btn, .add-product-btn, .btn-primary, .btn-secondary');
            buttons.forEach(button => {
                button.addEventListener('click', function() {
                    if (this.type === 'submit') {
                        this.style.opacity = '0.7';
                        this.style.pointerEvents = 'none';
                        setTimeout(() => {
                            this.style.opacity = '1';
                            this.style.pointerEvents = 'auto';
                        }, 2000);
                    }
                });
            });

            // Enhance table interactions
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.boxShadow = '0 4px 15px rgba(139, 69, 19, 0.1)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.boxShadow = 'none';
                });
            });
        });

        // Auto-focus search input with keyboard shortcut
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 'f') {
                e.preventDefault();
                document.getElementById('searchInput').focus();
            }
        });

        // Real-time search feedback
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const noResultsMsg = document.getElementById('noResultsMessage');
            
            // Remove existing no results message
            if (noResultsMsg) {
                noResultsMsg.remove();
            }
            
            filterTable();
            
            // Check if any rows are visible
            const visibleRows = Array.from(document.querySelectorAll('tbody tr')).filter(row => 
                row.style.display !== 'none'
            );
            
            if (visibleRows.length === 0 && searchTerm.length > 0) {
                const tbody = document.querySelector('tbody');
                const noResultsRow = document.createElement('tr');
                noResultsRow.id = 'noResultsMessage';
                noResultsRow.innerHTML = `
                    <td colspan="7" style="text-align: center; padding: 2rem; color: #666; font-style: italic;">
                        🔍 No products found matching "${searchTerm}"
                    </td>
                `;
                tbody.appendChild(noResultsRow);
            }
        });
    </script>
</body>
</html>