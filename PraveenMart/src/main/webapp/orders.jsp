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
        body {
            background-color: #000000;
        }

        .orders-wrapper {
            padding: 3rem 0 6rem;
        }

        .order-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 1.75rem;
            margin-bottom: 1.5rem;
            transition: border-color 150ms ease;
        }

        .order-card:hover {
            border-color: #3F3F46;
        }

        .order-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 1rem;
            border-bottom: 1px solid #1E1E22;
            margin-bottom: 1.25rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .order-item-mini-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.85rem 0;
            border-bottom: 1px solid #1E1E22;
        }

        .order-item-mini-row:last-child {
            border-bottom: none;
        }

        /* Mobile Screen Responsiveness */
        @media (max-width: 640px) {
            .orders-wrapper {
                padding: 1.25rem 0 3.5rem;
                width: 100%;
                max-width: 100%;
                overflow-x: hidden;
                box-sizing: border-box;
            }
            .order-card {
                padding: 1.1rem;
                margin-bottom: 1rem;
                width: 100%;
                max-width: 100%;
                box-sizing: border-box;
            }
            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.65rem;
            }
            .order-item-mini-row {
                flex-wrap: wrap;
                gap: 0.65rem;
            }
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<main class="container orders-wrapper">
    <div style="display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 2.5rem; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 style="font-family: var(--font-heading); font-size: 2.2rem; font-weight: 700; letter-spacing: -0.03em; margin-bottom: 0.35rem; line-height: 1.15; color: #FFFFFF;">Order History</h1>
            <p style="font-family: var(--font-mono); color: #888888; font-size: 0.85rem;">Review and track your recent orders and delivery progress.</p>
        </div>
        <a href="<%= request.getContextPath() %>/products" class="btn btn-secondary" style="border-radius: 4px; font-family: var(--font-mono); font-size: 0.85rem; padding: 0.6rem 1.25rem;">
            <span class="material-symbols-outlined" style="font-size: 1rem;">storefront</span>
            <span>Browse Products</span>
        </a>
    </div>

    <% if (orders != null && !orders.isEmpty()) { %>
        <% for (Order o : orders) { %>
            <div class="order-card">
                <div class="order-header">
                    <div>
                        <span style="font-family: var(--font-mono); font-size: 1rem; font-weight: 700; color: #FFFFFF;">#ORD-<%= o.getId() %></span>
                        <span style="font-family: var(--font-mono); color: #71717A; font-size: 0.8rem; margin-left: 0.8rem;">
                            Placed on <%= o.getCreatedAt() != null ? o.getCreatedAt().toLocalDate() : "" %>
                        </span>
                    </div>

                    <div style="display: flex; align-items: center; gap: 1.2rem;">
                        <% if ("DELIVERED".equalsIgnoreCase(o.getStatus())) { %>
                            <span class="badge-tag" style="background: #0C0C0C; border: 1px solid #27272A; color: #FFFFFF; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;">Delivered</span>
                        <% } else if ("SHIPPED".equalsIgnoreCase(o.getStatus())) { %>
                            <span class="badge-tag" style="background: #0C0C0C; border: 1px solid #27272A; color: #A1A1AA; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;">Shipped</span>
                        <% } else if ("CONFIRMED".equalsIgnoreCase(o.getStatus())) { %>
                            <span class="badge-tag" style="background: #0C0C0C; border: 1px solid #27272A; color: #D4D4D8; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;">Confirmed</span>
                        <% } else if ("CANCELLED".equalsIgnoreCase(o.getStatus())) { %>
                            <span class="badge-tag" style="background: #18181B; border: 1px solid #27272A; color: #71717A; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;">Cancelled</span>
                        <% } else { %>
                            <span class="badge-tag" style="background: #0C0C0C; border: 1px solid #27272A; color: #A1A1AA; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;"><%= o.getStatus() %></span>
                        <% } %>

                        <span style="font-family: var(--font-mono); font-size: 1.15rem; font-weight: 700; color: #FFFFFF;">
                            <%= currencyFormat.format(o.getTotalAmount()) %>
                        </span>
                    </div>
                </div>

                <div>
                    <% if (o.getItems() != null && !o.getItems().isEmpty()) { %>
                        <% for (OrderItem item : o.getItems()) { %>
                            <div class="order-item-mini-row">
                                <div style="display: flex; align-items: center; gap: 1rem;">
                                    <div style="width: 52px; height: 52px; border-radius: 4px; overflow: hidden; background: #000000; border: 1px solid #27272A;">
                                        <% if (item.getProductImageUrl() != null && !item.getProductImageUrl().isBlank()) { %>
                                            <img src="<%= item.getProductImageUrl() %>" alt="<%= item.getProductName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                                        <% } else { %>
                                            <img src="data:image/svg+xml;charset=UTF-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22300%22%20height%3D%22300%22%20viewBox%3D%220%200%20300%20300%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23080808%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20fill%3D%22%2371717A%22%20font-family%3D%22monospace%22%20font-size%3D%2216%22%20text-anchor%3D%22middle%22%20dominant-baseline%3D%22middle%22%3E%5B%20ITEM%20%5D%3C%2Ftext%3E%3C%2Fsvg%3E" alt="Item" style="width: 100%; height: 100%; object-fit: cover;">
                                        <% } %>
                                    </div>
                                    <div>
                                        <a href="<%= request.getContextPath() %>/product-details?id=<%= item.getProductId() %>" style="font-family: var(--font-heading); font-weight: 600; color: #FFFFFF; text-decoration: none; font-size: 0.95rem;">
                                            <%= item.getProductName() != null ? item.getProductName() : "Product #" + item.getProductId() %>
                                        </a>
                                        <div style="font-family: var(--font-mono); font-size: 0.78rem; color: #71717A; margin-top: 0.2rem;">
                                            Qty: <%= item.getQuantity() %> &times; <%= currencyFormat.format(item.getUnitPrice()) %>
                                        </div>
                                    </div>
                                </div>

                                <div style="font-family: var(--font-mono); font-weight: 700; font-size: 0.95rem; color: #FFFFFF;">
                                    <%= currencyFormat.format(item.getSubtotal()) %>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div class="order-card" style="text-align: center; padding: 4.5rem 1.5rem;">
            <span class="material-symbols-outlined" style="font-size: 3.5rem; color: #3F3F46; margin-bottom: 1rem;">receipt_long</span>
            <h2 style="font-size: 1.6rem; font-weight: 700; letter-spacing: -0.02em; margin-bottom: 0.5rem; color: #FFFFFF;">No Orders Yet</h2>
            <p style="color: #888888; font-family: var(--font-mono); max-width: 440px; margin: 0 auto 2rem; font-size: 0.88rem;">
                You haven't placed any orders yet. Discover our curated collections.
            </p>
            <a href="<%= request.getContextPath() %>/products" class="btn btn-primary" style="padding: 0.75rem 2rem; font-size: 0.88rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600;">
                <span>Explore Products</span>
                <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
            </a>
        </div>
    <% } %>
</main>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
