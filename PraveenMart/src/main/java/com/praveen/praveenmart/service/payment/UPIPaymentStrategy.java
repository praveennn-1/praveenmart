package com.praveen.praveenmart.service.payment;

import java.math.BigDecimal;
import java.util.Map;
import java.util.UUID;

public class UPIPaymentStrategy implements PaymentStrategy {

    @Override
    public PaymentResult processPayment(Long orderId, BigDecimal amount, Map<String, String> paymentDetails) {
        String upiId = paymentDetails != null ? paymentDetails.get("upiId") : null;

        if (upiId == null || !upiId.contains("@") || upiId.trim().length() < 5) {
            return PaymentResult.failure("Invalid UPI ID. Format should be user@bank.");
        }

        String txnId = "TXN-UPI-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return PaymentResult.success(txnId, "Mock UPI payment of ₹" + amount + " verified via " + upiId);
    }

    @Override
    public String getMethodName() {
        return "UPI";
    }
}
