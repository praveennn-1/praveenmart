# Changelog

All notable changes to the PraveenMart project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.1.0] - 2026-09-25 (Week 9 Deliverable)
### Added
- Integrated AI Shopping Assistant chatbot architecture with backend proxy servlet and interactive UI widget.
- Implemented `ChatProvider` strategy interface with `MockChatProvider` (offline canned domain FAQs) and `GeminiChatProvider` (Google Gemini LLM API).
- Added `ChatProviderFactory` for dynamic provider resolution via `ai.chatbot.provider=gemini|mock`.
- Created `ChatService` with input validation guardrails (non-empty check, 500-char max cap, dynamic store inventory context assembly).
- Implemented `ChatApiController` (`/api/v1/chat` and `/api/chat`) with sliding window per-session rate limiting (10 msg/min) and in-memory question caching.
- Developed modern floating glassmorphism AI chat widget (`chat-widget.css`, `chat-widget.js`) with conversation history, suggestion chips, and responsive panel.
- Documented environment variables in `.env.example` and added unit test suite for chat components.

## [v1.0.0] - 2026-09-21 (Full Build Release)
### Added
- Completed all F1–F8 core requirements: Seller product management, Buyer catalog search & filter, Cart & Mock Checkout, Orders workflow, Admin moderation, and 5-star product reviews.
- Configured swappable payment strategy (UPI, Credit/Debit, Cash on Delivery).

## [v0.1.0] - 2026-08-10 (MVP Release)
### Added
- Initial project MVP: User authentication (Buyer/Seller/Admin), base DAO layer, HikariCP connection pool, and H2 database schema.
