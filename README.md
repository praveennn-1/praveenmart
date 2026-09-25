# PraveenMart — Multi-Seller E-Commerce Marketplace

**Java Servlets · JDBC · Apache Tomcat 9 · Anna University R2025**  
**Builder**: Solo Developer  
**Status**: Active Checkpoint Progress — **Week 9: AI Chatbot Integration Complete**

---

## 1. Problem Statement
Modern digital retail requires a robust, responsive multi-seller platform where independent merchants can list and manage inventories while shoppers enjoy seamless product discovery, multi-item cart management, streamlined mock checkout, order tracking, and peer reviews. **PraveenMart** provides an end-to-end marketplace featuring role-based access control (Buyer, Seller, Admin), a serverless AI shopping assistant, and enterprise-grade security standards.

---

## 2. System Architecture

```
Browser (HTML5, Vanilla JS, AJAX fetch, Glassmorphism Widget)
  |  HTTP / REST JSON
  v
Filter Layer (AuthFilter, LoggingFilter, EncodingFilter)
  |
  +--> Front Controller / Servlets (ProductServlet, OrderServlet, CartServlet, ChatServlet)
  |      |
  |      v
  +--> Service Layer (ProductService, OrderService, UserService, ChatService)
         |
         +--> DAO Layer (ProductDAO, OrderDAO, UserDAO, ReviewDAO, CartDAO)
         |      | (PreparedStatements only, Try-with-resources)
         |      v
         |    Connection Pool (HikariCP via ServletContextListener)
         |      v
         |    H2 Database (Server / Embedded mode)
         |
         +--> AI Chatbot Subsystem (Strategy Pattern)
                |
                +--> ChatProvider Interface
                       |-- MockChatProvider (Offline FAQ & Domain Search)
                       `-- GeminiChatProvider (Google Gemini 1.5 Flash LLM)
```

---

## 3. Technology Stack

| Component | Technology / Library | Version |
| :--- | :--- | :--- |
| **JDK** | OpenJDK 17 (LTS) | 17+ |
| **Servlet Container** | Apache Tomcat | 9.0.x (`javax.servlet.*`) |
| **Build Tool** | Apache Maven | 3.9+ |
| **Database** | H2 Database Engine | 2.3.x |
| **Connection Pooling** | HikariCP | 2.7.9 |
| **View Layer** | JSP + JSTL + Vanilla JS (`fetch`) | Standard |
| **JSON Serialization** | Google Gson | 2.8.5 |
| **Password Hashing** | jBCrypt | 0.4 |
| **Logging** | SLF4J + Logback (MDC request tracing) | 1.7 / 1.2 |
| **Testing** | JUnit 5 + Mockito | 5.10 |
| **AI LLM API** | Google Gemini API (`gemini-1.5-flash`) | v1beta |

---

## 4. Week 9 Deliverable: AI Chatbot Integration

The Week 9 milestone integrates an AI Shopping Assistant directly into PraveenMart:
- **Backend Proxy Servlet**: Versioned at `/api/v1/chat` (and `/api/chat`), preventing API keys from ever leaking to the browser.
- **Provider Strategy Interface**: Swappable `ChatProvider` implementations (`MockChatProvider` and `GeminiChatProvider`), resolved via `ChatProviderFactory` (`ai.chatbot.provider=gemini|mock`).
- **Guardrails**:
  1. Per-session sliding window rate limit: **10 messages per minute** (HTTP 429 response on breach).
  2. Input length cap: Max **500 characters** with server-side validation (HTTP 400).
  3. Outbound API call timeout: **5 seconds** via Java 17 `HttpClient`.
  4. Server-side prompt template: Strictly confines responses to product queries, order tracking, shipping, and return policies.
  5. In-memory session cache: Repeated identical questions within a session return instantly from cache (`provider: "cache"`).
  6. Graceful degradation: Any network or API failure automatically falls back to domain-aware FAQ responses.
- **Frontend Widget**:
  - Floating launcher button with pulse animation and "Ask AI" badge at bottom-right of viewport.
  - Dark glassmorphism modal with quick-suggestion chips, live typing indicator, markdown formatting, and session persistence.

---

## 5. Setup & Running Locally

### Prerequisites
- JDK 17 installed (`java -version`)
- Maven 3.8+ installed (`mvn -version`)

### Quick Start
```bash
# 1. Clone repository
git clone https://github.com/Yeah-itsPraveen/praveenmart.git
cd praveenmart/PraveenMart

# 2. Configure environment (Optional - defaults to mock chatbot & embedded H2)
cp .env.example .env

# 3. Run test suite
mvn test

# 4. Start local development server
mvn clean package exec:java
# Or launch Tomcat Cargo:
mvn cargo:run
```
Open [http://localhost:8083/](http://localhost:8083/) in your web browser.

---

## 6. Seed Accounts

| Role | Email | Password |
| :--- | :--- | :--- |
| **Admin** | `admin@praveenmart.com` | `admin123` |
| **Seller** | `seller@test.com` | `password` |
| **Buyer** | `buyer@test.com` | `password` |

---

## 7. Versioning & Changelog
See [CHANGELOG.md](CHANGELOG.md) for detailed semver history.
- `v0.1.0`: MVP Review
- `v1.0.0`: Full Build & Deployment
- `v1.1.0`: AI Chatbot Integration (Week 9)
