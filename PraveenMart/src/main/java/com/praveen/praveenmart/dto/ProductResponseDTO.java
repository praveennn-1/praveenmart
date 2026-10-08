package com.praveen.praveenmart.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * ProductResponseDTO for JSON API responses with Builder pattern.
 */
public class ProductResponseDTO {

    private Long id;
    private Long sellerId;
    private String sellerName;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer stockQty;
    private String category;
    private String imageUrl;
    private Double averageRating;
    private Integer reviewCount;
    private LocalDateTime createdAt;

    public ProductResponseDTO() {
    }

    private ProductResponseDTO(Builder builder) {
        this.id = builder.id;
        this.sellerId = builder.sellerId;
        this.sellerName = builder.sellerName;
        this.name = builder.name;
        this.description = builder.description;
        this.price = builder.price;
        this.stockQty = builder.stockQty;
        this.category = builder.category;
        this.imageUrl = builder.imageUrl;
        this.averageRating = builder.averageRating;
        this.reviewCount = builder.reviewCount;
        this.createdAt = builder.createdAt;
    }

    public static Builder builder() {
        return new Builder();
    }

    public Long getId() {
        return id;
    }

    public Long getSellerId() {
        return sellerId;
    }

    public String getSellerName() {
        return sellerName;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public Integer getStockQty() {
        return stockQty;
    }

    public String getCategory() {
        return category;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public Double getAverageRating() {
        return averageRating;
    }

    public Integer getReviewCount() {
        return reviewCount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public static class Builder {
        private Long id;
        private Long sellerId;
        private String sellerName;
        private String name;
        private String description;
        private BigDecimal price;
        private Integer stockQty;
        private String category;
        private String imageUrl;
        private Double averageRating;
        private Integer reviewCount;
        private LocalDateTime createdAt;

        public Builder id(Long id) {
            this.id = id;
            return this;
        }

        public Builder sellerId(Long sellerId) {
            this.sellerId = sellerId;
            return this;
        }

        public Builder sellerName(String sellerName) {
            this.sellerName = sellerName;
            return this;
        }

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder description(String description) {
            this.description = description;
            return this;
        }

        public Builder price(BigDecimal price) {
            this.price = price;
            return this;
        }

        public Builder stockQty(Integer stockQty) {
            this.stockQty = stockQty;
            return this;
        }

        public Builder category(String category) {
            this.category = category;
            return this;
        }

        public Builder imageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
            return this;
        }

        public Builder averageRating(Double averageRating) {
            this.averageRating = averageRating;
            return this;
        }

        public Builder reviewCount(Integer reviewCount) {
            this.reviewCount = reviewCount;
            return this;
        }

        public Builder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }

        public ProductResponseDTO build() {
            return new ProductResponseDTO(this);
        }
    }
}
