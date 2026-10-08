# Contributing to PraveenMart

Thank you for contributing to **PraveenMart** — a multi-seller e-commerce marketplace web application built with Java Servlets, JDBC, Apache Tomcat, and H2 Database.

This guide outlines the exact workflow required from `git clone` to a running local instance, following the project's engineering and coding standards.

---

## 1. Prerequisites

Before setting up the project locally, verify that your environment has:
- **Java Development Kit (JDK)**: OpenJDK 17 LTS (Java 17+)
  ```bash
  java -version
  ```
- **Apache Maven**: Version 3.8 or higher
  ```bash
  mvn -version
  ```
- **Git**: Version 2.25 or higher
  ```bash
  git --version
  ```
- Modern web browser (Chrome, Firefox, Safari, Edge)

---

## 2. Step-by-Step Local Setup

### Step 1: Clone the Repository
```bash
git clone https://github.com/Yeah-itsPraveen/praveenmart.git
cd praveenmart
```

### Step 2: Configure Environment Variables
Copy the template configuration file:
```bash
cp .env.example .env
```
*(Optional)*: If you want to use the live Google Gemini AI shopping assistant, set your API key inside `.env`:
```ini
AI_CHATBOT_PROVIDER=gemini
GEMINI_API_KEY=your_gemini_api_key_here
```
By default, `AI_CHATBOT_PROVIDER=mock` runs offline with zero external dependencies and responds to all domain shopping inquiries.

### Step 3: Compile, Test, and Verify
Execute the complete test suite and code quality checks:
```bash
mvn clean verify
```
Expected output:
```
[INFO] Tests run: 59, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

### Step 4: Launch the Local Server
You can launch the application locally using the embedded Tomcat runner:
```bash
cd PraveenMart
mvn exec:java
```
Or start via Maven Cargo:
```bash
cd PraveenMart
mvn cargo:run
```

Once started, open your web browser and navigate to:
👉 **[http://localhost:8083/](http://localhost:8083/)**

---

## 3. Pre-Seeded Accounts for Testing

The local H2 database automatically populates seed accounts and catalog items upon startup:

| Role | Email Address | Password | Permissions & Features |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@praveenmart.com` | `admin123` | Moderate listings, view platform analytics, delete users & products |
| **Seller** | `seller@test.com` | `password` | List products, manage catalog, update inventory, fulfill incoming orders |
| **Buyer** | `buyer@test.com` | `password` | Browse store, filter categories, add to cart, wishlist, mock checkout, reviews |

---

## 4. Coding & Branching Guidelines

1. **Branching Model**:
   - `main`: Production-ready branch. Must remain green and deployable at all times.
   - `feature/<feature-name>`: Working branch for new features or bug fixes.
2. **Commit Message Standard**:
   Follow Conventional Commits:
   - `feat:` New features
   - `fix:` Bug fixes
   - `test:` Adding or updating tests
   - `docs:` Documentation updates
   - `style:` Formatting or UI styling changes
3. **Mandatory Rules**:
   - All SQL statements must strictly use `PreparedStatement`. No string concatenation under any circumstances.
   - Passwords must be hashed with `BCrypt` using `jBCrypt`. Plaintext storage is prohibited.
   - Javadoc is mandatory on every public class and method in `service` and `dao` layers.
   - Run `mvn checkstyle:check` and `mvn test` prior to submitting any PR.
