<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.model.Order" %>
<%@ page import="com.praveen.praveenmart.model.OrderItem" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.6">
    <style>
        .orders-wrapper {
            padding: 3.5rem 0 6rem;
        }

        .order-card {
            background-color: var(--surface);
            border: 1px solid var(--surface-border);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-soft);
            transition: border-color 0.2s ease;
        }

        .order-card:hover {
            border-color: rgba(255, 255, 255, 0.14);
        }

        .order-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 1.2rem;
            border-bottom: 1px solid var(--divider);
            margin-bottom: 1.4rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .order-item-mini-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 0;
            border-bottom: 1px solid var(--divider);
        }

        .order-item-mini-row:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<main class="container orders-wrapper">
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 2.5rem; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 style="font-size: 2.4rem; font-weight: 700; text-transform: uppercase; margin-bottom: 0.4rem; line-height: 1.1;">Order History</h1>
            <p style="color: var(--text); font-size: 0.95rem;">Review and track your recent orders and delivery progress.</p>
        </div>
        <a href="<%= request.getContextPath() %>/products" class="btn btn-secondary btn-pill">
            <span class="material-symbols-outlined">storefront</span>
            <span>Browse Products</span>
        </a>
    </div>

    <% if (orders != null && !orders.isEmpty()) { %>
        <% for (Order o : orders) { %>
            <div class="order-card">
                <div class="order-header">
                    <div>
                        <span style="font-size: 1.2rem; font-weight: 700; color: var(--price);">#ORD-<%= o.getId() %></span>
                        <span style="color: var(--muted); font-size: 0.88rem; margin-left: 0.8rem;">
                            Placed on <%= o.getCreatedAt() != null ? o.getCreatedAt().toLocalDate() : "" %>
                        </span>
                    </div>

                    <div style="display: flex; align-items: center; gap: 1.2rem;">
                        <% if ("DELIVERED".equalsIgnoreCase(o.getStatus())) { %>
                            <span class="badge-tag badge-in-stock">Delivered</span>
                        <% } else if ("SHIPPED".equalsIgnoreCase(o.getStatus())) { %>
                            <span class="badge-tag badge-tertiary">Shipped</span>
                        <% } else if ("CONFIRMED".equalsIgnoreCase(o.getStatus())) { %>
                            <span class="badge-tag badge-primary">Confirmed</span>
                        <% } else if ("CANCELLED".equalsIgnoreCase(o.getStatus())) { %>
                            <span class="badge-tag badge-out-stock">Cancelled</span>
                        <% } else { %>
                            <span class="badge-tag badge-low-stock"><%= o.getStatus() %></span>
                        <% } %>

                        <span style="font-size: 1.35rem; font-weight: 700; color: var(--price);">
                            <%= currencyFormat.format(o.getTotalAmount()) %>
                        </span>
                    </div>
                </div>

                <div>
                    <% if (o.getItems() != null && !o.getItems().isEmpty()) { %>
                        <% for (OrderItem item : o.getItems()) { %>
                            <div class="order-item-mini-row">
                                <div style="display: flex; align-items: center; gap: 1.2rem;">
                                    <div style="width: 58px; height: 58px; border-radius: 10px; overflow: hidden; background: var(--bg); border: 1px solid var(--surface-border);">
                                        <% if (item.getProductImageUrl() != null && !item.getProductImageUrl().isBlank()) { %>
                                            <img src="<%= item.getProductImageUrl() %>" alt="<%= item.getProductName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                        <% } else { %>
                                            <img src="https://images.unsplash.com/photo-1544816155-12df9643f363?w=300&auto=format&fit=crop&q=80" alt="Item" style="width: 100%; height: 100%; object-fit: cover;">
                                        <% } %>
                                    </div>
                                    <div>
                                        <a href="<%= request.getContextPath() %>/product-details?id=<%= item.getProductId() %>" style="font-weight: 600; color: var(--heading); text-decoration: none; font-size: 1.05rem;">
                                            <%= item.getProductName() != null ? item.getProductName() : "Product #" + item.getProductId() %>
                                        </a>
                                        <div style="font-size: 0.85rem; color: var(--text); margin-top: 0.2rem;">
                                            Qty: <%= item.getQuantity() %> &times; <%= currencyFormat.format(item.getUnitPrice()) %>
                                        </div>
                                    </div>
                                </div>

                                <div style="font-weight: 700; font-size: 1.1rem; color: var(--price);">
                                    <%= currencyFormat.format(item.getSubtotal()) %>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div class="order-card" style="text-align: center; padding: 5rem 1.5rem;">
            <span class="material-symbols-outlined" style="font-size: 4rem; color: var(--muted); margin-bottom: 1rem;">receipt_long</span>
            <h2 style="font-size: 1.8rem; text-transform: uppercase; margin-bottom: 0.5rem;">No Orders Yet</h2>
            <p style="color: var(--text); max-width: 440px; margin: 0 auto 2.2rem; font-size: 0.95rem;">
                You haven't placed any orders yet. Discover our curated collection and special offers.
            </p>
            <a href="<%= request.getContextPath() %>/products" class="btn btn-primary btn-pill" style="padding: 0.85rem 2.2rem;">
                <span>Explore Products</span>
                <span class="material-symbols-outlined">arrow_forward</span>
            </a>
        </div>
    <% } %>
</main>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
