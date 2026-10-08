# PraveenMart — End-to-End Manual Test-Case Specification

**Specification Requirement:** Section 9 (Testing & Validation Requirements)  
**Test Focus:** Register ➔ Browse ➔ Cart ➔ Checkout ➔ Fulfill ➔ Review, Edge Cases & Security Checks

---

## 1. Test Cases Overview

| Test Case ID | Test Category | Summary Description | Expected Result | Status |
| :---: | :--- | :--- | :--- | :---: |
| **TC-AUTH-01** | Authentication | Register a new Buyer account with valid credentials | User created, redirected to login/products | PASS |
| **TC-AUTH-02** | Authentication | Attempt registration with existing email | Validation error displayed; duplicate rejected | PASS |
| **TC-AUTH-03** | Authentication | Attempt registration with password < 8 characters | Client/server validation triggers error | PASS |
| **TC-AUTH-04** | Authentication | Sign in with valid Buyer credentials | Session ID regenerated; 30-min timeout set | PASS |
| **TC-AUTH-05** | Authentication | Sign in with invalid password | Anonymized error shown; password never logged | PASS |
| **TC-AUTH-06** | Authentication | Access `/admin/dashboard` as non-admin user | HTTP 403 Forbidden / redirect to login | PASS |
| **TC-CAT-01** | Catalog | Filter products by category ("Electronics") | Only Electronics products displayed | PASS |
| **TC-CAT-02** | Catalog | Search products using keyword "T-Shirt" | Matching product cards returned in grid | PASS |
| **TC-CAT-03** | Catalog | Search using keyword with zero matches | Clean empty state with search advice rendered | PASS |
| **TC-WISH-01** | Wishlist (O1) | Save product to Wishlist from product details | Product stored in `wishlist_items`; heart highlighted | PASS |
| **TC-WISH-02** | Wishlist (O1) | Move product from Wishlist to Shopping Cart | Product removed from wishlist, added to cart | PASS |
| **TC-CART-01** | Cart (F4) | Add available product to cart | Item added; cart badge count increments | PASS |
| **TC-CART-02** | Cart (F4) | Increment quantity using stepper (+) | Item quantity and subtotal recalculate correctly | PASS |
| **TC-CART-03** | Cart (F4) | Attempt to add more quantity than available stock | `InsufficientStockException` / error toast | PASS |
| **TC-CART-04** | Cart (F4) | Click "Save for Later" on cart item | Item moved from cart into Wishlist | PASS |
| **TC-CHCK-01** | Checkout (F5) | Place order with Cash on Delivery (COD) | Transaction commits, order status `CONFIRMED` | PASS |
| **TC-CHCK-02** | Checkout (F5) | Place order with Mock UPI confirmation | Mock payment succeeds; inventory deducted | PASS |
| **TC-CHCK-03** | Checkout (F5) | Attempt checkout with empty cart | Blocked with validation error | PASS |
| **TC-SELLER-01**| Seller (F2) | Create new product listing with valid data | Product saved in database; appears in catalog | PASS |
| **TC-SELLER-02**| Seller (F2) | Edit existing product price and stock quantity | Updates reflected immediately in catalog | PASS |
| **TC-SELLER-03**| Seller (O2) | Advance incoming order status to `SHIPPED` | Order status updated in database | PASS |
| **TC-ADMIN-01** | Admin (F7) | Admin login using `admin@praveenmart.com` | Dashboard displays platform user & revenue totals | PASS |
| **TC-ADMIN-02** | Admin (F7) | Moderate and delete inappropriate product | Product cascade-deleted from marketplace | PASS |
| **TC-REV-01** | Review (F8) | Submit 5-star rating and comment on product | Review stored in `reviews`; average recalculated | PASS |
| **TC-REV-02** | Review (F8) | Attempt submit rating < 1 or > 5 | Server validation rejects with HTTP 400 | PASS |
| **TC-AI-01** | Chatbot (O4) | Ask FAQ: "What is your return policy?" | Instant markdown response rendered in modal | PASS |
| **TC-AI-02** | Chatbot (O4) | Ask identical question twice in one session | Second response served from session cache | PASS |
| **TC-AI-03** | Chatbot (O4) | Send message exceeding 500 characters | Rejected with HTTP 400 validation error | PASS |
| **TC-SEC-01** | Security | Inject SQL payload `' OR 1=1 --` into search | Handled safely by `PreparedStatement` | PASS |
| **TC-SEC-02** | Security | Inject `<script>alert(1)</script>` in review | Escaped safely via JSTL `<c:out>` / DOM text | PASS |
| **TC-SEC-03** | Security | Request non-existent URL `/invalid-page` | Custom `404.jsp` rendered without stack trace | PASS |
| **TC-OBS-01** | Observability | `GET /api/v1/health` | Returns `{ "status": "UP", "db": "UP" }` HTTP 200 | PASS |

---

## 2. Test Execution Sign-Off
- **Automated Tests:** 59 unit and DAO tests (0 failures, 0 errors).
- **Manual End-to-End Test Pass Rate:** 100% (32/32 Passed).
- **Tested Environments:** macOS Sonoma (OpenJDK 17/27, Tomcat 9.0.85) & Ubuntu 22.04 LTS (Temurin 17).
