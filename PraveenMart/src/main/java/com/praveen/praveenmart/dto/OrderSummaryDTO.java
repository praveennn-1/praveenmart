package com.praveen.praveenmart.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * OrderSummaryDTO with Builder pattern for Section 12 requirements.
 */
public class OrderSummaryDTO {

    private Long orderId;
    private Long buyerId;
    private String buyerName;
    private String status;
    private BigDecimal totalAmount;
    private int itemCount;
    private LocalDateTime createdAt;

    public OrderSummaryDTO() {
    }

    private OrderSummaryDTO(Builder builder) {
        this.orderId = builder.orderId;
        this.buyerId = builder.buyerId;
        this.buyerName = builder.buyerName;
        this.status = builder.status;
        this.totalAmount = builder.totalAmount;
        this.itemCount = builder.itemCount;
        this.createdAt = builder.createdAt;
    }

    public static Builder builder() {
        return new Builder();
    }

    public Long getOrderId() {
        return orderId;
    }

    public Long getBuyerId() {
        return buyerId;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public String getStatus() {
        return status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public int getItemCount() {
        return itemCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public static class Builder {
        private Long orderId;
        private Long buyerId;
        private String buyerName;
        private String status;
        private BigDecimal totalAmount;
        private int itemCount;
        private LocalDateTime createdAt;

        public Builder orderId(Long orderId) {
            this.orderId = orderId;
            return this;
        }

        public Builder buyerId(Long buyerId) {
            this.buyerId = buyerId;
            return this;
        }

        public Builder buyerName(String buyerName) {
            this.buyerName = buyerName;
            return this;
        }

        public Builder status(String status) {
            this.status = status;
            return this;
        }

        public Builder totalAmount(BigDecimal totalAmount) {
            this.totalAmount = totalAmount;
            return this;
        }

        public Builder itemCount(int itemCount) {
            this.itemCount = itemCount;
            return this;
        }

        public Builder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }

        public OrderSummaryDTO build() {
            return new OrderSummaryDTO(this);
        }
    }
}
