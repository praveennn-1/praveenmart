package com.praveen.praveenmart.service.payment;

import java.math.BigDecimal;
import java.util.Map;

/**
 * Strategy pattern interface for swappable payment and mock payment confirmation channels (Section 12).
 */
public interface PaymentStrategy {

    /**
     * Executes mock payment confirmation for an order amount.
     *
     * @param orderId        the order ID (optional if called pre-creation)
     * @param amount         the total monetary transaction amount
     * @param paymentDetails key-value map containing channel-specific details
     * @return PaymentResult indicating success or failure message
     */
    PaymentResult processPayment(Long orderId, BigDecimal amount, Map<String, String> paymentDetails);

    /**
     * Returns the human-readable identifier of the payment method.
     *
     * @return payment method name
     */
    String getMethodName();
}
