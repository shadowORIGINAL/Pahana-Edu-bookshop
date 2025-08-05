<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
User user = (User) session.getAttribute("user");
boolean isLoggedIn = (user != null);
String firstName = isLoggedIn ? user.getFirstName() : "Guest";
int unitsConsumed = isLoggedIn ? user.getUnitsConsumed() : 0;
String userRole = isLoggedIn ? user.getRole() : "GUEST";
%>
<% 
    String orderSuccess = (String) session.getAttribute("orderSuccess");
    if (orderSuccess != null) {
        session.removeAttribute("orderSuccess");
%>
    <div class="alert-success" style="background: #d4edda; color: #155724; padding: 1rem; border-radius: 5px; margin: 1rem 0; text-align: center;">
        <%= orderSuccess %>
    </div>
<% } %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu - Your Educational Journey Awaits</title>
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

        /* Navigation */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(15, 15, 15, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            background: rgba(15, 15, 15, 0.98);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 80px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffd700;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.05);
            filter: drop-shadow(0 0 20px rgba(255, 215, 0, 0.5));
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
            align-items: center;
        }

        .nav-link {
            color: #ffffff;
            text-decoration: none;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 50%;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, #ffd700, #ff6b6b);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-link:hover::before {
            width: 100%;
        }

        .nav-link:hover {
            color: #ffd700;
            background: rgba(255, 215, 0, 0.1);
        }

        .user-menu {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50px;
            font-size: 0.9rem;
        }

        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            color: #ffffff;
            font-size: 1.5rem;
            cursor: pointer;
        }

        /* Hero Section */
        .hero {
            height: 100vh;
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a2e 50%, #16213e 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><radialGradient id="grad" cx="50%" cy="50%" r="50%"><stop offset="0%" style="stop-color:rgba(255,215,0,0.1);stop-opacity:1" /><stop offset="100%" style="stop-color:rgba(255,215,0,0);stop-opacity:0" /></radialGradient></defs><circle cx="20" cy="20" r="2" fill="url(%23grad)"><animate attributeName="opacity" values="0;1;0" dur="3s" repeatCount="indefinite"/></circle><circle cx="80" cy="40" r="1.5" fill="url(%23grad)"><animate attributeName="opacity" values="0;1;0" dur="4s" repeatCount="indefinite" begin="1s"/></circle><circle cx="40" cy="80" r="1" fill="url(%23grad)"><animate attributeName="opacity" values="0;1;0" dur="2s" repeatCount="indefinite" begin="2s"/></circle></svg>') repeat;
            animation: float 20s ease-in-out infinite;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            padding: 0 2rem;
            width: 90%; /* Added to prevent overflow */
            margin: 0 auto; /* Center the content */
        }

        .hero h1 {
            font-size: clamp(2.5rem, 8vw, 6rem); /* Reduced minimum size from 3rem to 2.5rem */
            font-weight: 800;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #ffd700 0%, #ff6b6b 50%, #4ecdc4 100%);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: slideInUp 1s ease-out;
            line-height: 1.2; /* Added better line height */
            word-break: break-word; /* Ensures long words break properly */
            padding: 0 1rem; /* Added padding to prevent edge touching */
        }

        .hero-subtitle {
            font-size: 1.5rem;
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 2rem;
            animation: slideInUp 1s ease-out 0.2s both;
        }

        .hero-description {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: 3rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            animation: slideInUp 1s ease-out 0.4s both;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            animation: slideInUp 1s ease-out 0.6s both;
        }

        /* Buttons */
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

        .btn-danger {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            color: #ffffff;
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(255, 107, 107, 0.4);
        }

        .btn-info {
            background: linear-gradient(135deg, #4ecdc4 0%, #44a08d 100%);
            color: #ffffff;
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 48px rgba(78, 205, 196, 0.4);
        }

        /* Stats Section - FIXED Z-INDEX ISSUE */
        .stats-section {
            padding: 6rem 0;
            background: rgba(255, 255, 255, 0.02);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            z-index: 1; /* Lower z-index than navbar */
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 3rem;
            text-align: center;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 3rem 2rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1; /* Ensure cards don't interfere with navbar */
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: conic-gradient(from 0deg, transparent, rgba(255, 215, 0, 0.1), transparent);
            transition: all 0.3s ease;
            opacity: 0;
            z-index: -1; /* Behind card content */
        }

        .stat-card:hover {
            transform: translateY(-10px);
            border-color: rgba(255, 215, 0, 0.3);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .stat-card:hover::before {
            opacity: 1;
            animation: rotate 2s linear infinite;
        }

        .stat-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: #ffd700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            min-height: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0 0.5rem;
        }

        /* Features Section */
        .features-section {
            padding: 8rem 0;
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a2e 100%);
            position: relative;
            z-index: 1;
        }

        .section-header {
            text-align: center;
            margin-bottom: 5rem;
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

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 3rem;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(20px);
            padding: 3rem;
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #ffd700, #ff6b6b, #4ecdc4);
            transform: scaleX(0);
            transition: all 0.3s ease;
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            border-color: rgba(255, 215, 0, 0.3);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .feature-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            display: block;
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 1rem;
        }

        .feature-description {
            color: rgba(255, 255, 255, 0.7);
            line-height: 1.6;
        }

        /* Services Section */
        .services-section {
            padding: 8rem 0;
            background: rgba(255, 255, 255, 0.02);
            position: relative;
            z-index: 1;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .service-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.05) 0%, rgba(255, 255, 255, 0.02) 100%);
            backdrop-filter: blur(20px);
            padding: 2.5rem;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .service-card:hover {
            transform: translateY(-5px);
            border-color: rgba(255, 215, 0, 0.3);
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
        }

        .service-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            display: block;
        }

        .service-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 1rem;
        }

        .service-description {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.95rem;
        }

        /* Contact Section */
        .contact-section {
            padding: 8rem 0;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            position: relative;
            z-index: 1;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 5rem;
            align-items: center;
        }

        .contact-info h3 {
            font-size: 2.5rem;
            font-weight: 800;
            color: #ffd700;
            margin-bottom: 2rem;
        }

        .contact-info p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.7;
        }

        .contact-details {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        .contact-item:hover {
            background: rgba(255, 215, 0, 0.1);
            border-color: rgba(255, 215, 0, 0.3);
        }

        .contact-item-icon {
            font-size: 1.5rem;
            color: #ffd700;
            width: 24px;
            text-align: center;
        }

        .contact-item-text {
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
        }

        .contact-form {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            padding: 3rem;
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .form-group {
            margin-bottom: 2rem;
        }

        .form-group label {
            display: block;
            color: #ffffff;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: #ffffff;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }

        /* Footer */
        .footer {
            background: #0a0a0a;
            padding: 4rem 0 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 3rem;
            margin-bottom: 3rem;
        }

        .footer-section h4 {
            color: #ffd700;
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .footer-section p,
        .footer-section a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            line-height: 1.8;
            transition: all 0.3s ease;
        }

        .footer-section a:hover {
            color: #ffd700;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 0.5rem;
        }

        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .social-links a {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.2rem;
            transition: all 0.3s ease;
        }

        .social-links a:hover {
            background: #ffd700;
            color: #0f0f0f;
            transform: translateY(-3px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.5);
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

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Scroll to top button */
        .scroll-top {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f0f;
            border: none;
            border-radius: 50%;
            font-size: 1.2rem;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .scroll-top.visible {
            opacity: 1;
            visibility: visible;
        }

        .scroll-top:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 215, 0, 0.4);
        }

        /* Newsletter Section */
        .newsletter-section {
            padding: 6rem 0;
            background: linear-gradient(135deg, #1a1a2e 0%, #0f0f0f 100%);
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            z-index: 1;
        }

        .newsletter-content {
            text-align: center;
            max-width: 600px;
            margin: 0 auto;
        }

        .newsletter-content h3 {
            font-size: 2.5rem;
            font-weight: 800;
            color: #ffd700;
            margin-bottom: 1rem;
        }

        .newsletter-content p {
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        .newsletter-form {
            display: flex;
            gap: 1rem;
            max-width: 400px;
            margin: 0 auto;
        }

        .newsletter-form input {
            flex: 1;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 50px;
            color: #ffffff;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .newsletter-form input:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.1);
        }

        .newsletter-form button {
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
            color: #0f0f0f;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .newsletter-form button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 215, 0, 0.4);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .nav-menu {
                position: fixed;
                top: 80px;
                left: 0;
                right: 0;
                background: rgba(15, 15, 15, 0.98);
                backdrop-filter: blur(20px);
                flex-direction: column;
                padding: 2rem;
                display: none;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
                z-index: 999; /* Below navbar but above content */
            }

            .nav-menu.active {
                display: flex;
            }

            .mobile-menu-btn {
                display: block;
            }

            .hero h1 {
                font-size: 3rem;
            }

            .hero-buttons {
                flex-direction: column;
                align-items: center;
            }

            .contact-grid {
                grid-template-columns: 1fr;
                gap: 3rem;
            }

            .features-grid,
            .services-grid {
                grid-template-columns: 1fr;
            }

            .section-title {
                font-size: 2rem;
            }

            .container {
                padding: 0 1rem;
            }

            .newsletter-form {
                flex-direction: column;
                gap: 1rem;
            }

            .user-menu {
                gap: 0.5rem;
            }

            .user-info {
                font-size: 0.8rem;
                padding: 0.3rem 0.8rem;
            }
        }

        /* Loading animation */
        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #0f0f0f 0%, #1a1a2e 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            transition: opacity 0.5s ease, visibility 0.5s ease;
        }

        .page-loader.hidden {
            opacity: 0;
            visibility: hidden;
        }

        .loader-content {
            text-align: center;
            color: #ffd700;
        }

        .loader-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            animation: spin 2s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
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

        /* Guest mode styles */
        .guest-notice {
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.1), rgba(255, 107, 107, 0.1));
            border: 1px solid rgba(255, 215, 0, 0.3);
            padding: 1rem 2rem;
            border-radius: 12px;
            margin: 1rem 0;
            text-align: center;
            color: rgba(255, 255, 255, 0.9);
        }
    </style>
</head>
<body>
    <!-- Page Loader -->
    <div class="page-loader" id="pageLoader">
        <div class="loader-content">
            <div class="loader-icon">📚</div>
            <h3>Loading Pahana Edu...</h3>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="navbar" id="navbar">
        <div class="nav-container">
            <a href="#home" class="logo">
                📖 Pahana Edu
            </a>
            
            <ul class="nav-menu" id="navMenu">
                <li><a href="#home" class="nav-link">Home</a></li>
                <li><a href="#features" class="nav-link">Features</a></li>
                <li><a href="store" class="nav-link">Store</a></li>
                <li><a href="#services" class="nav-link">Services</a></li>
                <li><a href="#contact" class="nav-link">Contact</a></li>
            </ul>

            <div class="user-menu">
                <% if (isLoggedIn) { %>
                    <% 
                        String roleBasedLink;
                        if ("ADMIN".equals(user.getRole())) {
                            roleBasedLink = "admin_dashboard.jsp";
                        } else if ("STAFF".equals(user.getRole())) {
                            roleBasedLink = "staff_dashboard.jsp";
                        } else {
                            roleBasedLink = "profile.jsp";
                        }
                    %>
                    <a href="<%= roleBasedLink %>" class="btn btn-secondary" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;">
                        👤 <%= user.getFirstName() %>
                    </a>
                    <a href="LogoutServlet" class="btn btn-danger" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;" 
                       onclick="return confirm('Are you sure you want to logout?')">
                        🚪 Logout
                    </a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-info" style="padding: 0.5rem 1rem; font-size: 0.9rem; text-decoration: none;">
                        🔑 Login
                    </a>
                <% } %>
            </div>

            <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="hero-content">
            <% if (isLoggedIn) { %>
                <h1>Welcome back, <%= firstName %>!</h1>
                <p class="hero-subtitle">Your Educational Journey Continues</p>
            <% } else { %>
                <h1 style="word-break: break-word; line-height: 1.2;">Welcome to Pahana Edu!</h1>
                <p class="hero-subtitle">Your Educational Journey Begins Here</p>
            <% } %>
            <p class="hero-description">
                Discover thousands of educational resources across all subjects. From textbooks to e-learning materials, 
                find your next great study aid in our carefully curated collection.
            </p>
            <div class="hero-buttons">
                <a href="store" class="btn btn-primary">
                    🛍️ Browse Resources
                </a>
                <% if (isLoggedIn) { %>
                    <a href="ManageOrdersServlet?action=history" class="btn btn-secondary">
                        📋 Order History
                    </a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-secondary">
                        🔑 Join Us
                    </a>
                <% } %>
            </div>
            
            <% if (!isLoggedIn) { %>
                <div class="guest-notice" style="margin-top: 2rem;">
                    📝 Join Pahana Edu to track your learning progress, save favorites, and get personalized recommendations!
                </div>
            <% } %>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-icon">📚</span>
                    <div class="stat-number"><%= unitsConsumed %></div>
                    <div class="stat-label"><%= isLoggedIn ? "Units Consumed" : "Sample Units" %></div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">⭐</span>
                    <div class="stat-number"><%= isLoggedIn ? "★★★★☆" : "★★★★★" %></div>
                    <div class="stat-label"><%= isLoggedIn ? "Learner Level" : "Community Rating" %></div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">🎯</span>
                    <div class="stat-number"><%= isLoggedIn ? "Active" : "Welcome" %></div>
                    <div class="stat-label"><%= isLoggedIn ? "Learner Status" : "Visitor Status" %></div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">🏆</span>
                    <div class="stat-number">25K+</div>
                    <div class="stat-label">Resources Available</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Why Choose Pahana Edu?</h2>
                <p class="section-subtitle">
                    Experience the future of education with our cutting-edge features and personalized service.
                </p>
            </div>
            
            <div class="features-grid">
                <div class="feature-card">
                    <span class="feature-icon">🎯</span>
                    <h3 class="feature-title">Personalized Recommendations</h3>
                    <p class="feature-description">
                        Our AI-powered recommendation engine suggests resources based on your learning history, 
                        preferences, and trending subjects in your field of study.
                    </p>
                </div>
                
                <div class="feature-card">
                    <span class="feature-icon">⚡</span>
                    <h3 class="feature-title">Lightning Fast Delivery</h3>
                    <p class="feature-description">
                        Get your educational materials delivered within 24 hours with our express delivery service. 
                        Same-day delivery available in major cities.
                    </p>
                </div>
                
                <div class="feature-card">
                    <span class="feature-icon">💎</span>
                    <h3 class="feature-title">Premium Quality</h3>
                    <p class="feature-description">
                        Every resource in our collection is carefully selected for quality. We offer both 
                        new materials and rare educational texts, all in pristine condition.
                    </p>
                </div>
                
                <div class="feature-card">
                    <span class="feature-icon">🔄</span>
                    <h3 class="feature-title">Easy Returns</h3>
                    <p class="feature-description">
                        Not satisfied with your purchase? No problem! We offer hassle-free returns 
                        within 30 days, no questions asked.
                    </p>
                </div>
                
                <div class="feature-card">
                    <span class="feature-icon">💬</span>
                    <h3 class="feature-title">Learning Community</h3>
                    <p class="feature-description">
                        Join our vibrant community of learners. Share reviews, participate in 
                        study groups, and discover new resources through discussions.
                    </p>
                </div>
                
                <div class="feature-card">
                    <span class="feature-icon">🎁</span>
                    <h3 class="feature-title">Loyalty Rewards</h3>
                    <p class="feature-description">
                        Earn points with every purchase and unlock exclusive discounts, early access 
                        to new resources, and special member-only events.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section class="services-section" id="services">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Our Services</h2>
                <p class="section-subtitle">
                    Beyond just selling resources, we offer a complete educational experience tailored to your needs.
                </p>
            </div>
            
            <div class="services-grid">
                <div class="service-card">
                    <span class="service-icon">🔍</span>
                    <h4 class="service-title">Resource Search & Sourcing</h4>
                    <p class="service-description">
                        Can't find a specific resource? Our expert team will help you locate rare, 
                        out-of-print, or hard-to-find educational materials from around the world.
                    </p>
                </div>
                
                <div class="service-card">
                    <span class="service-icon">📖</span>
                    <h4 class="service-title">Learning Consultation</h4>
                    <p class="service-description">
                        Get personalized learning recommendations from our education experts based 
                        on your interests, goals, and academic needs.
                    </p>
                </div>
                
                <div class="service-card">
                    <span class="service-icon">🎓</span>
                    <h4 class="service-title">Study Groups & Events</h4>
                    <p class="service-description">
                        Join our monthly study groups, expert-led sessions, and educational events. 
                        Connect with fellow learners and discover new perspectives.
                    </p>
                </div>
                
                <div class="service-card">
                    <span class="service-icon">📚</span>
                    <h4 class="service-title">Custom Collections</h4>
                    <p class="service-description">
                        Let us curate a personalized resource collection for your home study, 
                        classroom, or as a thoughtful gift for learners.
                    </p>
                </div>
                
                <div class="service-card">
                    <span class="service-icon">🚚</span>
                    <h4 class="service-title">Subscription Service</h4>
                    <p class="service-description">
                        Receive carefully selected educational materials delivered to your door monthly. 
                        Choose from various subjects and learning levels.
                    </p>
                </div>
                
                <div class="service-card">
                    <span class="service-icon">💝</span>
                    <h4 class="service-title">Gift Wrapping</h4>
                    <p class="service-description">
                        Make your educational gifts extra special with our premium gift wrapping service. 
                        Perfect for graduations, holidays, and special occasions.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Newsletter Section -->
    <section class="newsletter-section">
        <div class="container">
            <div class="newsletter-content">
                <h3>📬 Stay Updated</h3>
                <p>Subscribe to our newsletter and never miss new resources, exclusive deals, and educational events!</p>
                <form class="newsletter-form" id="newsletterForm">
                    <input type="email" placeholder="Enter your email address" required>
                    <button type="submit">Subscribe</button>
                </form>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="contact-section" id="contact">
        <div class="container">
            <div class="contact-grid">
                <div class="contact-info">
                    <h3>Get in Touch</h3>
                    <p>
                        We'd love to hear from you! Whether you have questions about our resources, 
                        need recommendations, or want to share your learning experience, our team 
                        is here to help.
                    </p>
                    
                    <div class="contact-details">
                        <div class="contact-item">
                            <span class="contact-item-icon">📍</span>
                            <span class="contact-item-text">123 Education Lane, Kandy, Central Province, Sri Lanka</span>
                        </div>
                        
                        <div class="contact-item">
                            <span class="contact-item-icon">📞</span>
                            <span class="contact-item-text">+94 81 234 5678</span>
                        </div>
                        
                        <div class="contact-item">
                            <span class="contact-item-icon">✉️</span>
                            <span class="contact-item-text">hello@pahanaedu.lk</span>
                        </div>
                        
                        <div class="contact-item">
                            <span class="contact-item-icon">🕒</span>
                            <span class="contact-item-text">Mon - Sat: 9:00 AM - 8:00 PM</span>
                        </div>
                    </div>
                    
                    <div class="social-links">
                        <a href="#" title="Facebook">📘</a>
                        <a href="#" title="Twitter">🐦</a>
                        <a href="#" title="Instagram">📷</a>
                        <a href="#" title="LinkedIn">💼</a>
                    </div>
                </div>
                
                <div class="contact-form">
                    <form id="contactForm">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <input type="text" id="subject" name="subject" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="message">Message</label>
                            <textarea id="message" name="message" required></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            📨 Send Message
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>Pahana Edu</h4>
                    <p>
                        Your premier destination for educational resources and learning experiences. 
                        We're passionate about connecting learners with their next great educational adventure.
                    </p>
                    <div class="social-links">
                        <a href="#" title="Facebook">📘</a>
                        <a href="#" title="Twitter">🐦</a>
                        <a href="#" title="Instagram">📷</a>
                        <a href="#" title="LinkedIn">💼</a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="#home">Home</a></li>
                        <li><a href="store">Browse Resources</a></li>
                        <% if (isLoggedIn) { %>
                            <li><a href="ManageOrdersServlet?action=history">Order History</a></li>
                        <% } else { %>
                            <li><a href="login.jsp">Login</a></li>
                        <% } %>
                        <li><a href="#services">Services</a></li>
                        <li><a href="#contact">Contact Us</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Categories</h4>
                    <ul>
                        <li><a href="store?category=fiction">Fiction</a></li>
                        <li><a href="store?category=non-fiction">Non-Fiction</a></li>
                        <li><a href="store?category=science">Science & Technology</a></li>
                        <li><a href="store?category=biography">Biography</a></li>
                        <li><a href="store?category=children">Children's Books</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>Customer Service</h4>
                    <ul>
                        <li><a href="#contact">Help Center</a></li>
                        <li><a href="#services">Shipping Info</a></li>
                        <li><a href="#services">Returns & Refunds</a></li>
                        <li><a href="#contact">Privacy Policy</a></li>
                        <li><a href="#contact">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 Pahana Edu. All rights reserved. Made with ❤️ for learners.</p>
            </div>
        </div>
    </footer>

    <!-- Scroll to Top Button -->
    <button class="scroll-top" id="scrollTop">↑</button>

    <script>
        // Page loader
        window.addEventListener('load', function() {
            setTimeout(() => {
                document.getElementById('pageLoader').classList.add('hidden');
            }, 1500);
        });

        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.getElementById('navbar');
            const scrollTop = document.getElementById('scrollTop');
            
            if (window.scrollY > 100) {
                navbar.classList.add('scrolled');
                scrollTop.classList.add('visible');
            } else {
                navbar.classList.remove('scrolled');
                scrollTop.classList.remove('visible');
            }
        });

        // Mobile menu toggle
        document.getElementById('mobileMenuBtn').addEventListener('click', function() {
            const navMenu = document.getElementById('navMenu');
            navMenu.classList.toggle('active');
            
            // Change hamburger icon
            this.innerHTML = navMenu.classList.contains('active') ? '✕' : '☰';
        });

        // Close mobile menu when clicking on a link
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', function() {
                const navMenu = document.getElementById('navMenu');
                const mobileMenuBtn = document.getElementById('mobileMenuBtn');
                navMenu.classList.remove('active');
                mobileMenuBtn.innerHTML = '☰';
            });
        });

        // Smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Scroll to top functionality
        document.getElementById('scrollTop').addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });

        // Contact form submission
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Create success message
            const successMsg = document.createElement('div');
            successMsg.innerHTML = `
                <div style="background: linear-gradient(135deg, #4CAF50, #45a049); color: white; padding: 1rem 2rem; border-radius: 12px; margin: 1rem 0; text-align: center; animation: slideInUp 0.5s ease-out;">
                    ✅ Message sent successfully! We'll get back to you soon.
                </div>
            `;
            
            // Insert success message after form
            this.parentNode.insertBefore(successMsg, this.nextSibling);
            
            // Reset form
            this.reset();
            
            // Remove success message after 5 seconds
            setTimeout(() => {
                successMsg.remove();
            }, 5000);
        });

        // Newsletter form submission
        document.getElementById('newsletterForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Create success message
            const successMsg = document.createElement('div');
            successMsg.innerHTML = `
                <div style="background: linear-gradient(135deg, #4CAF50, #45a049); color: white; padding: 1rem 2rem; border-radius: 12px; margin: 1rem 0; text-align: center; animation: slideInUp 0.5s ease-out;">
                    ✅ Successfully subscribed to our newsletter!
                </div>
            `;
            
            // Insert success message after form
            this.parentNode.insertBefore(successMsg, this.nextSibling);
            
            // Reset form
            this.reset();
            
            // Remove success message after 5 seconds
            setTimeout(() => {
                successMsg.remove();
            }, 5000);
        });

        // Enhanced button interactions with ripple effect
        document.addEventListener('DOMContentLoaded', function() {
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('click', function(e) {
                    // Create ripple effect
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

        // Observe elements for animation
        document.querySelectorAll('.stat-card, .feature-card, .service-card').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'all 0.6s ease-out';
            observer.observe(el);
        });

        // Dynamic typing effect for hero subtitle
        function typeWriter(element, text, speed = 100) {
            let i = 0;
            element.innerHTML = '';
            
            function type() {
                if (i < text.length) {
                    element.innerHTML += text.charAt(i);
                    i++;
                    setTimeout(type, speed);
                }
            }
            
            type();
        }

        // Initialize typing effect after page load
        setTimeout(() => {
            const heroSubtitle = document.querySelector('.hero-subtitle');
            if (heroSubtitle) {
                const originalText = heroSubtitle.textContent;
                typeWriter(heroSubtitle, originalText, 50);
            }
        }, 2000);

        // Add ripple animation keyframes
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);

        // Create floating particles periodically (less frequent)
        setInterval(createFloatingParticle, 6000);

        // Add some sparkle effects on mouse movement (reduced frequency)
        document.addEventListener('mousemove', function(e) {
            if (Math.random() > 0.995) { // Less frequent sparkles
                createSparkle(e.clientX, e.clientY);
            }
        });

        function createSparkle(x, y) {
            const sparkle = document.createElement('div');
            sparkle.innerHTML = '✨';
            sparkle.style.cssText = `
                position: fixed;
                left: ${x}px;
                top: ${y}px;
                font-size: ${Math.random() * 10 + 10}px;
                pointer-events: none;
                z-index: 10;
                animation: sparkleAnim 1s ease-out forwards;
            `;
            
            document.body.appendChild(sparkle);
            
            setTimeout(() => {
                sparkle.remove();
            }, 1000);
        }

        // Add sparkle animation
        const sparkleStyleSheet = document.createElement('style');
        sparkleStyleSheet.textContent = `
            @keyframes sparkleAnim {
                0% {
                    transform: scale(0) rotate(0deg);
                    opacity: 1;
                }
                50% {
                    transform: scale(1) rotate(180deg);
                    opacity: 1;
                }
                100% {
                    transform: scale(0) rotate(360deg);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(sparkleStyleSheet);
    </script>
</body>
</html>