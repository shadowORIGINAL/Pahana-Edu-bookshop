<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <style>
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <h2>Forgot Password</h2>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>
    
    <% if (request.getParameter("message") != null) { %>
        <div class="success"><%= request.getParameter("message") %></div>
    <% } %>
    
    <form action="password-reset" method="post">
        <div>
            <label>Email Address:</label>
            <input type="email" name="email" required>
        </div>
        <button type="submit">Send Reset Link</button>
    </form>
    
    <p><a href="login.jsp">Back to Login</a></p>
</body>
</html>