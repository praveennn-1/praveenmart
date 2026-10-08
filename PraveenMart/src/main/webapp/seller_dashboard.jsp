<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.praveen.praveenmart.model.User" %>
<%@ page import="com.praveen.praveenmart.model.Product" %>
<%@ page import="com.praveen.praveenmart.model.OrderItem" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    List<OrderItem> incomingOrders = (List<OrderItem>) request.getAttribute("incomingOrders");
    Integer totalProducts = (Integer) request.getAttribute("totalProducts");
    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");

    if (totalProducts == null) totalProducts = (products != null) ? products.size() : 0;
    if (totalOrders == null) totalOrders = (incomingOrders != null) ? incomingOrders.size() : 0;
    if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;

    String msgSuccess = (String) session.getAttribute("msgSuccess");
    String msgError = (String) session.getAttribute("msgError");
    if (msgSuccess != null) session.removeAttribute("msgSuccess");
    if (msgError != null) session.removeAttribute("msgError");

    int totalStock = 0;
    if (products != null) {
        for (Product p : products) {
            totalStock += p.getStockQty();
        }
    }

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Hub - PraveenMart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css?v=5.6">
    <style>
        body {
            background-color: #000000;
        }

        .seller-main {
            padding: 3rem 0 5rem 0;
        }

        .seller-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 2.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 1.5rem;
        }

        .stat-label {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.75rem;
            font-weight: 600;
            color: #71717A;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 0.4rem;
        }

        .stat-val {
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 1.8rem;
            font-weight: 700;
            color: #FFFFFF;
        }

        /* Tabs */
        .hub-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 2rem;
            border-bottom: 1px solid #1E1E22;
            padding-bottom: 0.75rem;
            flex-wrap: wrap;
        }

        .hub-tab-btn {
            background: #000000;
            border: 1px solid #27272A;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.82rem;
            font-weight: 500;
            padding: 0.5rem 1.1rem;
            color: #A1A1AA;
            cursor: pointer;
            border-radius: 4px;
            transition: all 150ms ease;
        }

        .hub-tab-btn:hover {
            border-color: #3F3F46;
            color: #FFFFFF;
        }

        .hub-tab-btn.active {
            background: #FFFFFF !important;
            color: #000000 !important;
            border-color: #FFFFFF !important;
            font-weight: 600;
        }

        .seller-card {
            background-color: #050505;
            border: 1px solid #222222;
            border-radius: 6px;
            padding: 1.75rem;
            margin-bottom: 2.5rem;
        }

        .card-heading {
            font-family: var(--font-heading, 'Inter', sans-serif);
            font-size: 1.2rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: #FFFFFF;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.25rem;
        }

        .form-col-full {
            grid-column: 1 / -1;
        }

        .input-box,
        input.input-box,
        select.input-box,
        textarea.input-box,
        input[type="text"].input-box,
        input[type="number"].input-box,
        input[type="url"].input-box {
            width: 100%;
            height: 42px;
            box-sizing: border-box;
            padding: 0 0.85rem;
            border-radius: 4px;
            border: 1px solid #27272A;
            background-color: #000000;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.88rem;
            color: #FFFFFF;
            outline: none;
            transition: border-color 150ms ease;
        }

        .input-box:focus,
        input.input-box:focus,
        select.input-box:focus,
        textarea.input-box:focus,
        input[type="text"].input-box:focus,
        input[type="number"].input-box:focus,
        input[type="url"].input-box:focus {
            border-color: #FFFFFF;
            background-color: #0A0A0A;
        }

        select.input-box option {
            background-color: #000000;
            color: #FFFFFF;
        }

        .input-box::placeholder {
            color: #52525B;
        }

        textarea.input-box {
            resize: vertical;
            min-height: 80px;
            height: auto;
            padding: 0.75rem 0.85rem;
        }

        /* Table */
        .table-wrap {
            overflow-x: auto;
            background-color: #050505;
            border-radius: 6px;
            border: 1px solid #222222;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.88rem;
        }

        th {
            background-color: #0A0A0A;
            color: #71717A;
            font-family: var(--font-mono, 'JetBrains Mono', monospace);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            padding: 0.95rem 1.15rem;
            border-bottom: 1px solid #1E1E22;
        }

        td {
            padding: 0.95rem 1.15rem;
            border-bottom: 1px solid #1E1E22;
            vertical-align: middle;
            color: #E4E4E7;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: #0A0A0A;
        }

        .tbl-prod-img {
            width: 44px;
            height: 44px;
            border-radius: 4px;
            object-fit: cover;
            background-color: #000000;
            border: 1px solid #27272A;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background-color: #050505;
            border-radius: 6px;
            padding: 2rem;
            width: 100%;
            max-width: 600px;
            border: 1px solid #222222;
            max-height: 90vh;
            overflow-y: auto;
            color: #FFFFFF;
        }
    </style>
</head>
<body>

    <%@ include file="/includes/header.jspf" %>

    <main class="container seller-main">
        <div class="seller-header">
            <div>
                <h1 class="font-headline" style="font-size: 2.2rem; margin-bottom: 0.35rem;">Seller Hub & Order Management</h1>
                <p style="color: var(--color-on-surface-variant); font-size: 0.95rem;">Manage your storefront listings, track incoming customer orders, and update fulfillment.</p>
            </div>
            <a href="<%= request.getContextPath() %>/products" class="btn btn-secondary btn-pill">
                <span class="material-symbols-outlined">storefront</span>
                <span>View Storefront</span>
            </a>
        </div>

        <% if (msgSuccess != null) { %>
            <div class="alert-box alert-box-success">
                <span class="material-symbols-outlined">check_circle</span>
                <span><%= msgSuccess %></span>
            </div>
        <% } %>
        <% if (msgError != null) { %>
            <div class="alert-box alert-box-error">
                <span class="material-symbols-outlined">warning</span>
                <span><%= msgError %></span>
            </div>
        <% } %>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Active Listings</div>
                <div class="stat-val"><%= totalProducts %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Units in Stock</div>
                <div class="stat-val"><%= totalStock %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Orders Received</div>
                <div class="stat-val"><%= totalOrders %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Revenue</div>
                <div class="stat-val" style="color: var(--color-primary); font-size: 1.8rem;">
                    <%= currencyFormat.format(totalRevenue) %>
                </div>
            </div>
        </div>

        <div class="hub-tabs">
            <button type="button" class="hub-tab-btn active" onclick="showTab('listings', this)">Product Listings (<%= totalProducts %>)</button>
            <button type="button" class="hub-tab-btn" onclick="showTab('orders', this)">Incoming Orders (<%= incomingOrders != null ? incomingOrders.size() : 0 %>)</button>
        </div>

        <div id="tab-listings">

            <div class="seller-card">
                <div class="card-heading">
                    <span class="material-symbols-outlined" style="color: var(--color-primary);">add_box</span>
                    <span>Publish New Product Listing</span>
                </div>

                <form action="<%= request.getContextPath() %>/seller/products/create" method="post">
                    <div class="form-grid">
                        <div>
                            <label class="form-label" for="name">Product Title *</label>
                            <input type="text" class="input-box" id="name" name="name" placeholder="e.g. Handcrafted Ceramic Teapot" required>
                        </div>

                        <div>
                            <label class="form-label" for="category">Category *</label>
                            <select class="input-box" id="category" name="category" required>
                                <option value="Fashion & Style">Fashion & Style</option>
                                <option value="Home & Kitchen">Home & Kitchen</option>
                                <option value="Electronics">Electronics</option>
                                <option value="Accessories">Accessories</option>
                                <option value="General">General</option>
                            </select>
                        </div>

                        <div>
                            <label class="form-label" for="price">Price (₹) *</label>
                            <input type="number" step="0.01" class="input-box" id="price" name="price" placeholder="1499.00" required min="0.01">
                        </div>

                        <div>
                            <label class="form-label" for="stock">Stock Quantity *</label>
                            <input type="number" class="input-box" id="stock" name="stock" placeholder="25" required min="0">
                        </div>

                        <div class="form-col-full">
                            <label class="form-label" for="imageUrl">Image URL (Optional)</label>
                            <input type="url" class="input-box" id="imageUrl" name="imageUrl" placeholder="https://images.unsplash.com/photo-...">
                        </div>

                        <div class="form-col-full">
                            <label class="form-label" for="description">Detailed Description</label>
                            <textarea class="input-box" id="description" name="description" placeholder="Describe materials, artisan origin, specifications..."></textarea>
                        </div>

                        <div class="form-col-full">
                            <button type="submit" class="btn btn-primary btn-pill" style="padding: 0.85rem 2rem;">
                                <span class="material-symbols-outlined">publish</span>
                                <span>Publish to Storefront</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <div class="seller-card">
                <div class="card-heading">
                    <span class="material-symbols-outlined" style="color: var(--color-primary);">inventory_2</span>
                    <span>My Storefront Catalog</span>
                </div>

                <% if (products == null || products.isEmpty()) { %>
                    <p style="color: var(--color-on-surface-variant); text-align: center; padding: 2.5rem 0;">
                        No products listed yet. Use the form above to add your first product!
                    </p>
                <% } else { %>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Product Details</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Inventory</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Product p : products) { %>
                                    <tr>
                                        <td>
                                            <% if (p.getImageUrl() != null && !p.getImageUrl().isBlank()) { %>
                                                <img src="<%= p.getImageUrl() %>" alt="<%= p.getName() %>" class="tbl-prod-img" onerror="this.src='https://via.placeholder.com/52'">
                                            <% } else { %>
                                                <img src="https://via.placeholder.com/52" alt="Placeholder" class="tbl-prod-img">
                                            <% } %>
                                        </td>
                                        <td>
                                            <div style="font-weight: 700; color: var(--color-on-surface);"><%= p.getName() %></div>
                                            <div style="font-size: 0.82rem; color: var(--color-on-surface-variant); max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                                <%= p.getDescription() != null ? p.getDescription() : "" %>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge-tag badge-primary"><%= p.getCategory() %></span>
                                        </td>
                                        <td style="font-weight: 700; font-size: 1.05rem; color: var(--color-neutral-dark);">
                                            <%= currencyFormat.format(p.getPrice()) %>
                                        </td>
                                        <td>
                                            <span class="badge-tag <%= (p.getStockQty() > 10) ? "badge-in-stock" : ((p.getStockQty() > 0) ? "badge-low-stock" : "badge-out-stock") %>">
                                                <%= p.getStockQty() %> units
                                            </span>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 0.4rem;">
                                                <button type="button" class="btn btn-secondary btn-pill" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;"
                                                        data-id="<%= p.getId() %>"
                                                        data-name="<%= p.getName().replace("\"", "&quot;") %>"
                                                        data-category="<%= p.getCategory().replace("\"", "&quot;") %>"
                                                        data-price="<%= p.getPrice() %>"
                                                        data-stock="<%= p.getStockQty() %>"
                                                        data-image="<%= p.getImageUrl() != null ? p.getImageUrl().replace("\"", "&quot;") : "" %>"
                                                        data-description="<%= p.getDescription() != null ? p.getDescription().replace("\"", "&quot;").replace("\n", " ") : "" %>"
                                                        onclick="handleEditProductClick(this)">
                                                    <span class="material-symbols-outlined" style="font-size: 1rem;">edit</span>
                                                    <span>Edit</span>
                                                </button>

                                                <form action="<%= request.getContextPath() %>/seller/products/delete" method="post" onsubmit="return confirm('Are you sure you want to delete this listing?');" style="display: inline;">
                                                    <input type="hidden" name="id" value="<%= p.getId() %>">
                                                    <button type="submit" class="btn btn-danger btn-pill" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;">
                                                        <span class="material-symbols-outlined" style="font-size: 1rem;">delete</span>
                                                        <span>Delete</span>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>

        <div id="tab-orders" style="display: none;">
            <div class="seller-card">
                <div class="card-heading">
                    <span class="material-symbols-outlined" style="color: var(--color-primary);">local_shipping</span>
                    <span>Incoming Customer Orders</span>
                </div>

                <% if (incomingOrders == null || incomingOrders.isEmpty()) { %>
                    <p style="color: var(--color-on-surface-variant); text-align: center; padding: 3rem 0;">
                        No orders received yet. As customers purchase your products, they will show up here.
                    </p>
                <% } else { %>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>Order #</th>
                                    <th>Product</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                    <th>Subtotal</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (OrderItem item : incomingOrders) { %>
                                    <tr>
                                        <td>
                                            <strong style="color: var(--color-primary);">#ORD-<%= item.getOrderId() %></strong>
                                        </td>
                                        <td>
                                            <div style="font-weight: 700; color: var(--color-on-surface);"><%= item.getProductName() %></div>
                                        </td>
                                        <td>
                                            <span style="font-weight: 600;"><%= item.getQuantity() %></span>
                                        </td>
                                        <td>
                                            <%= currencyFormat.format(item.getUnitPrice()) %>
                                        </td>
                                        <td style="font-weight: 700; color: var(--color-neutral-dark);">
                                            <%= currencyFormat.format(item.getSubtotal()) %>
                                        </td>
                                        <td>
                                            <%= item.getCreatedAt() != null ? item.getCreatedAt().toLocalDate() : "" %>
                                        </td>
                                        <td>
                                            <form action="<%= request.getContextPath() %>/seller/orders/update-status" method="post" style="display: flex; gap: 0.4rem; align-items: center;">
                                                <input type="hidden" name="orderId" value="<%= item.getOrderId() %>">
                                                <select name="status" class="form-input-field" style="padding: 0.35rem 0.6rem; font-size: 0.85rem; border: 1px solid var(--color-outline-variant); border-radius: var(--radius-sm); background: #14161f; color: #ffffff;">
                                                    <option value="CONFIRMED">Confirmed</option>
                                                    <option value="SHIPPED">Shipped</option>
                                                    <option value="DELIVERED">Delivered</option>
                                                    <option value="CANCELLED">Cancelled</option>
                                                </select>
                                                <button type="submit" class="btn btn-primary btn-pill" style="padding: 0.35rem 0.8rem; font-size: 0.8rem;">
                                                    <span>Update</span>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>

        <div id="editModal" class="modal">
            <div class="modal-content">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h3 style="font-size: 1.4rem; font-weight: 700;">Edit Product Listing</h3>
                    <button type="button" onclick="closeEditModal()" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--color-on-surface-variant);">&times;</button>
                </div>

                <form action="<%= request.getContextPath() %>/seller/products/edit" method="post">
                    <input type="hidden" id="edit-id" name="id">

                    <div style="margin-bottom: 1rem;">
                        <label class="form-label" for="edit-name">Product Title *</label>
                        <input type="text" class="input-box" id="edit-name" name="name" required>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                        <div>
                            <label class="form-label" for="edit-category">Category *</label>
                            <select class="input-box" id="edit-category" name="category" required>
                                <option value="Fashion & Style">Fashion & Style</option>
                                <option value="Home & Kitchen">Home & Kitchen</option>
                                <option value="Electronics">Electronics</option>
                                <option value="Accessories">Accessories</option>
                                <option value="General">General</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label" for="edit-price">Price (₹) *</label>
                            <input type="number" step="0.01" class="input-box" id="edit-price" name="price" required min="0.01">
                        </div>
                    </div>

                    <div style="margin-bottom: 1rem;">
                        <label class="form-label" for="edit-stock">Stock Quantity *</label>
                        <input type="number" class="input-box" id="edit-stock" name="stock" required min="0">
                    </div>

                    <div style="margin-bottom: 1rem;">
                        <label class="form-label" for="edit-imageUrl">Image URL</label>
                        <input type="url" class="input-box" id="edit-imageUrl" name="imageUrl">
                    </div>

                    <div style="margin-bottom: 1.5rem;">
                        <label class="form-label" for="edit-description">Description</label>
                        <textarea class="input-box" id="edit-description" name="description"></textarea>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 0.8rem;">
                        <button type="button" class="btn btn-secondary btn-pill" onclick="closeEditModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-pill">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>
        function showTab(tabName, btn) {
            document.getElementById('tab-listings').style.display = (tabName === 'listings') ? 'block' : 'none';
            document.getElementById('tab-orders').style.display = (tabName === 'orders') ? 'block' : 'none';
            document.querySelectorAll('.hub-tab-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
        }

        function handleEditProductClick(btn) {
            var id = btn.getAttribute('data-id');
            var name = btn.getAttribute('data-name');
            var category = btn.getAttribute('data-category');
            var price = btn.getAttribute('data-price');
            var stock = btn.getAttribute('data-stock');
            var imageUrl = btn.getAttribute('data-image');
            var description = btn.getAttribute('data-description');
            openEditModal(id, name, category, price, stock, imageUrl, description);
        }

        function openEditModal(id, name, category, price, stock, imageUrl, description) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-category').value = category;
            document.getElementById('edit-price').value = price;
            document.getElementById('edit-stock').value = stock;
            document.getElementById('edit-imageUrl').value = imageUrl;
            document.getElementById('edit-description').value = description;
            document.getElementById('editModal').classList.add('active');
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
        }
    </script>

    <%@ include file="/includes/footer.jspf" %>

</body>
</html>
