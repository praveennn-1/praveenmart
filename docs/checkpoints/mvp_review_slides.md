# PraveenMart — MVP Review (Aug 10, 2026)
## 2-Slide Executive Summary

---

### Slide 1: Problem Statement & System Architecture

#### Problem Statement
Modern multi-seller commerce requires independent merchant inventory control without sacrificing shopper discovery, transaction security, or architectural simplicity. **PraveenMart** provides an enterprise-grade yet lightweight multi-seller marketplace using pure Java 17 Servlets, JDBC, and Apache Tomcat, eliminating heavyweight framework overhead while enforcing strict layered separation of concerns.

#### Architecture Sketch
```
[ Browser (HTML5 / Vanilla JS / AJAX) ]
                    |
                    v (HTTP REST / JSON Envelope)
[ Filter Layer: AuthFilter, LoggingFilter (MDC), EncodingFilter ]
                    |
                    v
[ Controllers: ProductServlet, CartServlet, OrderServlet, LoginServlet ]
                    |
                    v (Business rules & Top-of-service Validation)
[ Service Layer: ProductService, CartService, OrderService, UserService ]
                    |
                    v (Pure JDBC with PreparedStatement only)
[ DAO Layer: ProductDAO, CartDAO, OrderDAO, UserDAO, ReviewDAO ]
                    |
                    v (HikariCP Connection Pool via AppContextListener)
[ H2 Database Engine (Server / Embedded Mode) ]
```

---

### Slide 2: Completed Work vs. Planned Execution Roadmap

#### Completed Work (MVP Review Milestone — Aug 10, 2026)
1. **Core Infrastructure:** Clean Maven multi-module skeleton, embedded Tomcat runner, HikariCP connection pool, and H2 database schema (`V1__init_schema.sql`).
2. **Authentication & Security:** BCrypt password hashing via `jBCrypt`, session regeneration on login, explicit 30-minute timeout, and `AuthFilter` route protection.
3. **End-to-End User Journey:** Complete browse ➔ search/filter ➔ add to cart ➔ mock checkout ➔ order confirmation flow fully verified.
4. **Automated Testing:** 50+ JUnit 5 + Mockito unit & DAO tests executing against embedded in-memory H2 database (`jdbc:h2:mem:test`).
5. **Version Control Discipline:** Main branch green, conventional commits maintained across kickoff and sprint cycles.

#### Planned Work (Path to Full Build — Sep 21 & Oct 10)
1. **Seller Dashboard & Inventory Management:** Listing edit/delete, stock adjustments, incoming order fulfillment tracking.
2. **Order Status Lifecycle & Moderation:** Complete status progression (`PENDING` ➔ `CONFIRMED` ➔ `SHIPPED` ➔ `DELIVERED`), admin user/product moderation.
3. **Product Reviews & Wishlist:** Star ratings on completed orders, Save-for-Later wishlist feature.
4. **AI Shopping Assistant:** Serverless Gemini LLM integration with Mock fallback, session rate limiting, and glassmorphism floating widget.
5. **Static Analysis & CI:** SpotBugs and Checkstyle compliance in GitHub Actions CI workflow.
