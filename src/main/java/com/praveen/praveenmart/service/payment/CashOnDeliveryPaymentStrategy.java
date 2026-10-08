package com.praveen.praveenmart.service.payment;

import java.math.BigDecimal;
import java.util.Map;
import java.util.UUID;

public class CashOnDeliveryPaymentStrategy implements PaymentStrategy {

    @Override
    public PaymentResult processPayment(Long orderId, BigDecimal amount, Map<String, String> paymentDetails) {
        String txnId = "COD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return PaymentResult.success(txnId, "Cash on delivery confirmed for ₹" + amount);
    }

    @Override
    public String getMethodName() {
        return "COD";
    }
}
