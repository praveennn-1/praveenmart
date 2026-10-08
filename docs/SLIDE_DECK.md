# PraveenMart — Final Review Slide Deck Presentation

**Course:** Anna University R2025, Semester 3  
**Project:** PraveenMart — Multi-Seller E-Commerce Marketplace  
**Tech Stack:** Java Servlets 4.0 · JDBC · Apache Tomcat 9.0 · H2 Database Engine  
**Builder:** Solo Developer (Praveen)  
**Date:** October 10, 2026 (Final Review Milestone)

---

### Slide 1: Title & Project Overview
- **Header:** PraveenMart — High-Performance Multi-Seller Marketplace
- **Subheader:** Layered MVC Architecture over Java Servlets & JDBC
- **Key Points:**
  - Modern multi-seller ecosystem: Sellers curate products; buyers browse, search, cart, and purchase.
  - Zero heavy framework dependencies (no Spring/Hibernate overhead).
  - Built strictly to Anna University R2025 engineering specifications.
  - Checkpoint Window: Completed Jul 27 – Oct 10, 2026.

---

### Slide 2: Problem Statement & Motivation
- **Core Challenge:** Traditional monolithic single-seller architectures lack multi-merchant autonomy, while heavyweight modern frameworks obscure fundamental computer science concepts and consume excessive system resources.
- **Solution:** PraveenMart implements clean separation of concerns:
  - Role-Based Access Control (Buyer, Seller, Admin).
  - Scalable connection pooling with HikariCP.
  - Transaction-safe checkout and stock deductions.
  - Integrated AI Shopping Assistant with server-side proxy protection.

---

### Slide 3: Architecture & System Design
- **Architecture Pattern:** Front Controller & Layered MVC.
- **Tier Breakdown:**
  1. **Presentation:** Responsive JSP views + Vanilla JS (AJAX fetch) + Glassmorphism AI Widget.
  2. **Filter Pipeline:** `LoggingFilter` (MDC request tracing) ➔ `EncodingFilter` (UTF-8) ➔ `AuthFilter` (RBAC & route guards).
  3. **Controllers:** Thin servlets managing HTTP dispatching and JSON response envelopes.
  4. **Service Layer:** Pure business orchestration, stock checks, and top-of-method validations.
  5. **DAO Layer:** 100% `PreparedStatement` data access abstraction.
  6. **Persistence:** H2 Database Engine (embedded in tests, server mode in deployment).

---

### Slide 4: Database Design & Normalization (D1)
- **Schema Entities:** `users`, `products`, `orders`, `order_items`, `cart_items`, `wishlist_items`, `reviews`.
- **Engineering Highlights:**
  - Foreign key indexing on all relational joins.
  - Monetary fields strictly typed as `DECIMAL(10,2)` (floating point prohibited).
  - Unique constraints on `users.email` and composite keys `(user_id, product_id)`.
  - Numbered migration pipeline: `V1__init_schema.sql` ➔ `V2__add_reviews_table.sql` ➔ `V3__add_index_orders_status.sql` ➔ `V4__add_wishlist_table.sql`.

---

### Slide 5: Feature Matrix: Mandatory (F1–F8) & Optional (O1–O4)
- **F1 Authentication:** Buyer & Seller self-service registration; BCrypt password hashing; admin seed account (`admin@praveenmart.com`).
- **F2 Seller Operations:** Full CRUD on listings with category categorization and stock quantities.
- **F3 Discovery:** Live search, dynamic category filtering, responsive product catalog.
- **F4 Cart:** Increment, decrement, delete, live subtotal computation.
- **F5 Checkout:** Transactional mock checkout with atomic inventory reduction.
- **F6 Order Tracking:** Buyer past orders and status; seller line-item incoming order logs.
- **F7 Administration:** Platform analytics, product listing moderation, user removal.
- **F8 Reviews & Ratings:** 1–5 star reviews with verified purchase safeguards.
- **O1–O4 Delivered:** Wishlist / Save-for-Later, Order Status Workflow (`PENDING` ➔ `CONFIRMED` ➔ `SHIPPED` ➔ `DELIVERED`), Seller Sales Dashboard, and AI Shopping Assistant.

---

### Slide 6: Design Patterns in Action (Section 12)
1. **DAO Pattern:** Decouples business logic from persistence dialects.
2. **Front Controller Pattern:** Unified security inspection and dispatching via Servlet Filters.
3. **Singleton Pattern:** Shared HikariCP pool initialized via `AppContextListener`.
4. **Factory Pattern:** `DAOFactory`, `ChatProviderFactory`, `PaymentStrategyFactory`.
5. **Strategy Pattern:** Swappable payment strategies (COD, UPI, Card) and AI providers (Gemini & Mock).
6. **Builder Pattern:** Fluent, immutable DTO construction (`UserResponseDTO`, `ProductResponseDTO`, `OrderSummaryDTO`, `ChatResponseDTO`).

---

### Slide 7: AI Shopping Assistant Subsystem (Section 11 & 17)
- **Architecture:** Client Widget ➔ `/api/v1/chat` Backend Proxy ➔ `ChatService` ➔ `ChatProvider` Strategy.
- **Security & Guardrails:**
  - Server-side API key protection (zero frontend exposure).
  - Rate limiting: Max 10 messages/minute per session (HTTP 429).
  - Input length cap: 500 characters max (HTTP 400).
  - 5-second outbound HTTP client timeout.
  - In-memory session cache for repeated identical queries.
  - Graceful fallback to domain FAQ provider during network disruptions.

---

### Slide 8: Security, Quality Assurance & CI/CD
- **Zero SQL Injection:** Audited with 100% parameterization (`PreparedStatement`).
- **Cryptographic Standards:** BCrypt work factor 12; zero credential logging.
- **Static Analysis:** Checkstyle and SpotBugs integrated as Maven build plugins.
- **Automated Testing:** 59 unit and DAO tests passing in CI on GitHub Actions.
- **Liveness Observability:** `GET /api/v1/health` verifying container and database readiness.

---

### Slide 9: Live Demonstration & Evaluation Summary
- **Live User Journey Walkthrough:**
  1. Buyer registration, searching and filtering catalog.
  2. Adding items to cart, saving items to wishlist.
  3. Seamless mock payment confirmation and stock deduction.
  4. Seller dashboard: verifying incoming order and advancing status.
  5. Admin moderation: inspecting platform orders and listings.
  6. AI shopping assistant interactive query demonstration.
- **Conclusion:** 100% specification requirements fulfilled on time.
