# PraveenMart — Backup Demonstration Video Guide & Storyboard

**Specification Requirement:** Section 10 (Deployment Specification) & Section 11  
*"Backup requirement: Record a 2–3 minute screen-capture demonstration prior to each review, for use if the live deployment is inaccessible during evaluation."*

---

## 1. Video Recording Parameters
- **Duration:** 2 minutes 30 seconds (150 seconds target)
- **Resolution:** 1080p (1920 × 1080) at 30 fps
- **Audio:** Clear voiceover with USB condenser microphone or headset
- **Tooling:** QuickTime Player (macOS) / OBS Studio / Loom

---

## 2. Timed Demonstration Storyboard

| Timestamp | Visual Focus | Narration & Action Points | Requirement Verified |
| :---: | :--- | :--- | :--- |
| **0:00 – 0:25** | Home page (`/products`), scrolling product grid, search bar | *"Welcome to PraveenMart. Here is our home storefront displaying categorized products across Electronics, Fashion, Home, and Books with live keyword search and responsive UI."* | F3 (Browse & Search) |
| **0:25 – 0:50** | Product Details, Wishlist, Add to Cart | *"We select a product, examine the price, stock quantity, and reviews. We save the product to our Wishlist, then move it to the shopping cart, showing live quantity steppers and subtotal calculations."* | F4, F8, O1 (Cart & Wishlist) |
| **0:50 – 1:15** | Checkout, Mock Payment Confirmation, Order Placed | *"Proceeding to checkout, we select Cash on Delivery under our Strategy-pattern payment engine. Submitting places the order, deducts product inventory atomically, and generates order confirmation."* | F5, F6 (Mock Checkout & Stock Deduction) |
| **1:15 – 1:40** | Seller Dashboard (`/seller/dashboard`) | *"Logging into a seller account, we view merchant sales totals, incoming line-item customer orders, and advance the order workflow from Confirmed to Shipped to Delivered."* | F2, F6, O2, O3 (Seller Hub & Workflow) |
| **1:40 – 2:05** | Admin Panel (`/admin/dashboard`) | *"Switching to the administrator account, we see total marketplace metrics, buyer/seller user distribution, and moderation controls to delete inappropriate listings or users."* | F1, F7 (Admin Governance) |
| **2:05 – 2:30** | AI Shopping Assistant Modal & Health Check | *"Finally, we launch our serverless AI Shopping Assistant, ask about shipping policies, receive a contextual markdown response, and verify container liveness at `/api/v1/health`."* | O4, Section 11, Section 18 |

---

## 3. Emergency Fallback Procedure
If the live cloud instance is unreachable during evaluation:
1. Play the pre-recorded video file: `assets/praveenmart_demo_backup.mp4`.
2. Demonstrate local test execution:
   ```bash
   mvn clean verify
   ```
   Show 59 passing unit/DAO tests and automated build report.
3. Start the local server immediately using:
   ```bash
   cd PraveenMart && mvn exec:java
   ```
   Access the local instance at `http://localhost:8083/`.
