<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%@ page import="com.praveen.praveenmart.model.Review" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%
    Product product = (Product) request.getAttribute("product");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Double avgRating = (Double) request.getAttribute("avgRating");
    Integer reviewCount = (Integer) request.getAttribute("reviewCount");

    if (avgRating == null) avgRating = 0.0;
    if (reviewCount == null) reviewCount = 0;

    double displayRating;
    int displayReviewCount;
    if (avgRating > 0.0 && reviewCount > 0) {
        displayRating = avgRating;
        displayReviewCount = reviewCount;
    } else {
        long pid = (product != null && product.getId() != null) ? product.getId() : 1L;
        displayRating = 4.3 + (pid % 7) * 0.1;
        if (displayRating > 4.9) displayRating = 4.9;
        displayReviewCount = 85 + (int)((pid * 43) % 450);
    }

    String msgSuccess = (String) session.getAttribute("msgSuccess");
    session.removeAttribute("msgSuccess");

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= product != null ? product.getName() : "Product Details" %> - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.8">
    <style>
        .details-wrapper {
            padding: 3.5rem 0 6rem;
        }

        .product-overview-grid {
            display: grid;
            grid-template-columns: 1.1fr 1fr;
            gap: 4rem;
            margin-bottom: 4.5rem;
        }

        @media (max-width: 900px) {
            .product-overview-grid {
                grid-template-columns: 1fr;
                gap: 2.5rem;
            }
        }

        .details-image-box {
            background-color: var(--surface);
            border: 1px solid var(--surface-border);
            border-radius: 16px;
            overflow: hidden;
            height: 520px;
            box-shadow: var(--shadow-md);
            position: relative;
        }

        .details-image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .details-image-box:hover img {
            transform: scale(1.03);
        }

        .details-info {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .details-price {
            font-size: 2.4rem;
            font-weight: 700;
            color: var(--price);
            margin: 1.2rem 0 1.5rem;
            letter-spacing: -0.01em;
        }

        .qty-picker {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            margin-bottom: 2rem;
        }

        .card-qty-stepper {
            display: inline-flex;
            align-items: center;
            border: 1px solid var(--surface-border);
            border-radius: var(--radius-pill);
            background: var(--pill-inactive-bg);
            overflow: hidden;
            height: 44px;
        }

        .card-qty-stepper .qty-btn {
            background: transparent;
            border: none;
            width: 40px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            font-weight: 700;
            color: #ffffff;
            cursor: pointer;
            transition: background-color 0.15s ease;
            user-select: none;
            padding: 0;
        }

        .card-qty-stepper .qty-btn:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .card-qty-stepper .qty-input-field {
            width: 44px;
            border: none;
            background: transparent;
            text-align: center;
            font-size: 1.05rem;
            font-weight: 700;
            color: #ffffff;
            -moz-appearance: textfield;
            appearance: textfield;
            padding: 0;
            pointer-events: none;
        }

        .card-qty-stepper .qty-input-field::-webkit-outer-spin-button,
        .card-qty-stepper .qty-input-field::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .reviews-section {
            background-color: var(--surface);
            border: 1px solid var(--surface-border);
            border-radius: 16px;
            padding: 2.8rem;
            box-shadow: var(--shadow-soft);
        }

        .review-card {
            padding: 1.4rem 0;
            border-bottom: 1px solid var(--divider);
        }

        .review-card:last-child {
            border-bottom: none;
        }

        .review-star {
            font-size: 1rem;
            color: #4b5563;
        }

        .review-star.filled {
            color: #FFC107;
        }
    </style>
</head>
<body>

<%@ include file="/includes/header.jspf" %>

<div class="container details-wrapper">

    <div style="margin-bottom: 2rem; font-size: 0.9rem; color: var(--color-on-surface-muted);">
        <a href="<%= request.getContextPath() %>/products" style="color: var(--color-on-surface-variant);">Collection</a> /
        <a href="<%= request.getContextPath() %>/products?category=<%= product.getCategory() %>" style="color: var(--color-on-surface-variant);"><%= product.getCategory() %></a> /
        <span style="color: #ffffff; font-weight: 600;"><%= product.getName() %></span>
    </div>

    <% if (msgSuccess != null) { %>
        <div class="alert-box alert-box-success">
            <span class="material-symbols-outlined">check_circle</span>
            <span><%= msgSuccess %></span>
        </div>
    <% } %>

    <div class="product-overview-grid">
        <div class="details-image-box">
            <% 
                String dImg = product.getImageUrl();
                if (dImg != null && !dImg.isBlank()) {
                    if (!dImg.startsWith("http://") && !dImg.startsWith("https://")) {
                        if (!dImg.startsWith("/")) {
                            dImg = "/" + dImg;
                        }
                        dImg = request.getContextPath() + dImg;
                    }
            %>
                <img src="<%= dImg %>" alt="<%= product.getName() %>" onerror="this.src='https://images.unsplash.com/photo-1544816155-12df9643f363?w=800&auto=format&fit=crop&q=80'">
            <% } else { %>
                <img src="https://images.unsplash.com/photo-1544816155-12df9643f363?w=800&auto=format&fit=crop&q=80" alt="Product Image">
            <% } %>
        </div>

        <div class="details-info">
            <div style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; margin-bottom: 0.8rem;">
                <span class="badge-tag badge-primary"><%= product.getCategory() %></span>
                <% if (product.getStockQty() > 10) { %>
                    <span class="badge-tag badge-in-stock">In Stock (<%= product.getStockQty() %> Available)</span>
                <% } else if (product.getStockQty() > 0) { %>
                    <span class="badge-tag badge-low-stock">Low Stock (Only <%= product.getStockQty() %> Left)</span>
                <% } else { %>
                    <span class="badge-tag badge-out-stock">Sold Out</span>
                <% } %>
            </div>

            <h1 style="font-size: clamp(2rem, 3.5vw, 2.8rem); font-weight: 800; text-transform: uppercase; margin-bottom: 0.6rem; line-height: 1.15;">
                <%= product.getName() %>
            </h1>

            <div style="display: flex; align-items: center; gap: 0.6rem; margin-bottom: 1.2rem;">
                <span style="background-color: rgba(255,255,255,0.08); color: #ffffff; font-size: 0.82rem; font-weight: 700; padding: 0.2rem 0.6rem; border-radius: 6px; display: inline-flex; align-items: center; gap: 0.25rem; border: 1px solid rgba(255,255,255,0.12);">
                    <%= String.format(Locale.US, "%.1f", displayRating) %> <span style="color: #FFC107;">★</span>
                </span>
                <span style="color: var(--color-on-surface-variant); font-size: 0.9rem;">(<%= displayReviewCount %> reviews)</span>
                <% if (product.getSellerName() != null) { %>
                    <span style="color: var(--color-outline-variant);">•</span>
                    <span style="font-size: 0.88rem; color: var(--color-on-surface-variant);">Crafted by: <strong><%= product.getSellerName() %></strong></span>
                <% } %>
            </div>

            <div class="details-price">
                <%= currencyFormat.format(product.getPrice()) %>
            </div>

            <p style="font-size: 1.05rem; color: var(--color-on-surface-variant); line-height: 1.7; margin-bottom: 2.2rem;">
                <%= product.getDescription() != null ? product.getDescription() : "High-grade handcrafted item designed for modern spaces." %>
            </p>

            <% if (product.getStockQty() > 0) { %>
                <form action="<%= request.getContextPath() %>/cart/add" method="post" class="add-to-cart-form">
                    <input type="hidden" name="productId" value="<%= product.getId() %>">

                    <div class="qty-picker">
                        <label class="form-label" style="margin-bottom: 0; font-weight: 700;" for="quantity">Quantity:</label>
                        <div class="card-qty-stepper">
                            <button type="button" class="qty-btn qty-btn-minus" aria-label="Decrease quantity">−</button>
                            <input type="number" id="quantity" name="quantity" class="qty-input-field" value="1" min="1" max="<%= product.getStockQty() %>" readonly>
                            <button type="button" class="qty-btn qty-btn-plus" aria-label="Increase quantity">+</button>
                        </div>
                    </div>

                    <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                        <button type="submit" class="btn btn-primary btn-pill btn-add-cart" style="padding: 0.95rem 2.5rem; font-size: 1rem; flex: 1;">
                            <span class="material-symbols-outlined">shopping_bag</span>
                            <span>Add to Cart</span>
                        </button>
                    </div>
                </form>
            <% } else { %>
                <button class="btn btn-secondary btn-pill" disabled style="padding: 0.95rem 2rem; font-size: 1rem; opacity: 0.5; cursor: not-allowed;">
                    <span>Sold Out</span>
                </button>
            <% } %>
        </div>
    </div>

    <section class="reviews-section">
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 2.5rem; flex-wrap: wrap; gap: 1rem;">
            <div>
                <h3 style="font-size: 1.6rem; text-transform: uppercase; margin-bottom: 0.3rem;">Customer Reviews</h3>
                <p style="color: var(--text); font-size: 0.92rem;">
                    Average rating: <strong><%= String.format(Locale.US, "%.1f", displayRating) %>/5</strong> based on <%= displayReviewCount %> buyer reviews.
                </p>
            </div>
        </div>

        <% if (sessionUser != null) { %>
            <div style="background-color: var(--pill-inactive-bg); border: 1px solid var(--surface-border); border-radius: 12px; padding: 1.75rem; margin-bottom: 2.5rem;">
                <h4 style="margin-bottom: 1.2rem; font-size: 1.1rem; text-transform: uppercase;">Write a Review</h4>
                <form action="<%= request.getContextPath() %>/reviews/add" method="post">
                    <input type="hidden" name="productId" value="<%= product.getId() %>">

                    <div style="margin-bottom: 1rem;">
                        <label class="form-label" for="rating" style="color: var(--text); font-size: 0.88rem; margin-bottom: 0.4rem; display: block;">Rating (1 to 5 Stars)</label>
                        <select name="rating" id="rating" class="form-input-field" style="background: var(--bg); border: 1px solid var(--surface-border); border-radius: 10px; padding: 0.65rem 1rem; color: #ffffff;" required>
                            <option value="5">★★★★★ - Excellent (5 Stars)</option>
                            <option value="4">★★★★☆ - Very Good (4 Stars)</option>
                            <option value="3">★★★☆☆ - Average (3 Stars)</option>
                            <option value="2">★★☆☆☆ - Below Expectations (2 Stars)</option>
                            <option value="1">★☆☆☆☆ - Poor (1 Star)</option>
                        </select>
                    </div>

                    <div style="margin-bottom: 1.2rem;">
                        <label class="form-label" for="comment" style="color: var(--text); font-size: 0.88rem; margin-bottom: 0.4rem; display: block;">Your Feedback</label>
                        <textarea name="comment" id="comment" rows="3" class="form-input-field" style="background: var(--bg); border: 1px solid var(--surface-border); border-radius: 10px; padding: 0.8rem; width: 100%; color: #ffffff; resize: vertical;" placeholder="Share your experience with this product..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-pill" style="padding: 0.65rem 1.6rem;">
                        <span>Submit Review</span>
                    </button>
                </form>
            </div>
        <% } else { %>
            <p style="font-size: 0.92rem; color: var(--text); margin-bottom: 2rem;">
                <a href="<%= request.getContextPath() %>/login.jsp" style="font-weight: 500; color: var(--btn-bg); text-decoration: underline;">Sign in</a> to leave a review.
            </p>
        <% } %>

        <% if (reviews != null && !reviews.isEmpty()) { %>
            <% for (Review r : reviews) { %>
                <div class="review-card">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 0.4rem;">
                        <span style="font-weight: 600; color: #ffffff;"><%= r.getUserName() != null ? r.getUserName() : "Verified Customer" %></span>
                        <span style="font-size: 0.82rem; color: var(--muted);"><%= r.getCreatedAt() != null ? r.getCreatedAt().toLocalDate() : "" %></span>
                    </div>
                    <div style="margin-bottom: 0.5rem; display: flex; gap: 2px;">
                        <% for (int i = 1; i <= 5; i++) { %>
                            <span class="material-symbols-outlined review-star <%= i <= r.getRating() ? "filled" : "" %>">star</span>
                        <% } %>
                    </div>
                    <p style="font-size: 0.92rem; color: var(--text); line-height: 1.6;"><%= r.getComment() %></p>
                </div>
            <% } %>
        <% } else { %>
            <p style="color: var(--muted); font-size: 0.95rem; font-style: italic;">No reviews yet for this product. Be the first to review!</p>
        <% } %>
    </section>
</div>

<%@ include file="/includes/footer.jspf" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const minusBtn = document.querySelector('.qty-btn-minus');
        const plusBtn = document.querySelector('.qty-btn-plus');
        const input = document.getElementById('quantity');

        if (!minusBtn || !plusBtn || !input) return;

        minusBtn.addEventListener('click', function(e) {
            e.preventDefault();
            let currentVal = parseInt(input.value) || 1;
            let min = parseInt(input.getAttribute('min')) || 1;
            if (currentVal > min) {
                input.value = currentVal - 1;
            }
        });

        plusBtn.addEventListener('click', function(e) {
            e.preventDefault();
            let currentVal = parseInt(input.value) || 1;
            let max = parseInt(input.getAttribute('max')) || 999;
            if (currentVal < max) {
                input.value = currentVal + 1;
            }
        });
    });
</script>

</body>
</html>
