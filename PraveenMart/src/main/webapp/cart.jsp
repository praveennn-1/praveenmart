<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.model.CartItem" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    BigDecimal subtotal = (BigDecimal) request.getAttribute("subtotal");
    BigDecimal shipping = (BigDecimal) request.getAttribute("shipping");
    BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");

    if (subtotal == null) subtotal = BigDecimal.ZERO;
    if (shipping == null) shipping = BigDecimal.ZERO;
    if (grandTotal == null) grandTotal = BigDecimal.ZERO;

    String cartMessage = (String) session.getAttribute("cartMessage");
    String cartError = (String) session.getAttribute("cartError");
    session.removeAttribute("cartMessage");
    session.removeAttribute("cartError");

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <style>
        .cart-wrapper {
            padding: 3rem 0 5rem;
        }

        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 2.5rem;
            align-items: start;
        }

        @media (max-width: 900px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }
        }

        .cart-table-card {
            background-color: var(--color-surface-card);
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-xl);
            padding: 1.5rem;
            box-shadow: var(--shadow-soft);
        }

        .cart-item-row {
            display: grid;
            grid-template-columns: 80px 1fr auto auto auto;
            gap: 1.25rem;
            align-items: center;
            padding: 1.25rem 0;
            border-bottom: 1px solid var(--color-surface-container);
        }

        .cart-item-row:last-child {
            border-bottom: none;
        }

        .cart-item-thumb {
            width: 80px;
            height: 80px;
            border-radius: var(--radius-md);
            overflow: hidden;
            background-color: var(--color-surface-container);
        }

        .cart-item-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .summary-card {
            background-color: var(--color-surface-container-low);
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-xl);
            padding: 1.8rem;
            box-shadow: var(--shadow-soft);
        }

        .summary-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
            font-size: 0.95rem;
            color: var(--color-on-surface-variant);
        }

        .summary-row.total {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--color-neutral-dark);
            border-top: 1px solid var(--color-outline-variant);
            padding-top: 1rem;
            margin-top: 1.25rem;
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<main class="container cart-wrapper">
    <h1 style="font-size: 2.2rem; font-weight: 700; margin-bottom: 2rem;">Your Shopping Cart</h1>

    <% if (cartMessage != null) { %>
        <div class="alert-box alert-box-success">
            <span class="material-symbols-outlined">check_circle</span>
            <span><%= cartMessage %></span>
        </div>
    <% } %>

    <% if (cartError != null) { %>
        <div class="alert-box alert-box-error">
            <span class="material-symbols-outlined">warning</span>
            <span><%= cartError %></span>
        </div>
    <% } %>

    <% if (cartItems != null && !cartItems.isEmpty()) { %>
        <div class="cart-layout">

            <div class="cart-table-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 1px solid var(--color-surface-container);">
                    <span style="font-weight: 700; font-size: 0.9rem; color: var(--color-on-surface-variant); text-transform: uppercase;">Items (<%= cartItems.size() %>)</span>
                    <a href="<%= request.getContextPath() %>/cart/clear" class="btn btn-outlined btn-pill" style="padding: 0.3rem 0.8rem; font-size: 0.78rem;" onclick="return confirm('Clear entire cart?');">
                        <span class="material-symbols-outlined" style="font-size: 0.95rem;">delete_sweep</span>
                        <span>Clear Cart</span>
                    </a>
                </div>

                <% for (CartItem item : cartItems) {
                    Product p = item.getProduct();
                %>
                    <div class="cart-item-row">

                        <div class="cart-item-thumb">
                            <% 
                                String cImg = (p != null) ? p.getImageUrl() : null;
                                if (cImg != null && !cImg.isBlank()) {
                                    if (!cImg.startsWith("http://") && !cImg.startsWith("https://")) {
                                        if (!cImg.startsWith("/")) {
                                            cImg = "/" + cImg;
                                        }
                                        cImg = request.getContextPath() + cImg;
                                    }
                            %>
                                <img src="<%= cImg %>" alt="<%= p.getName() %>">
                            <% } else { %>
                                <img src="https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80" alt="Product Thumbnail">
                            <% } %>
                        </div>

                        <div>
                            <div style="font-size: 0.78rem; font-weight: 700; color: var(--color-primary); text-transform: uppercase;"><%= p != null ? p.getCategory() : "" %></div>
                            <a href="<%= request.getContextPath() %>/product-details?id=<%= item.getProductId() %>" style="font-weight: 700; font-size: 1.05rem; color: var(--color-on-surface); text-decoration: none;">
                                <%= p != null ? p.getName() : "Item #" + item.getProductId() %>
                            </a>
                            <div style="font-size: 0.85rem; color: var(--color-on-surface-variant); margin-top: 0.2rem;">
                                Unit Price: <%= p != null ? currencyFormat.format(p.getPrice()) : "" %>
                            </div>
                        </div>

                        <div>
                            <form action="<%= request.getContextPath() %>/cart/update" method="post" style="display: flex; align-items: center; gap: 0.3rem;">
                                <input type="hidden" name="cartItemId" value="<%= item.getId() %>">
                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="<%= p != null ? p.getStockQty() : 99 %>" class="form-input-field" style="width: 60px; text-align: center; background: #FFFFFF; border: 1px solid var(--color-outline-variant); border-radius: var(--radius-sm); padding: 0.35rem;" required>
                                <button type="submit" class="btn btn-secondary btn-pill" style="padding: 0.35rem 0.6rem; font-size: 0.8rem;" title="Update Quantity">
                                    <span class="material-symbols-outlined" style="font-size: 1rem;">sync</span>
                                </button>
                            </form>
                        </div>

                        <div style="font-weight: 700; font-size: 1.1rem; color: var(--color-neutral-dark); text-align: right;">
                            <%= currencyFormat.format(item.getItemTotal()) %>
                        </div>

                        <div>
                            <form action="<%= request.getContextPath() %>/cart/remove" method="post">
                                <input type="hidden" name="cartItemId" value="<%= item.getId() %>">
                                <button type="submit" class="nav-icon-btn" style="width: 32px; height: 32px; border-color: transparent;" title="Remove Item">
                                    <span class="material-symbols-outlined" style="font-size: 1.1rem; color: var(--color-danger);">delete</span>
                                </button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>

            <div class="summary-card">
                <h3 style="font-size: 1.3rem; margin-bottom: 1.5rem; font-weight: 700;">Order Summary</h3>

                <div class="summary-row">
                    <span>Subtotal</span>
                    <span style="font-weight: 600;"><%= currencyFormat.format(subtotal) %></span>
                </div>

                <div class="summary-row">
                    <span>Standard Shipping</span>
                    <span style="font-weight: 600;">
                        <% if (shipping.compareTo(BigDecimal.ZERO) == 0) { %>
                            <span style="color: var(--color-success); font-weight: 700;">FREE</span>
                        <% } else { %>
                            <%= currencyFormat.format(shipping) %>
                        <% } %>
                    </span>
                </div>

                <% if (subtotal.compareTo(new BigDecimal("2000")) < 0) { %>
                    <p style="font-size: 0.8rem; color: var(--color-on-surface-variant); margin-top: -0.5rem; margin-bottom: 1rem;">
                        Add <strong><%= currencyFormat.format(new BigDecimal("2000").subtract(subtotal)) %></strong> more for FREE shipping!
                    </p>
                <% } %>

                <div class="summary-row total">
                    <span>Grand Total</span>
                    <span><%= currencyFormat.format(grandTotal) %></span>
                </div>

                <a href="<%= request.getContextPath() %>/checkout" class="btn btn-primary btn-pill" style="width: 100%; padding: 0.95rem; font-size: 1rem; margin-top: 1.5rem;">
                    <span>Proceed to Checkout</span>
                    <span class="material-symbols-outlined">arrow_forward</span>
                </a>

                <div style="text-align: center; margin-top: 1rem;">
                    <a href="<%= request.getContextPath() %>/products" style="font-size: 0.88rem; color: var(--color-on-surface-variant); text-decoration: underline;">
                        ← Continue Shopping
                    </a>
                </div>
            </div>
        </div>
    <% } else { %>

        <div class="card-white" style="text-align: center; padding: 4rem 1.5rem;">
            <span class="material-symbols-outlined" style="font-size: 4.5rem; color: var(--color-outline); margin-bottom: 1rem;">shopping_bag</span>
            <h2 style="font-size: 1.8rem; margin-bottom: 0.5rem;">Your Cart is Empty</h2>
            <p style="color: var(--color-on-surface-variant); max-width: 440px; margin: 0 auto 2rem;">
                Looks like you haven't added any artisanal goods to your cart yet. Explore our curated collections!
            </p>
            <a href="<%= request.getContextPath() %>/products" class="btn btn-primary btn-pill" style="padding: 0.8rem 2rem;">
                <span>Explore Catalog</span>
                <span class="material-symbols-outlined">arrow_forward</span>
            </a>
        </div>
    <% } %>
</main>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
