<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null || !loggedInUser.getRole().equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Customer - Pahana Edu</title>
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

        .form-container {
            max-width: 500px;
            margin: 0 auto;
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

        .form-group input {
            width: 100%;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: #ffffff;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
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

            .form-container {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <section class="main-content">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Add New Customer</h2>
                <p class="section-subtitle">Create a new customer account for Pahana Edu</p>
            </div>

            <div class="section-card form-container">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">
                        ❌ <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="AddUserServlet" method="post">
                    <input type="hidden" name="role" value="CUSTOMER">

                    <div class="form-group">
                        <label for="email">📧 Email:</label>
                        <input type="email" name="email" id="email" required>
                    </div>

                    <div class="form-group">
                        <label for="first_name">👤 First Name:</label>
                        <input type="text" name="first_name" id="first_name" required>
                    </div>

                    <div class="form-group">
                        <label for="last_name">👤 Last Name:</label>
                        <input type="text" name="last_name" id="last_name" required>
                    </div>

                    <div class="form-group">
                        <label for="address">🏠 Address:</label>
                        <input type="text" name="address" id="address">
                    </div>

                    <div class="form-group">
                        <label for="telephone">📱 Telephone:</label>
                        <input type="text" name="telephone" id="telephone">
                    </div>

                    <div class="form-group">
                        <label for="units_consumed">📏 Units Consumed:</label>
                        <input type="number" name="units_consumed" id="units_consumed" min="0" value="0">
                    </div>

                    <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 2rem;">
                        <input type="submit" value="➕ Add Customer" class="btn btn-success">
                        <a href="ManageCustomersServlet" class="btn btn-secondary">❌ Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </section>
</body>
</html>