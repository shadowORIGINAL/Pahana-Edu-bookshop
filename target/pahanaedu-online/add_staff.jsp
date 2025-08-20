<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null || !loggedInUser.getRole().equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Add New Staff</title>
    <style>
        .form-container { max-width: 500px; margin: 0 auto; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 100%; padding: 8px; box-sizing: border-box; }
        .btn { 
            padding: 8px 15px; 
            background: #4CAF50; 
            color: white; 
            border: none; 
            cursor: pointer; 
            border-radius: 4px;
        }
        .btn-secondary { background: #777; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Add New Staff Member</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div style="color: red; margin: 10px 0;">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="AddUserServlet" method="post">
            <input type="hidden" name="role" value="STAFF">
            
            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" required>
            </div>

            <div class="form-group">
                <label>First Name:</label>
                <input type="text" name="first_name" required>
            </div>
            
            <div class="form-group">
                <label>Last Name:</label>
                <input type="text" name="last_name" required>
            </div>
            
            <div class="form-group">
                <label>Address:</label>
                <input type="text" name="address">
            </div>
            
            <div class="form-group">
                <label>Telephone:</label>
                <input type="text" name="telephone">
            </div>
            
            <div style="margin-top: 20px;">
                <input type="submit" value="Add Staff" class="btn">
                <a href="ManageStaffServlet" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>