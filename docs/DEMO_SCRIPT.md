# PraveenMart — Rehearsed Live Demonstration Script

**Duration:** 5 – 7 Minutes  
**Target Audience:** Faculty Review Committee / Technical Evaluators  
**Prerequisites:** Application running at [http://localhost:8083/](http://localhost:8083/) (or live cloud URL).

---

## Part 1: Introduction & Architecture Overview (Minute 0:00 – 1:00)

### Spoken Script:
> *"Good morning respected evaluators. Today I am presenting PraveenMart, an enterprise-grade multi-seller e-commerce marketplace built strictly on core Java Web technologies: Java Servlets 4.0, JDBC, Apache Tomcat, and H2 database.*
>
> *Our goal was to construct a robust, production-ready system with role-based access control for Buyers, Sellers, and Administrators, without relying on heavyweight frameworks like Spring or Hibernate. PraveenMart rigorously implements the Front Controller, Layered MVC, DAO, Factory, Strategy, and Builder design patterns."*

### Screen Action:
1. Open browser to `http://localhost:8083/products`.
2. Briefly point out the clean, dark-themed responsive UI, category pills, search bar, and the floating "Ask AI" Shopping Assistant button at the bottom right.

---

## Part 2: Buyer Journey — Discovery, Cart & Wishlist (Minute 1:00 – 2:30)

### Spoken Script:
> *"Let's explore the platform from the perspective of a shopper. PraveenMart allows buyers to browse categorized collections, search by keyword, save items to their wishlist, and purchase using a multi-item cart."*

### Screen Action:
1. Click on the **"Fashion"** or **"Electronics"** category filter to show instant filtering.
2. Type `"Webcam"` or `"T-Shirt"` into the search bar and press Enter.
3. Click on a product card to open **Product Details** (`/product-details?id=...`).
4. Show the stock status tag, seller information, and star ratings.
5. Click **"Save to Wishlist (Requirement O1)"**:
   - The user is redirected to login if unauthenticated (`login.jsp`).
   - Sign in as Buyer: `buyer@test.com` / `password`.
   - The user is redirected back and the item is saved to the Wishlist.
6. Open **"My Wishlist"** from the top header navigation (`/wishlist`):
   - Show the saved item.
   - Click **"Move to Cart"** — the item moves from wishlist into the active shopping cart!
7. Open **"Shopping Cart"** (`/cart`):
   - Show the items, stepper controls (+ / -), and live subtotal calculations.
   - Point out the orange **"Save for Later"** button which moves any cart item back to the wishlist.

---

## Part 3: Mock Checkout & Stock Deduction (Minute 2:30 – 3:30)

### Spoken Script:
> *"Next, we'll proceed through checkout. Section 1 specifies mock payment confirmation without third-party gateways. PraveenMart uses the Strategy pattern to support Cash on Delivery, UPI, and Cards, executing the stock deduction and order creation within an atomic database transaction."*

### Screen Action:
1. In the cart, click **"Proceed to Checkout"** (`/checkout`).
2. Enter delivery address: `"124 Anna Salai, Chennai, TN"`.
3. Select payment method: **"Cash on Delivery"** (or UPI / Card).
4. Click **"Place Order with Mock Confirmation"**.
5. Observe redirection to **Order Confirmation** (`/order_success.jsp?orderId=...`).
6. Navigate to **"My Orders"** (`/orders`) to see the confirmed order, timestamps, and current status: `CONFIRMED`.

---

## Part 4: Seller Hub & Order Fulfillment (Minute 3:30 – 4:30)

### Spoken Script:
> *"Now let's switch to a merchant account. Sellers have their own dedicated dashboard to manage products, adjust inventory, view analytics, and fulfill incoming orders."*

### Screen Action:
1. Click **"Sign Out"**, then log in as Seller: `seller@test.com` / `password`.
2. Notice immediate redirect to **Seller Dashboard** (`/seller/dashboard`).
3. Point out the Seller Sales Dashboard metrics (Requirement O3):
   - Total Listed Products
   - Incoming Orders Count
   - Total Seller Revenue
4. Show **"Create New Listing"**: Enter a sample product and save.
5. Under **"Incoming Orders"**, locate the order just placed by the buyer:
   - Click the status dropdown (Requirement O2: Order Status Workflow).
   - Advance status: `CONFIRMED` ➔ `SHIPPED` ➔ `DELIVERED`.

---

## Part 5: Platform Administration (Minute 4:30 – 5:15)

### Spoken Script:
> *"Platform governance is handled by the Administrator. Access to `/admin/*` is strictly restricted via AuthFilter to the pre-seeded admin account."*

### Screen Action:
1. Sign out, and log in as Admin: `admin@praveenmart.com` / `admin123`.
2. Notice redirect to **Admin Dashboard** (`/admin/dashboard`).
3. Review total platform metrics:
   - Total registered users (Buyers vs. Sellers)
   - Total marketplace revenue
   - Total active orders
4. Demonstrate listing moderation: delete/remove a test listing.

---

## Part 6: AI Shopping Assistant & Health Observability (Minute 5:15 – 6:30)

### Spoken Script:
> *"Finally, Section 11 and 17 mandate an AI shopping assistant with server-side proxy protection, rate limiting, and graceful degradation."*

### Screen Action:
1. Click the floating **"Ask AI"** button at bottom-right.
2. The sleek dark glassmorphism modal opens.
3. Click a quick suggestion chip: *"What are your shipping policies?"* or type:
   `"Do you have running sneakers or laptops?"`
4. The assistant streams/renders a clean domain-grounded response with bullet points.
5. In a new browser tab, navigate to:
   `http://localhost:8083/api/v1/health`
6. Show the JSON response:
   ```json
   { "status": "UP", "db": "UP" }
   ```
7. Conclude:
   > *"All 8 mandatory features and 4 optional features have been delivered and thoroughly tested with 59 passing unit/DAO tests and automated CI. Thank you, and I am now ready for questions."*
