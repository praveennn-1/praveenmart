-- Pre-seeded user accounts for PraveenMart
-- Uses MERGE so this script is safe to run on every startup (idempotent).
-- Existing users are not modified; missing ones are created.

-- Admin (password: admin123)
MERGE INTO users (name, email, password_hash, role) KEY(email)
VALUES ('Admin User', 'admin@praveenmart.com', '$2a$10$71gV/GvK/cPjp9JSspIF..MGh8ONmLjGn4YL.T44bRxG7rMvBVsT.', 'ADMIN');

-- Demo Buyer (password: password)
MERGE INTO users (name, email, password_hash, role) KEY(email)
VALUES ('Test Buyer', 'buyer@test.com', '$2a$12$oGwHr7Vp5cKWfL3avAbz0OwmF6OUdoFMfWtip4ftkMaxG2OPVg1da', 'CUSTOMER');

-- Demo Seller (password: password)
MERGE INTO users (name, email, password_hash, role) KEY(email)
VALUES ('Test Seller', 'seller@test.com', '$2a$12$2BcN/Yp/LsnCQWQZeMxc0.TXwWTV4y.N9YV6fTySu.Ie/DM7zHv2i', 'SELLER');
