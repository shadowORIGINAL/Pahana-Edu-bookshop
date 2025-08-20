<%@ page contentType="text/html;charset=UTF-8" %>
<%
String token = request.getParameter("token");
if (token == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Pahana Edu</title>
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
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow-x: hidden;
        }

        /* Container */
        .container {
            max-width: 500px;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        h2 {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 2rem;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 100%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .error {
            background: linear-gradient(135deg, rgba(255, 107, 107, 0.1), rgba(238, 90, 111, 0.1));
            border: 1px solid rgba(255, 107, 107, 0.3);
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            color: rgba(255, 255, 255, 0.9);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            color: #ffffff;
            font-weight: 600;
            margin-bottom: 0.5rem;
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

        .form-group input:hover {
            border-color: rgba(255, 215, 0, 0.3);
            background: rgba(255, 215, 0, 0.05);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            border-radius: 50px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: none;
            cursor: pointer;
            white-space: nowrap;
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f0f;
            box-shadow: 0 8px 32px rgba(255, 215, 0, 0.3);
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 215, 0, 0.4);
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

        .back-link {
            display: inline-block;
            margin-top: 1.5rem;
            color: #ffd700;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: #ffed4e;
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                margin: 1rem;
                padding: 1rem;
            }

            h2 {
                font-size: 1.5rem;
            }
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

        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
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
    </style>
</head>
<body>
    <!-- Main Content -->
    <div class="container">
        <h2>Reset Your Password</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <form action="update-password" method="post">
            <input type="hidden" name="token" value="<%= token %>">
            
            <div class="form-group">
                <label for="newPassword">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" required minlength="8">
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required minlength="8">
            </div>
            
            <button type="submit" class="btn">Reset Password</button>
        </form>
        
        <p><a href="login.jsp" class="back-link">Back to Login</a></p>
    </div>

    <script>
        // Button ripple effect
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
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

        // Observe container for animation
        const container = document.querySelector('.container');
        container.style.opacity = '0';
        container.style.transform = 'translateY(30px)';
        container.style.transition = 'all 0.6s ease-out';
        observer.observe(container);
    </script>
</body>
</html>