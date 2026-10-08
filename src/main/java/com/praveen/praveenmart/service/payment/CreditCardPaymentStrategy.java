package com.praveen.praveenmart.service.payment;

import java.math.BigDecimal;
import java.util.Map;
import java.util.UUID;

public class CreditCardPaymentStrategy implements PaymentStrategy {

    @Override
    public PaymentResult processPayment(Long orderId, BigDecimal amount, Map<String, String> paymentDetails) {
        String cardNumber = paymentDetails != null ? paymentDetails.get("cardNumber") : null;
        String cvv = paymentDetails != null ? paymentDetails.get("cvv") : null;

        if (cardNumber == null || cardNumber.replaceAll("\\s+", "").length() < 13) {
            return PaymentResult.failure("Invalid card number. Card number must have at least 13 digits.");
        }
        if (cvv == null || cvv.trim().length() < 3) {
            return PaymentResult.failure("Invalid CVV.");
        }

        String txnId = "TXN-CC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return PaymentResult.success(txnId, "Mock credit card transaction of ₹" + amount + " approved.");
    }

    @Override
    public String getMethodName() {
        return "CREDIT_CARD";
    }
}
