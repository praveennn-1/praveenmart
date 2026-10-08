-- V3__add_index_orders_status.sql: Add Index on orders(status) for PraveenMart
-- Enhances order status workflow queries and seller/admin status filtering

CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
