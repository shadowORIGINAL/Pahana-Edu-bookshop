<%@ page contentType="text/html;charset=UTF-8" %>
<%
String token = request.getParameter("token");
if (token == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <style>
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <h2>Reset Your Password</h2>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>
    
    <form action="update-password" method="post">
        <input type="hidden" name="token" value="<%= token %>">
        
        <div>
            <label>New Password:</label>
            <input type="password" name="newPassword" required minlength="8">
        </div>
        
        <div>
            <label>Confirm Password:</label>
            <input type="password" name="confirmPassword" required minlength="8">
        </div>
        
        <button type="submit">Reset Password</button>
    </form>
</body>
</html>