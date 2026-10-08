package com.praveen.praveenmart.service.payment;

import java.util.HashMap;
import java.util.Map;

/**
 * Factory and registry for PaymentStrategy implementations (Section 12 Factory &amp; Strategy patterns).
 */
public class PaymentStrategyFactory {

    private static final Map<String, PaymentStrategy> STRATEGIES = new HashMap<>();

    static {
        registerStrategy(new CreditCardPaymentStrategy());
        registerStrategy(new UPIPaymentStrategy());
        registerStrategy(new CashOnDeliveryPaymentStrategy());
    }

    private PaymentStrategyFactory() {
    }

    /**
     * Registers a payment strategy in the central registry.
     *
     * @param strategy the payment strategy to register
     */
    public static void registerStrategy(PaymentStrategy strategy) {
        STRATEGIES.put(strategy.getMethodName().toUpperCase(), strategy);
    }

    /**
     * Resolves the appropriate PaymentStrategy based on client selection.
     * Defaults to Cash on Delivery (COD) if unspecified.
     *
     * @param method the payment method identifier
     * @return matching PaymentStrategy instance
     */
    public static PaymentStrategy getStrategy(String method) {
        if (method == null || method.isBlank()) {
            return STRATEGIES.get("COD");
        }
        String normalized = method.trim().toUpperCase();
        if (normalized.contains("CARD") || normalized.contains("CREDIT") || normalized.contains("DEBIT")) {
            return STRATEGIES.get("CREDIT_CARD");
        }
        if (normalized.contains("UPI") || normalized.contains("GPAY") || normalized.contains("PHONEPE")) {
            return STRATEGIES.get("UPI");
        }
        return STRATEGIES.getOrDefault(normalized, STRATEGIES.get("COD"));
    }
}
