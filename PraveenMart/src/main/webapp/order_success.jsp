<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.model.Order" %>
<%
    Order order = (Order) request.getAttribute("order");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.6">
    <style>
        .success-wrapper {
            padding: 5rem 1.5rem 7rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--hero-glow), var(--bg);
        }

        .success-card {
            background-color: var(--surface);
            border: 1px solid var(--surface-border);
            border-radius: 16px;
            padding: 4rem 3rem;
            max-width: 580px;
            width: 100%;
            text-align: center;
            box-shadow: var(--shadow-md);
        }

        .success-icon-box {
            width: 88px;
            height: 88px;
            background-color: rgba(52, 211, 153, 0.12);
            color: #125b40;
            border: 1px solid rgba(52, 211, 153, 0.25);
            border-radius: var(--radius-pill);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.8rem;
            box-shadow: 0 0 30px rgba(52, 211, 153, 0.15);
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<div class="success-wrapper">
    <div class="success-card">
        <div class="success-icon-box">
            <span class="material-symbols-outlined" style="font-size: 3.2rem;">check_circle</span>
        </div>

        <h1 style="font-size: 2.2rem; font-weight: 700; text-transform: uppercase; margin-bottom: 0.8rem; line-height: 1.1;">Order Confirmed</h1>
        <p style="color: var(--text); font-size: 1rem; line-height: 1.6; margin-bottom: 2.5rem;">
            Thank you for your order with PraveenMart. Your items have been confirmed and scheduled for prompt dispatch.
        </p>

        <% if (order != null) { %>
            <div style="background-color: var(--pill-inactive-bg); border: 1px solid var(--surface-border); border-radius: 12px; padding: 1.5rem; margin-bottom: 2.5rem; text-align: left;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.7rem; font-size: 0.95rem;">
                    <span style="color: var(--muted);">Order Reference:</span>
                    <span style="font-weight: 700; color: var(--price);">#ORD-<%= order.getId() %></span>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.7rem; font-size: 0.95rem;">
                    <span style="color: var(--muted);">Total Paid:</span>
                    <span style="font-weight: 700; color: var(--price); font-size: 1.15rem;"><%= currencyFormat.format(order.getTotalAmount()) %></span>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 0.95rem;">
                    <span style="color: var(--color-on-surface-variant);">Current Status:</span>
                    <span class="badge-tag badge-in-stock"><%= order.getStatus() %></span>
                </div>
            </div>
        <% } %>

        <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
            <a href="<%= request.getContextPath() %>/orders" class="btn btn-primary btn-pill" style="padding: 0.85rem 2rem;">
                <span class="material-symbols-outlined">receipt_long</span>
                <span>View Order History</span>
            </a>
            <a href="<%= request.getContextPath() %>/products" class="btn btn-secondary btn-pill" style="padding: 0.85rem 2rem;">
                <span>Continue Shopping</span>
            </a>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
