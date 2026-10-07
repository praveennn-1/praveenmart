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
    <title>PraveenMart - Premium Marketplace</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.8">
    <style>
        /* Hero & Catalog Controls (OpenCode Theme) */
        .store-hero {
            padding: 4.5rem 0 3rem;
            text-align: center;
            background: var(--hero-glow), #000000;
            border-bottom: 1px solid #1F1F1F;
        }

        .store-title {
            font-family: var(--font-heading);
            font-size: clamp(2.4rem, 5vw, 3.8rem);
            font-weight: 700;
            letter-spacing: -0.03em;
            line-height: 1.1;
            color: #FFFFFF;
            background: none;
            -webkit-text-fill-color: initial;
            max-width: 900px;
            margin: 0 auto 0.8rem;
        }

        .store-subtitle {
            font-family: var(--font-mono);
            font-size: 15px;
            color: #A1A1AA;
            letter-spacing: -0.01em;
            max-width: 650px;
            margin: 0 auto 2.5rem;
            line-height: 1.6;
        }

        /* Search Bar */
        .store-search-wrapper {
            max-width: 580px;
            margin: 0 auto 2.5rem;
        }

        .store-search-bar {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: #0C0C0C;
            border: 1px solid #27272A;
            border-radius: var(--radius-sm);
            padding: 0.35rem 0.45rem 0.35rem 1rem;
            box-shadow: var(--shadow-soft);
            transition: all 180ms ease;
        }

        .store-search-bar:focus-within {
            border-color: #FFFFFF;
            background: #050505;
            box-shadow: 0 0 0 1px #FFFFFF;
        }

        .store-search-bar input {
            flex: 1;
            background: transparent;
            border: none;
            outline: none;
            color: #FFFFFF;
            font-size: 0.9rem;
            font-family: var(--font-mono);
        }

        .store-search-bar input::placeholder {
            color: #52525B;
            opacity: 1;
        }

        /* Category Filter Pills */
        .category-pills-bar {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }

        .category-pill {
            padding: 0.45rem 1.1rem;
            border-radius: var(--radius-sm);
            font-size: 0.82rem;
            font-family: var(--font-mono);
            font-weight: 500;
            background: #0C0C0C;
            color: #A1A1AA !important;
            border: 1px solid #222222;
            text-decoration: none;
            transition: all 180ms ease;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .category-pill:hover {
            background: #18181B;
            color: #FFFFFF !important;
            border-color: #52525B;
            transform: translateY(-1px);
        }

        .category-pill.active {
            background: #FFFFFF !important;
            color: #000000 !important;
            border-color: #FFFFFF !important;
            font-weight: 700;
            box-shadow: 0 2px 10px rgba(255, 255, 255, 0.15) !important;
        }

        /* Catalog Main Grid Area */
        .catalog-container {
            padding-top: 3.5rem;
            padding-bottom: 6rem;
            width: 100%;
            overflow-x: hidden;
        }

        .catalog-container .container {
            width: 100%;
            max-width: 1360px;
            margin: 0 auto;
            padding: 0 1.25rem;
            box-sizing: border-box;
        }

        .catalog-meta-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 1.5rem;
            margin-bottom: 2.5rem;
            border-bottom: 1px solid var(--divider);
            flex-wrap: wrap;
            gap: 1rem;
        }

        .catalog-meta-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--heading);
            text-transform: uppercase;
            letter-spacing: 0.01em;
            line-height: 1.1;
        }

        .catalog-meta-count {
            font-size: 12px;
            color: var(--muted);
        }

        /* Products Grid: 4 columns strictly contained within the page width */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 1.15rem;
            width: 100%;
            box-sizing: border-box;
        }

        @media (max-width: 860px) {
            .products-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 1rem;
            }
        }

        @media (max-width: 500px) {
            .products-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
        }

        /* Product Card: OpenCode High Contrast Obsidian Theme */
        .product-card {
            position: relative;
            overflow: hidden;
            border-radius: 4px;
            padding: 0.85rem;
            display: flex;
            flex-direction: column;
            height: 480px;
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
            background: #000000 !important;
            background-color: #000000 !important;
            background-image: none !important;
            border: 1px solid #222222 !important;
            box-shadow: none !important;
            transition: transform 180ms ease,
                        border-color 180ms ease,
                        background-color 180ms ease;
            isolation: isolate;
        }

        .product-card::before,
        .product-card::after {
            display: none !important;
        }

        .product-card:hover {
            transform: translateY(-2px);
            border-color: #52525B !important;
            background: #09090B !important;
            background-color: #09090B !important;
            background-image: none !important;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.7) !important;
        }

        /* Image area */
        .product-image-box {
            height: 195px;
            width: 100%;
            background-color: #050505;
            border: 1px solid #18181B;
            position: relative;
            overflow: hidden;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-sizing: border-box;
        }

        .product-image-box a {
            display: block;
            width: 100%;
            height: 100%;
        }

        .product-image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
            display: block;
            transition: transform 0.35s ease;
        }

        .product-card:hover .product-image-box img {
            transform: scale(1.03);
        }

        .product-content {
            padding-top: 0.75rem;
            display: flex;
            flex-direction: column;
            flex: 1;
            min-height: 0;
            min-width: 0;
            box-sizing: border-box;
        }

        /* 1. Category label (left) and rating (right) */
        .card-meta-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.35rem;
            height: 26px;
            flex-shrink: 0;
            margin-bottom: 0.35rem;
            min-width: 0;
        }

        .card-category-pill {
            display: inline-flex;
            align-items: center;
            padding: 2px 7px;
            border-radius: 4px;
            background: #000000;
            border: 1px solid #27272A;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 10px;
            font-weight: 500;
            color: #A1A1AA;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            max-width: 110px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .card-rating-group {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 11px;
            font-weight: 600;
            color: #FFFFFF;
            line-height: 1;
            white-space: nowrap;
            flex-shrink: 0;
        }

        .card-rating-star {
            color: #FFFFFF;
            font-size: 0.8rem;
            line-height: 1;
        }

        .card-rating-count {
            font-size: 10px;
            color: #71717A;
            font-weight: 400;
        }

        /* 2. Title: bold, white, single-line truncated */
        .product-card-title {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 15px;
            font-weight: 600;
            color: #FFFFFF;
            height: 24px;
            line-height: 24px;
            margin-bottom: 0.25rem;
            text-decoration: none;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: block;
            flex-shrink: 0;
            min-width: 0;
            letter-spacing: -0.01em;
            transition: color 150ms ease;
        }

        .product-card-title:hover {
            color: #D4D4D8;
        }

        /* 3. Price & Delivery */
        .product-card-price {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 20px;
            font-weight: 700;
            color: #FFFFFF;
            height: 26px;
            line-height: 26px;
            letter-spacing: -0.02em;
            margin-bottom: 0.15rem;
            flex-shrink: 0;
            min-width: 0;
        }

        .product-price-meta {
            display: flex;
            align-items: center;
            gap: 0.35rem;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 10.5px;
            height: 18px;
            line-height: 18px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 0.6rem;
            flex-shrink: 0;
            min-width: 0;
        }

        .product-mrp {
            color: #71717A;
            white-space: nowrap;
        }

        .product-discount {
            color: #A1A1AA;
            font-weight: 600;
            white-space: nowrap;
        }

        .product-delivery-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.2rem;
            color: #71717A;
            font-size: 10.5px;
            font-weight: 500;
            white-space: nowrap;
        }

        /* 4. Option Selector Section (Size or Quantity) */
        .card-options-section {
            margin-bottom: 0.75rem;
            flex-shrink: 0;
            min-width: 0;
        }

        .card-options-label {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 10.5px;
            font-weight: 500;
            color: #71717A;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            height: 16px;
            line-height: 16px;
            margin-bottom: 0.35rem;
            white-space: nowrap;
        }

        .card-options-row {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            height: 34px;
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .card-option-pill {
            flex: 1;
            min-width: 0;
            height: 34px;
            padding: 0;
            border-radius: 4px;
            background-color: #000000;
            border: 1px solid #27272A;
            color: #A1A1AA;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 11px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 150ms ease;
            user-select: none;
            box-sizing: border-box;
        }

        .card-option-pill:hover {
            border-color: #3F3F46;
            background-color: #0A0A0A;
            color: #FFFFFF;
        }

        .card-option-pill.active {
            background: #FFFFFF !important;
            color: #000000 !important;
            border-color: #FFFFFF !important;
            font-weight: 700;
            box-shadow: none !important;
        }

        /* 5. Bottom Action Row: Wide Buy Now Button + Cart Icon Button */
        .card-action-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            width: 100%;
            height: 40px;
            margin-top: auto;
            flex-shrink: 0;
            min-width: 0;
            box-sizing: border-box;
        }

        .btn-card-buy-now {
            flex: 1;
            min-width: 0;
            height: 40px;
            background: #FFFFFF !important;
            color: #000000 !important;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-weight: 600;
            border-radius: 4px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            cursor: pointer;
            border: 1px solid #FFFFFF;
            transition: background 150ms ease, opacity 150ms ease;
            box-shadow: none !important;
            letter-spacing: -0.01em;
            text-decoration: none;
            white-space: nowrap;
        }

        .btn-card-buy-now:hover:not(:disabled) {
            background: #E4E4E7 !important;
            border-color: #E4E4E7 !important;
            transform: none;
            box-shadow: none !important;
        }

        .btn-card-buy-now:active:not(:disabled) {
            opacity: 0.9;
        }

        .btn-card-cart-icon {
            width: 40px;
            height: 40px;
            background: #000000 !important;
            color: #FFFFFF !important;
            border-radius: 4px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 1px solid #27272A;
            transition: background 150ms ease, border-color 150ms ease;
            box-shadow: none !important;
            flex-shrink: 0;
            padding: 0;
        }

        .btn-card-cart-icon:hover:not(:disabled) {
            background: #111111 !important;
            border-color: #3F3F46 !important;
            color: #FFFFFF !important;
            transform: none;
            box-shadow: none !important;
        }

        .btn-card-cart-icon:active:not(:disabled) {
            opacity: 0.9;
        }

        .btn-card-cart-icon .material-symbols-outlined {
            font-size: 1.15rem;
        }

        /* Floating Toast for AJAX feedback */
        .cart-toast {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: #09090B;
            border: 1px solid #27272A;
            color: #FFFFFF;
            padding: 0.75rem 1.25rem;
            border-radius: 4px;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.8);
            z-index: 9999;
            transform: translateY(100px);
            opacity: 0;
            transition: transform 300ms cubic-bezier(0.16, 1, 0.3, 1), opacity 300ms ease;
            pointer-events: none;
        }

        .cart-toast.show {
            transform: translateY(0);
            opacity: 1;
            pointer-events: auto;
        }

        @keyframes badgePulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.35); }
            100% { transform: scale(1); }
        }

        .badge-bounce {
            animation: badgePulse 350ms ease-out;
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<section class="store-hero">
    <div class="container">
        <h1 class="store-title">
            EXPLORE OUR COLLECTION
        </h1>
        <p class="store-subtitle">
            Discover quality electronics, fashion essentials, home appliances, and lifestyle accessories designed for modern living.
        </p>

        <div class="store-search-wrapper">
            <form action="<%= request.getContextPath() %>/products" method="get" class="store-search-bar">
                <span class="material-symbols-outlined" style="color: var(--color-on-surface-muted);">search</span>
                <input type="text" name="q" placeholder="Search products, brands, categories..." value="<%= searchQuery %>" autocomplete="off">
                <% if (!"all".equalsIgnoreCase(selectedCategory)) { %>
                    <input type="hidden" name="category" value="<%= selectedCategory %>">
                <% } %>
                <button type="submit" class="btn btn-primary" style="padding: 0.45rem 1.15rem; font-size: 0.82rem; border-radius: 4px;">
                    <span>Find</span>
                </button>
            </form>
        </div>

        <div class="category-pills-bar">
            <a href="<%= request.getContextPath() %>/products<%= !searchQuery.isEmpty() ? "?q=" + searchQuery : "" %>"
               class="category-pill <%= "all".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                <span>All Products</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Electronics<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= "Electronics".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                <span>Electronics</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Fashion%20%26%20Style<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= selectedCategory != null && (selectedCategory.toLowerCase().contains("fashion") || selectedCategory.toLowerCase().contains("style")) ? "active" : "" %>">
                <span>Fashion & Style</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Home%20%26%20Kitchen<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= selectedCategory != null && (selectedCategory.toLowerCase().contains("home") || selectedCategory.toLowerCase().contains("kitchen")) ? "active" : "" %>">
                <span>Home & Kitchen</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Accessories<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= "Accessories".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                <span>Accessories</span>
            </a>

            <a href="<%= request.getContextPath() %>/products?category=Books<%= !searchQuery.isEmpty() ? "&q=" + searchQuery : "" %>"
               class="category-pill <%= "Books".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                <span>Books</span>
            </a>
        </div>
    </div>
</section>

<main class="catalog-container">
    <div class="container">
        <% if (cartMessage != null) { %>
            <div class="alert-box alert-box-success" style="margin-bottom: 2rem;">
                <span class="material-symbols-outlined">check_circle</span>
                <span><%= cartMessage %></span>
            </div>
        <% } %>

        <% if (cartError != null) { %>
            <div class="alert-box alert-box-error" style="margin-bottom: 2rem;">
                <span class="material-symbols-outlined">warning</span>
                <span><%= cartError %></span>
            </div>
        <% } %>

        <div class="catalog-meta-bar">
            <div class="catalog-meta-title">
                <% if (!"all".equalsIgnoreCase(selectedCategory)) { %>
                    <span><%= selectedCategory %></span>
                <% } else if (!searchQuery.isEmpty()) { %>
                    <span>Search results for "<%= searchQuery %>"</span>
                <% } else { %>
                    <span>Featured Catalog</span>
                <% } %>
            </div>
            <div class="catalog-meta-count">
                Showing <%= products != null ? products.size() : 0 %> items
            </div>
        </div>

        <div class="products-grid">
            <% if (products != null && !products.isEmpty()) { %>
                <% for (Product p : products) { 
                    long pid = (p.getId() != null) ? p.getId() : 1L;
                    double ratingVal = 4.3 + (pid % 7) * 0.1;
                    if (ratingVal > 4.9) ratingVal = 4.9;
                    int reviewCount = 85 + (int)((pid * 43) % 450);
                    int discountPct = 18 + (int)((pid * 9) % 23);
                    BigDecimal currentPrice = (p.getPrice() != null) ? p.getPrice() : BigDecimal.ZERO;
                    BigDecimal mrpPrice = currentPrice.multiply(BigDecimal.valueOf(100 + discountPct)).divide(BigDecimal.valueOf(100), 0, java.math.RoundingMode.HALF_UP);
                %>
                    <div class="product-card">
                        <div class="product-image-box">
                            <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>" style="display: block; width: 100%; height: 100%;">
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
                                    <img src="<%= pImg %>" alt="<%= p.getName() %>" loading="lazy" onerror="this.onerror=null;this.src='data:image/svg+xml;charset=UTF-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22600%22%20height%3D%22600%22%20viewBox%3D%220%200%20600%20600%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23080808%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20fill%3D%22%2371717A%22%20font-family%3D%22monospace%22%20font-size%3D%2218%22%20text-anchor%3D%22middle%22%20dominant-baseline%3D%22middle%22%3E%5B%20IMAGE%20UNAVAILABLE%20%5D%3C%2Ftext%3E%3C%2Fsvg%3E'">
                                <% } else { %>
                                    <img src="data:image/svg+xml;charset=UTF-8,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22600%22%20height%3D%22600%22%20viewBox%3D%220%200%20600%20600%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23080808%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20fill%3D%22%2371717A%22%20font-family%3D%22monospace%22%20font-size%3D%2218%22%20text-anchor%3D%22middle%22%20dominant-baseline%3D%22middle%22%3E%5B%20IMAGE%20UNAVAILABLE%20%5D%3C%2Ftext%3E%3C%2Fsvg%3E" alt="Product Image">
                                <% } %>
                            </a>

                            <div style="position: absolute; top: 10px; right: 10px; z-index: 5;">
                                <% if (p.getStockQty() > 10) { %>
                                    <span class="badge-tag" style="padding: 2px 8px; font-family: var(--font-mono); font-size: 0.68rem; font-weight: 600; border-radius: 4px; background: #000000; border: 1px solid #27272A; color: #FFFFFF; display: inline-flex; align-items: center; gap: 4px;"><span style="width: 4px; height: 4px; border-radius: 50%; background: #22C55E; flex-shrink: 0;"></span>In Stock</span>
                                <% } else if (p.getStockQty() > 0) { %>
                                    <span class="badge-tag" style="padding: 2px 8px; font-family: var(--font-mono); font-size: 0.68rem; font-weight: 600; border-radius: 4px; background: #000000; border: 1px solid #27272A; color: #F59E0B; display: inline-flex; align-items: center; gap: 4px;"><span style="width: 4px; height: 4px; border-radius: 50%; background: #F59E0B; flex-shrink: 0;"></span>Low Stock (<%= p.getStockQty() %>)</span>
                                <% } else { %>
                                    <span class="badge-tag" style="padding: 2px 8px; font-family: var(--font-mono); font-size: 0.68rem; font-weight: 600; border-radius: 4px; background: #000000; border: 1px solid #27272A; color: #71717A; display: inline-flex; align-items: center; gap: 4px;">Sold Out</span>
                                <% } %>
                            </div>
                        </div>

                        <div class="product-content">
                            <div class="card-meta-row">
                                <span class="card-category-pill"><%= p.getCategory() != null ? p.getCategory() : "General" %></span>
                                <div class="card-rating-group">
                                    <span class="card-rating-star">★</span>
                                    <span><%= String.format(Locale.US, "%.2f", ratingVal) %></span>
                                    <span class="card-rating-count">(<%= reviewCount %>)</span>
                                </div>
                            </div>

                            <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>" class="product-card-title" title="<%= p.getName() %>">
                                <%= p.getName() %>
                            </a>

                            <div class="product-card-price">
                                ₹ <%= String.format(Locale.US, "%,.0f", currentPrice) %>
                            </div>

                            <div class="product-price-meta">
                                <span class="product-mrp">M.R.P.: <span style="text-decoration: line-through;">₹<%= String.format(Locale.US, "%,.0f", mrpPrice) %></span></span>
                                <span class="product-discount"><%= discountPct %>% OFF</span>
                                <span class="product-delivery-badge">
                                    <span class="material-symbols-outlined" style="font-size: 0.95rem;">local_shipping</span>
                                    FREE Delivery
                                </span>
                            </div>

                            <%
                                String cat = (p.getCategory() != null) ? p.getCategory().toLowerCase() : "";
                                String pName = (p.getName() != null) ? p.getName().toLowerCase() : "";
                                boolean isFootwear = cat.contains("shoe") || cat.contains("sneaker") || cat.contains("footwear") || cat.contains("sandal") || pName.contains("sandal") || pName.contains("loafer") || pName.contains("sneaker") || pName.contains("shoe");
                                boolean isClothing = (cat.contains("fashion") || cat.contains("style") || cat.contains("apparel") || cat.contains("cloth") || cat.contains("wear"))
                                        && !isFootwear && !pName.contains("cap") && !pName.contains("hat") && !pName.contains("belt") && !pName.contains("wallet") && !pName.contains("bag") && !pName.contains("purse") && !pName.contains("watch");
                                String optLabel = (isFootwear || isClothing) ? "What is your size ?" : "Select Quantity :";
                                String[] options;
                                int defaultIdx;
                                if (isFootwear) {
                                    options = new String[]{"39", "40", "41", "42"};
                                    defaultIdx = 1; // 40 selected by default
                                } else if (isClothing) {
                                    options = new String[]{"S", "M", "L", "XL"};
                                    defaultIdx = 1; // M selected
                                } else {
                                    options = new String[]{"1", "2", "3", "4"};
                                    defaultIdx = 0; // 1 selected
                                }
                            %>
                            <div class="card-options-section">
                                <div class="card-options-label"><%= optLabel %></div>
                                <div class="card-options-row">
                                    <% for (int oi = 0; oi < options.length; oi++) { 
                                        String opt = options[oi];
                                        boolean isActive = (oi == defaultIdx);
                                    %>
                                        <button type="button" class="card-option-pill <%= isActive ? "active" : "" %>" data-val="<%= opt %>">
                                            <%= opt %>
                                        </button>
                                    <% } %>
                                </div>
                            </div>

                            <% if (p.getStockQty() > 0) { %>
                                <form action="<%= request.getContextPath() %>/cart/add" method="post" class="card-action-row product-card-form"
                                      data-product-id="<%= p.getId() %>"
                                      data-product-name="<%= p.getName().replace("\"", "&quot;") %>"
                                      data-product-price="₹<%= String.format(Locale.US, "%,.0f", currentPrice) %>">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <input type="hidden" name="quantity" class="card-hidden-qty" value="<%= (isFootwear || isClothing) ? "1" : options[defaultIdx] %>">
                                    <input type="hidden" name="size" class="card-hidden-size" value="<%= (isFootwear || isClothing) ? options[defaultIdx] : "" %>">
                                    <input type="hidden" name="buyNow" class="card-buynow-flag" value="false">

                                    <button type="submit" class="btn-card-buy-now btn-buy-now">
                                        Buy Now
                                    </button>

                                    <button type="button" class="btn-card-cart-icon btn-add-cart-ajax" aria-label="Add to Cart" title="Add to Cart">
                                        <span class="material-symbols-outlined">shopping_cart</span>
                                    </button>
                                </form>
                            <% } else { %>
                                <div class="card-action-row">
                                    <button type="button" class="btn-card-buy-now" disabled style="opacity: 0.5; cursor: not-allowed; background: var(--pill-inactive-bg); color: var(--muted) !important;">
                                        Sold Out
                                    </button>
                                    <button type="button" class="btn-card-cart-icon" disabled style="opacity: 0.5; cursor: not-allowed; background: var(--pill-inactive-bg); color: var(--muted) !important;">
                                        <span class="material-symbols-outlined">shopping_cart</span>
                                    </button>
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem;">
                    <span class="material-symbols-outlined" style="font-size: 4rem; color: var(--color-on-surface-muted); margin-bottom: 1rem;">search_off</span>
                    <h3 style="margin-bottom: 0.5rem; color: #ffffff;">No products found</h3>
                    <p style="color: var(--color-on-surface-variant); margin-bottom: 1.5rem;">Try adjusting your search query or selecting a different category pill.</p>
                    <a href="<%= request.getContextPath() %>/products" class="btn btn-primary" style="border-radius: 4px;">Clear All Filters</a>
                </div>
            <% } %>
        </div>
    </div>
</main>

<div id="cartToast" class="cart-toast" role="status" aria-live="polite">
    <span class="material-symbols-outlined" style="color: #2ED8A3; font-size: 1.35rem;">check_circle</span>
    <span id="cartToastMsg">Product added to cart!</span>
</div>

<%@ include file="/includes/footer.jspf" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const toastEl = document.getElementById('cartToast');
        const toastMsgEl = document.getElementById('cartToastMsg');
        let toastTimeout = null;

        function showToast(message) {
            if (!toastEl || !toastMsgEl) return;
            toastMsgEl.textContent = message;
            toastEl.classList.add('show');
            if (toastTimeout) clearTimeout(toastTimeout);
            toastTimeout = setTimeout(function() {
                toastEl.classList.remove('show');
            }, 3000);
        }

        // Option Pills selection (Size / Quantity)
        document.querySelectorAll('.card-options-row').forEach(function(row) {
            const pills = row.querySelectorAll('.card-option-pill');
            const card = row.closest('.product-card');
            const form = card ? card.querySelector('.product-card-form') : null;
            if (!form) return;

            const qtyInput = form.querySelector('.card-hidden-qty');
            const sizeInput = form.querySelector('.card-hidden-size');
            const labelEl = row.closest('.card-options-section').querySelector('.card-options-label');
            const isSizeOption = labelEl && labelEl.textContent.toLowerCase().includes('size');

            pills.forEach(function(pill) {
                pill.addEventListener('click', function(e) {
                    e.preventDefault();
                    pills.forEach(p => p.classList.remove('active'));
                    pill.classList.add('active');
                    const selectedVal = pill.getAttribute('data-val');

                    if (isSizeOption) {
                        if (sizeInput) sizeInput.value = selectedVal;
                        if (qtyInput) qtyInput.value = '1';
                    } else {
                        if (qtyInput) qtyInput.value = selectedVal;
                    }
                });
            });
        });

        // "Buy Now" handler: sets buyNow=true and submits form → CartServlet redirects to /checkout
        document.querySelectorAll('.btn-buy-now').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const form = btn.closest('form');
                if (!form) return;
                const buyNowInput = form.querySelector('.card-buynow-flag');
                if (buyNowInput) {
                    buyNowInput.value = 'true';
                }
                form.submit();
            });
        });

        // "Cart Icon" AJAX Add to Cart handler
        document.querySelectorAll('.btn-add-cart-ajax').forEach(function(cartBtn) {
            cartBtn.addEventListener('click', function(e) {
                e.preventDefault();
                const form = cartBtn.closest('form');
                if (!form) return;

                const productId = form.querySelector('input[name="productId"]').value;
                const quantity = form.querySelector('.card-hidden-qty').value || '1';
                const size = form.querySelector('.card-hidden-size') ? form.querySelector('.card-hidden-size').value : '';
                const productName = form.getAttribute('data-product-name') || 'Item';

                const params = new URLSearchParams();
                params.append('productId', productId);
                params.append('quantity', quantity);
                if (size) params.append('size', size);
                params.append('ajax', 'true');

                // Animate button feedback
                const icon = cartBtn.querySelector('.material-symbols-outlined');
                const origIconText = icon ? icon.textContent : 'shopping_cart';

                fetch('<%= request.getContextPath() %>/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                    },
                    body: params.toString()
                })
                .then(function(res) {
                    if (res.status === 401) {
                        // User not logged in, redirect to login page
                        window.location.href = '<%= request.getContextPath() %>/login.jsp';
                        return null;
                    }
                    return res.json();
                })
                .then(function(data) {
                    if (!data) return;

                    if (data.redirect) {
                        window.location.href = data.redirect;
                        return;
                    }

                    if (data.success) {
                        // Update cart badge in navbar
                        const badge = document.getElementById('navCartBadge');
                        if (badge && data.itemCount !== undefined) {
                            badge.textContent = data.itemCount;
                            badge.style.display = data.itemCount > 0 ? 'inline-flex' : 'none';
                            badge.classList.remove('badge-bounce');
                            void badge.offsetWidth; // trigger reflow
                            badge.classList.add('badge-bounce');
                        }

                        // Button icon temporary checkmark
                        if (icon) {
                            icon.textContent = 'done';
                            setTimeout(function() {
                                icon.textContent = origIconText;
                            }, 1200);
                        }

                        showToast('Added ' + productName + ' to your cart');
                    } else {
                        showToast(data.message || 'Could not add item to cart');
                    }
                })
                .catch(function(err) {
                    console.error('Cart add error:', err);
                    // Fallback to normal form submit if fetch fails
                    form.submit();
                });
            });
        });
    });
</script>

</body>
</html>
