<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String searchQuery = (String) request.getAttribute("searchQuery");
    if (selectedCategory == null) selectedCategory = "all";
    if (searchQuery == null) searchQuery = "";

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
    <title>PraveenMart - Organic & Artisan Marketplace</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <style>
        .hero-banner {
            background: linear-gradient(135deg, var(--color-surface-container) 0%, var(--color-surface-container-low) 100%);
            border-bottom: 1px solid var(--color-outline-variant);
            padding: 2.2rem 0 1.8rem;
            text-align: center;
        }

        .hero-title {
            font-size: 2.8rem;
            font-weight: 700;
            color: var(--color-on-surface);
            margin-bottom: 0.8rem;
            letter-spacing: -0.02em;
        }

        .hero-subtitle {
            font-size: 1.15rem;
            color: var(--color-on-surface-variant);
            max-width: 600px;
            margin: 0 auto 2rem;
        }

        .search-bar-wrapper {
            max-width: 620px;
            margin: 0 auto;
        }

        .search-form {
            display: flex;
            background: #FFFFFF;
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-pill);
            padding: 0.35rem 0.5rem 0.35rem 1.4rem;
            box-shadow: var(--shadow-md);
            transition: all 0.2s ease;
        }

        .search-form:focus-within {
            border-color: var(--color-primary);
            box-shadow: 0 6px 24px rgba(74, 124, 89, 0.18);
        }

        .search-input {
            flex: 1;
            border: none;
            outline: none;
            font-size: 1rem;
            font-family: var(--font-body);
            background: transparent;
            color: var(--color-on-surface);
        }

        .category-pills {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            flex-wrap: wrap;
            margin: 2.5rem 0 1rem;
        }

        .category-pill {
            padding: 0.5rem 1.25rem;
            border-radius: var(--radius-pill);
            font-size: 0.9rem;
            font-weight: 600;
            background-color: var(--color-surface-container);
            color: var(--color-on-surface-variant);
            border: 1px solid var(--color-outline-variant);
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .category-pill:hover, .category-pill.active {
            background-color: var(--color-primary);
            color: #FFFFFF;
            border-color: var(--color-primary);
            box-shadow: var(--shadow-soft);
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
            gap: 2rem;
            padding: 2.5rem 0 4rem;
        }

        .product-card {
            background-color: var(--color-surface-card);
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-lg);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
        }

        .product-image-box {
            height: 220px;
            width: 100%;
            background-color: var(--color-surface-container);
            position: relative;
            overflow: hidden;
        }

        .product-image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image-box img {
            transform: scale(1.05);
        }

        .product-content {
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .product-category-tag {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--color-primary);
            margin-bottom: 0.3rem;
        }

        .product-title {
            font-family: var(--font-headline);
            font-size: 1.15rem;
            font-weight: 600;
            color: var(--color-on-surface);
            margin-bottom: 0.4rem;
            text-decoration: none;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .product-title:hover {
            color: var(--color-primary);
        }

        .product-desc {
            font-size: 0.85rem;
            color: var(--color-on-surface-variant);
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex: 1;
        }

        .product-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: auto;
            padding-top: 0.75rem;
            border-top: 1px solid var(--color-surface-container);
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .product-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--color-neutral-dark);
        }

        .card-qty-stepper {
            display: inline-flex;
            align-items: center;
            border: 1px solid var(--color-outline-variant);
            border-radius: var(--radius-pill);
            background: var(--color-surface-container);
            overflow: hidden;
            height: 32px;
        }

        .card-qty-stepper .qty-btn {
            background: transparent;
            border: none;
            width: 26px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            font-weight: 700;
            color: var(--color-on-surface);
            cursor: pointer;
            transition: background-color 0.15s ease, color 0.15s ease;
            user-select: none;
            padding: 0;
        }

        .card-qty-stepper .qty-btn:hover {
            background: rgba(13, 71, 34, 0.12);
            color: var(--color-primary);
        }

        .card-qty-stepper .qty-btn:active {
            transform: scale(0.92);
        }

        .card-qty-stepper .qty-input-field {
            width: 26px;
            border: none;
            background: transparent;
            text-align: center;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--color-on-surface);
            -moz-appearance: textfield;
            padding: 0;
            pointer-events: none;
        }

        .card-qty-stepper .qty-input-field::-webkit-outer-spin-button,
        .card-qty-stepper .qty-input-field::-webkit-inner-spin-button {
            -webkit-appearance: none;
            appearance: none;
            margin: 0;
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<section class="hero-banner">
    <div class="container">

        <div class="search-bar-wrapper">
            <form action="<%= request.getContextPath() %>/products" method="get" class="search-form">
                <input type="text" name="q" class="search-input" placeholder="Search products, descriptions, keywords..." value="<%= searchQuery %>">
                <% if (!"all".equalsIgnoreCase(selectedCategory)) { %>
                    <input type="hidden" name="category" value="<%= selectedCategory %>">
                <% } %>
                <button type="submit" class="btn btn-primary btn-pill" style="padding: 0.6rem 1.4rem;">
                    <span class="material-symbols-outlined">search</span>
                    <span>Search</span>
                </button>
            </form>
        </div>

        <div class="category-pills">
            <a href="<%= request.getContextPath() %>/products" class="category-pill <%= "all".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">All Products</a>
            <a href="<%= request.getContextPath() %>/products?category=Fashion%20%26%20Style<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>" class="category-pill <%= selectedCategory != null && (selectedCategory.toLowerCase().contains("fashion") || selectedCategory.toLowerCase().contains("apparel") || selectedCategory.toLowerCase().contains("style")) ? "active" : "" %>">Fashion & Style</a>
            <a href="<%= request.getContextPath() %>/products?category=Home%20%26%20Kitchen<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>" class="category-pill <%= selectedCategory != null && (selectedCategory.toLowerCase().contains("home") || selectedCategory.toLowerCase().contains("kitchen")) ? "active" : "" %>">Home & Kitchen</a>
            <a href="<%= request.getContextPath() %>/products?category=Electronics<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>" class="category-pill <%= "Electronics".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">Electronics</a>
            <a href="<%= request.getContextPath() %>/products?category=Accessories<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>" class="category-pill <%= "Accessories".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">Accessories</a>
        </div>
    </div>
</section>

<main class="container">
    <% if (cartMessage != null) { %>
        <div class="alert-box alert-box-success" style="margin-top: 1.5rem;">
            <span class="material-symbols-outlined">check_circle</span>
            <span><%= cartMessage %></span>
        </div>
    <% } %>

    <% if (cartError != null) { %>
        <div class="alert-box alert-box-error" style="margin-top: 1.5rem;">
            <span class="material-symbols-outlined">warning</span>
            <span><%= cartError %></span>
        </div>
    <% } %>

    <div class="products-grid">
        <% if (products != null && !products.isEmpty()) { %>
            <% for (Product p : products) { %>
                <div class="product-card">
                    <div class="product-image-box">
                        <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>">
                            <% 
                                String pImg = p.getImageUrl();
                                if (pImg != null && !pImg.isBlank()) {
                                    if (!pImg.startsWith("http://") && !pImg.startsWith("https://")) {
                                        if (!pImg.startsWith("/")) {
                                            pImg = "/" + pImg;
                                        }
                                        pImg = request.getContextPath() + pImg;
                                    }
                            %>
                                <img src="<%= pImg %>" alt="<%= p.getName() %>" onerror="this.src='https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80'">
                            <% } else { %>
                                <img src="https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80" alt="Product Placeholder">
                            <% } %>
                        </a>
                        <div style="position: absolute; top: 12px; right: 12px;">
                            <% if (p.getStockQty() > 10) { %>
                                <span class="badge-tag badge-in-stock">In Stock</span>
                            <% } else if (p.getStockQty() > 0) { %>
                                <span class="badge-tag badge-low-stock">Only <%= p.getStockQty() %> Left</span>
                            <% } else { %>
                                <span class="badge-tag badge-out-stock">Sold Out</span>
                            <% } %>
                        </div>
                    </div>

                    <div class="product-content">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.4rem;">
                            <div class="product-category-tag"><%= p.getCategory() %></div>
                            <% 
                                double ratingVal = 4.3 + ((p.getId() != null ? p.getId() : 1) % 7) * 0.1;
                                if (ratingVal > 4.9) ratingVal = 4.9;
                                int reviewCount = 85 + (int)((p.getId() != null ? p.getId() : 1) * 43) % 450;
                            %>
                            <div style="display: flex; align-items: center; gap: 0.3rem;">
                                <span style="background-color: #388e3c; color: #FFFFFF; font-size: 0.75rem; font-weight: 700; padding: 0.15rem 0.45rem; border-radius: 4px; display: inline-flex; align-items: center; gap: 0.15rem;">
                                    <%= String.format(Locale.US, "%.1f", ratingVal) %> ★
                                </span>
                                <span style="font-size: 0.78rem; color: var(--color-on-surface-variant); font-weight: 600;">(<%= reviewCount %>)</span>
                            </div>
                        </div>

                        <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>" class="product-title">
                            <%= p.getName() %>
                        </a>
                        <p class="product-desc"><%= p.getDescription() != null ? p.getDescription() : "Authentic craft item." %></p>

                        <div style="margin-top: 0.4rem; font-size: 0.78rem; color: #1e7e34; font-weight: 700; display: flex; align-items: center; gap: 0.25rem;">
                            <span class="material-symbols-outlined" style="font-size: 0.95rem;">local_shipping</span>
                            <span>Free Express Delivery</span>
                        </div>

                        <div class="product-footer" style="margin-top: 0.8rem;">
                            <div>
                                <div class="product-price">
                                    <%= currencyFormat.format(p.getPrice() != null ? p.getPrice() : BigDecimal.ZERO) %>
                                </div>
                                <div style="font-size: 0.78rem; color: var(--color-on-surface-variant);">
                                    M.R.P.: <span style="text-decoration: line-through;"><%= currencyFormat.format((p.getPrice() != null ? p.getPrice() : BigDecimal.ZERO).multiply(new BigDecimal("1.4"))) %></span>
                                    <span style="color: #388e3c; font-weight: 700; margin-left: 0.2rem;">40% OFF</span>
                                </div>
                            </div>

                            <% if (p.getStockQty() > 0) { %>
                                <form action="<%= request.getContextPath() %>/cart/add" method="post" class="add-to-cart-form"
                                      data-product-id="<%= p.getId() %>"
                                      data-product-name="<%= p.getName().replace("\"", "&quot;") %>"
                                      data-product-price="<%= currencyFormat.format(p.getPrice() != null ? p.getPrice() : BigDecimal.ZERO) %>"
                                      data-product-category="<%= p.getCategory() != null ? p.getCategory().replace("\"", "&quot;") : "" %>"
                                      data-product-image="<%= p.getImageUrl() != null ? p.getImageUrl() : "" %>"
                                      style="display: flex; align-items: center; gap: 0.4rem;">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <div class="card-qty-stepper">
                                        <button type="button" class="qty-btn qty-btn-minus" aria-label="Decrease quantity">−</button>
                                        <input type="number" name="quantity" class="qty-input-field" value="1" min="1" max="<%= p.getStockQty() %>" readonly>
                                        <button type="button" class="qty-btn qty-btn-plus" aria-label="Increase quantity">+</button>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-pill btn-add-cart" style="padding: 0.45rem 0.85rem; font-size: 0.85rem; display: inline-flex; align-items: center; gap: 0.25rem;">
                                        <span class="material-symbols-outlined" style="font-size: 1rem;">add_shopping_cart</span>
                                        <span>Add</span>
                                    </button>
                                </form>
                            <% } else { %>
                                <button class="btn btn-secondary btn-pill" disabled style="padding: 0.45rem 1rem; font-size: 0.85rem; opacity: 0.6; cursor: not-allowed;">
                                    <span>Unavailable</span>
                                </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem;">
                <span class="material-symbols-outlined" style="font-size: 4rem; color: var(--color-outline); margin-bottom: 1rem;">search_off</span>
                <h3 style="margin-bottom: 0.5rem;">No products found</h3>
                <p style="color: var(--color-on-surface-variant); margin-bottom: 1.5rem;">Try adjusting your search query or selecting a different category.</p>
                <a href="<%= request.getContextPath() %>/products" class="btn btn-primary btn-pill">Clear All Filters</a>
            </div>
        <% } %>
    </div>
</main>

<%@ include file="/includes/footer.jspf" %>

</body>
</html>
