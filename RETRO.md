# Sprint Retrospectives (RETRO.md)

Project: **PraveenMart — Multi-Seller E-Commerce Marketplace**  
Execution Cycle: Five ~2-week sprints (Jul 24 – Oct 10, 2026) per Section 16.  
Kanban Tracking Workflow: `Backlog` ➔ `In Progress` ➔ `In Review` ➔ `Done`

---

## Sprint 1: Kickoff & Core Skeleton (Jul 24 – Aug 9, 2026)
- **Goal:** Problem statement lock, Maven/Tomcat skeleton, H2 schema v1, BCrypt authentication, base DAO layer, and MVP browse-to-order user journey.
- **What worked:** Fast turnaround on HikariCP connection pool setup via `AppContextListener` and solid H2 in-memory test configuration.
- **What didn't:** Session management edge cases during simultaneous browser tab logins created initial test flakiness.
- **One change for next sprint:** Standardize session renewal on login via `oldSession.invalidate()` and enforce strict unit test timeouts.

---

## Sprint 2: Seller Hub & Order Workflows (Aug 10 – Aug 23, 2026)
- **Goal:** Seller listing management (create, edit, delete), admin user view, and order status tracking.
- **What worked:** Decoupling `ProductDAO` from servlet controllers allowed fast iteration on seller CRUD interfaces.
- **What didn't:** Form enctype handling for image URL vs multipart uploads required refactoring to keep payloads lightweight.
- **One change for next sprint:** Validate image URLs on the service layer using strict regex before database persistence.

---

## Sprint 3: Discovery, Reviews & Order Status (Aug 24 – Sep 6, 2026)
- **Goal:** Search/filter by keyword/category, star reviews on completed orders, and order status workflow (`PENDING` ➔ `CONFIRMED` ➔ `SHIPPED` ➔ `DELIVERED`).
- **What worked:** Migration scripts `V2__add_reviews_table.sql` and `V3__add_index_orders_status.sql` executed cleanly without manual table mutations.
- **What didn't:** Star rating UI alignment on mobile viewports was slightly misaligned.
- **One change for next sprint:** Adopt responsive CSS Grid and flexbox layout tokens in `theme.css`.

---

## Sprint 4: Security Hardening & Deployment (Sep 7 – Sep 20, 2026)
- **Goal:** Complete Section 9 Security Checklist, zero SQL injection audit via `PreparedStatement`, MDC logging filter, Docker deployment, and CI pipeline setup.
- **What worked:** Automated testing in JUnit 5 with Mockito provided 100% confidence across all transactional service methods.
- **What didn't:** SpotBugs ASM compatibility encountered bytecode discrepancies across newer JDK previews.
- **One change for next sprint:** Pin build target strictly to LTS Java 17 and configure Maven build properties for cross-JDK resilience.

---

## Sprint 5: AI Chatbot, Wishlist & Final Polish (Sep 21 – Oct 10, 2026)
- **Goal:** Serverless AI Shopping Assistant (Section 11 & 17), Strategy Pattern (`GeminiChatProvider` and `MockChatProvider`), rate limiter, session cache, Wishlist/Save-for-Later (O1), Checkstyle/SpotBugs static analysis, and Final Review deliverables.
- **What worked:** Strategy pattern with graceful degradation enabled zero-downtime AI assistant operations both online and offline.
- **What didn't:** Outbound Gemini API latency spikes during peak network testing required an aggressive 5-second HTTP client timeout.
- **One change for next sprint:** Implement client-side speculative typing indicators to improve perceived conversational responsiveness.
