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
        body {
            background-color: #000000;
        }

        .success-wrapper {
            padding: 5rem 1.5rem 7rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #000000;
            width: 100%;
            box-sizing: border-box;
        }

        .success-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 3.5rem 2.5rem;
            max-width: 540px;
            width: 100%;
            box-sizing: border-box;
            text-align: center;
        }

        .success-icon-box {
            width: 64px;
            height: 64px;
            background-color: #0C0C0C;
            color: #FFFFFF;
            border: 1px solid #27272A;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }

        @media (max-width: 600px) {
            .success-wrapper {
                padding: 2rem 1rem 4rem;
            }
            .success-card {
                padding: 2rem 1.25rem;
            }
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<div class="success-wrapper">
    <div class="success-card">
        <div class="success-icon-box">
            <span class="material-symbols-outlined" style="font-size: 2rem;">check</span>
        </div>

        <h1 style="font-family: var(--font-heading); font-size: 1.8rem; font-weight: 700; letter-spacing: -0.03em; margin-bottom: 0.5rem; line-height: 1.15; color: #FFFFFF;">Order Confirmed</h1>
        <p style="font-family: var(--font-mono); color: #888888; font-size: 0.85rem; line-height: 1.6; margin-bottom: 2rem;">
            Thank you for your order with PraveenMart. Your items have been confirmed and scheduled for prompt dispatch.
        </p>

        <% if (order != null) { %>
            <div style="background-color: #000000; border: 1px solid #27272A; border-radius: 4px; padding: 1.25rem; margin-bottom: 2rem; text-align: left; font-family: var(--font-mono); font-size: 0.82rem;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.6rem;">
                    <span style="color: #71717A;">Order Reference:</span>
                    <span style="font-weight: 700; color: #FFFFFF;">#ORD-<%= order.getId() %></span>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.6rem;">
                    <span style="color: #71717A;">Total Paid:</span>
                    <span style="font-weight: 700; color: #FFFFFF;"><%= currencyFormat.format(order.getTotalAmount()) %></span>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="color: #71717A;">Current Status:</span>
                    <span class="badge-tag" style="background: #0C0C0C; border: 1px solid #27272A; color: #FFFFFF; font-family: var(--font-mono); font-size: 0.72rem; padding: 2px 8px; border-radius: 4px;"><%= order.getStatus() %></span>
                </div>
            </div>
        <% } %>

        <div style="display: flex; gap: 0.75rem; justify-content: center; flex-wrap: wrap;">
            <a href="<%= request.getContextPath() %>/orders" class="btn btn-primary" style="padding: 0.75rem 1.6rem; font-size: 0.85rem; border-radius: 4px; font-family: var(--font-mono); font-weight: 600;">
                <span class="material-symbols-outlined" style="font-size: 1rem;">receipt_long</span>
                <span>View Order History</span>
            </a>
            <a href="<%= request.getContextPath() %>/products" class="btn btn-secondary" style="padding: 0.75rem 1.6rem; font-size: 0.85rem; border-radius: 4px; font-family: var(--font-mono);">
                <span>Continue Shopping</span>
            </a>
        </div>
    </div>
</div>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
