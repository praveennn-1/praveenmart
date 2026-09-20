# Sprint Retrospectives (RETRO.md)

Retrospective log for development iterations, documenting what worked, what didn't, and adjustments made.

---

### Sprint 1 — Project Skeleton & Core MVP
- **What worked**: Rapid setup of Maven, embedded Tomcat runner, H2 database connection pool with HikariCP, and user authentication with BCrypt.
- **What didn't**: Session handling required fine-tuning to prevent session fixation and properly handle redirection.
- **One change for next sprint**: Standardize exception classes earlier in the service layer to avoid boilerplate try-catch blocks.

---

### Sprint 2 — Catalog Search & Seller Management
- **What worked**: PreparedStatement parameterized queries for category filtering and keyword search with case-insensitive support.
- **What didn't**: Stock quantity validation in cart and checkout needed strict database transaction isolation.
- **One change for next sprint**: Enforce database auto-commit false with rollbacks inside order placement.

---

### Sprint 3 — Order Status Workflow & Reviews
- **What worked**: Clean order status workflow transition (PENDING -> CONFIRMED -> SHIPPED -> DELIVERED) and star rating calculations.
- **What didn't**: Star ratings needed input boundary checks to prevent ratings outside 1–5 stars.
- **One change for next sprint**: Add validation at the top of service methods before invoking DAO methods.

---

### Sprint 4 — Security, Admin Panel & Full Build
- **What worked**: Complete query parameterization check, custom error pages, structured logging with MDC request IDs, and unit testing suite.
- **What didn't**: Mock payment validation was initially coupled to the checkout servlet.
- **One change for next sprint**: Decouple payment processing using the Strategy design pattern.
