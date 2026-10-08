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
        body {
            background-color: #000000;
        }

        .dashboard-container {
            max-width: 580px;
            margin: 4rem auto 6rem auto;
        }

        .profile-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 3rem 2.25rem;
            text-align: center;
        }

        .avatar-box {
            width: 72px;
            height: 72px;
            border-radius: 4px;
            background: #0C0C0C;
            border: 1px solid #27272A;
            color: #FFFFFF;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 1.8rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem auto;
        }

        .info-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin: 2rem 0;
            text-align: left;
        }

        .info-item {
            background-color: #000000;
            border: 1px solid #27272A;
            border-radius: 4px;
            padding: 0.85rem 1.15rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .info-key {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.78rem;
            font-weight: 600;
            color: #71717A;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .info-val {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.88rem;
            font-weight: 600;
            color: #FFFFFF;
        }
    </style>
</head>
<body>

    <%@ include file="/includes/header.jspf" %>

    <main class="container">
        <div class="dashboard-container">
            <% if (user != null) { %>
                <div class="profile-card">
                    <div class="avatar-box">
                        <%= (user.getName() != null && !user.getName().isBlank()) ? user.getName().substring(0, 1).toUpperCase() : "U" %>
                    </div>

                    <h1 style="font-family: var(--font-heading); font-size: 1.8rem; font-weight: 700; letter-spacing: -0.03em; margin-bottom: 0.35rem; color: #FFFFFF;">
                        <%= user.getName() %>
                    </h1>
                    <p style="font-family: var(--font-mono); color: #888888; font-size: 0.82rem;">member &bull; <%= user.getRole().toLowerCase() %></p>

                    <div class="info-list">
                        <div class="info-item">
                            <span class="info-key">Name</span>
                            <span class="info-val"><%= user.getName() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-key">Email</span>
                            <span class="info-val"><%= user.getEmail() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-key">Status</span>
                            <span class="badge-tag" style="background: #0C0C0C; border: 1px solid #27272A; color: #FFFFFF; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;">Active</span>
                        </div>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                        <% if ("ADMIN".equalsIgnoreCase(user.getRole()) && "admin@praveenmart.com".equalsIgnoreCase(user.getEmail())) { %>
                            <a href="<%= request.getContextPath() %>/admin/dashboard" class="btn btn-primary" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem; padding: 0.75rem;">
                                <span class="material-symbols-outlined" style="font-size: 1.1rem;">admin_panel_settings</span>
                                <span>Open Admin Control Center</span>
                            </a>
                        <% } %>

                        <% if ("SELLER".equalsIgnoreCase(user.getRole())) { %>
                            <a href="<%= request.getContextPath() %>/seller/dashboard" class="btn btn-secondary" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem; padding: 0.75rem;">
                                <span class="material-symbols-outlined" style="font-size: 1.1rem;">inventory_2</span>
                                <span>Open Seller Hub & Inventory</span>
                            </a>
                        <% } %>

                        <% if (!"ADMIN".equalsIgnoreCase(user.getRole())) { %>
                            <a href="<%= request.getContextPath() %>/orders" class="btn btn-secondary" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem; padding: 0.75rem;">
                                <span class="material-symbols-outlined" style="font-size: 1.1rem;">receipt_long</span>
                                <span>My Order History</span>
                            </a>

                            <a href="<%= request.getContextPath() %>/products" class="btn btn-primary" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-weight: 600; font-size: 0.88rem; padding: 0.75rem;">
                                <span class="material-symbols-outlined" style="font-size: 1.1rem;">storefront</span>
                                <span>Explore Products</span>
                            </a>
                        <% } %>

                        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outlined" style="width: 100%; border-radius: 4px; font-family: var(--font-mono); font-size: 0.85rem; padding: 0.75rem;">
                            <span class="material-symbols-outlined" style="font-size: 1.1rem;">logout</span>
                            <span>Sign Out</span>
                        </a>
                    </div>
                </div>
            <% } else { %>
                <div class="profile-card">
                    <span class="material-symbols-outlined" style="font-size: 3rem; color: #3F3F46; margin-bottom: 1rem;">lock</span>
                    <h2 style="font-family: var(--font-heading); font-size: 1.6rem; font-weight: 700; letter-spacing: -0.02em; margin-bottom: 0.5rem; color: #FFFFFF;">Access Required</h2>
                    <p style="font-family: var(--font-mono); color: #888888; margin-bottom: 2rem; font-size: 0.88rem;">Please sign in to view your profile dashboard.</p>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary" style="padding: 0.75rem 2rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600;">Sign In</a>
                </div>
            <% } %>
        </div>
    </main>

    <%@ include file="/includes/footer.jspf" %>

</body>
</html>
