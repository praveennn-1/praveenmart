<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Dashboard - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.6">
    <style>
        .dashboard-container {
            max-width: 640px;
            margin: 4.5rem auto 6rem auto;
        }

        .profile-card {
            background-color: var(--color-surface-card);
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-2xl);
            padding: 3rem 2.5rem;
            box-shadow: var(--shadow-md);
            text-align: center;
        }

        .avatar-circle {
            width: 84px;
            height: 84px;
            border-radius: var(--radius-pill);
            background: var(--btn-bg);
            color: var(--btn-text);
            font-family: var(--font-heading);
            font-size: 2.2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem auto;
            box-shadow: none;
        }

        .info-list {
            display: flex;
            flex-direction: column;
            gap: 0.85rem;
            margin: 2.2rem 0;
            text-align: left;
        }

        .info-item {
            background-color: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-md);
            padding: 1rem 1.25rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .info-key {
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--color-on-surface-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
        }

        .info-val {
            font-weight: 600;
            color: #ffffff;
        }
    </style>
</head>
<body>

    <%@ include file="/includes/header.jspf" %>

    <main class="container">
        <div class="dashboard-container">
            <% if (user != null) { %>
                <div class="profile-card">
                    <div class="avatar-circle">
                        <%= (user.getName() != null && !user.getName().isBlank()) ? user.getName().substring(0, 1).toUpperCase() : "U" %>
                    </div>

                    <h1 style="font-size: 2rem; font-weight: 700; text-transform: uppercase; margin-bottom: 0.4rem;">
                        <%= user.getName() %>
                    </h1>
                    <p style="color: var(--text); font-size: 0.95rem;">PraveenMart Member &bull; <%= user.getRole() %></p>

                    <div class="info-list">
                        <div class="info-item">
                            <span class="info-key">Full Name</span>
                            <span class="info-val"><%= user.getName() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-key">Email</span>
                            <span class="info-val"><%= user.getEmail() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-key">Status</span>
                            <span class="badge-tag badge-in-stock">Active Member</span>
                        </div>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 0.85rem;">
                        <% if ("ADMIN".equalsIgnoreCase(user.getRole()) && "admin@praveenmart.com".equalsIgnoreCase(user.getEmail())) { %>
                            <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-primary btn-pill" style="width: 100%;">
                                <span class="material-symbols-outlined">admin_panel_settings</span>
                                <span>Open Admin Control Center</span>
                            </a>
                        <% } %>

                        <% if ("SELLER".equalsIgnoreCase(user.getRole())) { %>
                            <a href="<%= request.getContextPath() %>/seller/dashboard" class="btn btn-secondary btn-pill" style="width: 100%;">
                                <span class="material-symbols-outlined">inventory_2</span>
                                <span>Open Seller Hub & Inventory</span>
                            </a>
                        <% } %>

                        <% if (!"ADMIN".equalsIgnoreCase(user.getRole())) { %>
                            <a href="<%= request.getContextPath() %>/orders" class="btn btn-secondary btn-pill" style="width: 100%;">
                                <span class="material-symbols-outlined">receipt_long</span>
                                <span>My Order History</span>
                            </a>

                            <a href="<%= request.getContextPath() %>/products" class="btn btn-primary btn-pill" style="width: 100%;">
                                <span class="material-symbols-outlined">storefront</span>
                                <span>Explore Products</span>
                            </a>
                        <% } %>

                        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outlined btn-pill" style="width: 100%;">
                            <span class="material-symbols-outlined">logout</span>
                            <span>Sign Out</span>
                        </a>
                    </div>
                </div>
            <% } else { %>
                <div class="profile-card">
                    <span class="material-symbols-outlined" style="font-size: 3.5rem; color: var(--muted); margin-bottom: 1rem;">lock</span>
                    <h2 style="font-size: 1.8rem; text-transform: uppercase; margin-bottom: 0.5rem;">Access Required</h2>
                    <p style="color: var(--text); margin-bottom: 2rem;">Please sign in to view your profile dashboard.</p>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary btn-pill" style="padding: 0.85rem 2rem;">Sign In</a>
                </div>
            <% } %>
        </div>
    </main>

    <%@ include file="/includes/footer.jspf" %>

</body>
</html>
