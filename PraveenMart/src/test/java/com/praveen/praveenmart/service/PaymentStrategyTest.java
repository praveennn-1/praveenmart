package com.praveen.praveenmart.service;

import com.praveen.praveenmart.service.payment.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class PaymentStrategyTest {

    @Test
    @DisplayName("Should resolve correct strategies via PaymentStrategyFactory")
    void testStrategyFactoryResolution() {
        PaymentStrategy cc = PaymentStrategyFactory.getStrategy("CREDIT_CARD");
        assertTrue(cc instanceof CreditCardPaymentStrategy);

        PaymentStrategy upi = PaymentStrategyFactory.getStrategy("UPI");
        assertTrue(upi instanceof UPIPaymentStrategy);

        PaymentStrategy cod = PaymentStrategyFactory.getStrategy("COD");
        assertTrue(cod instanceof CashOnDeliveryPaymentStrategy);

        PaymentStrategy fallback = PaymentStrategyFactory.getStrategy("UNKNOWN");
        assertTrue(fallback instanceof CashOnDeliveryPaymentStrategy);
    }

    @Test
    @DisplayName("CreditCardPaymentStrategy should validate card number and CVV")
    void testCreditCardValidation() {
        PaymentStrategy strategy = new CreditCardPaymentStrategy();
        BigDecimal amount = new BigDecimal("1499.00");

        Map<String, String> invalidDetails = new HashMap<>();
        invalidDetails.put("cardNumber", "123");
        invalidDetails.put("cvv", "1");
        PaymentResult failedResult = strategy.processPayment(1L, amount, invalidDetails);
        assertFalse(failedResult.isSuccessful());

        Map<String, String> validDetails = new HashMap<>();
        validDetails.put("cardNumber", "4532 1234 5678 9010");
        validDetails.put("cvv", "123");
        PaymentResult successResult = strategy.processPayment(1L, amount, validDetails);
        assertTrue(successResult.isSuccessful());
        assertNotNull(successResult.getTransactionId());
    }

    @Test
    @DisplayName("UPIPaymentStrategy should validate UPI ID format")
    void testUPIValidation() {
        PaymentStrategy strategy = new UPIPaymentStrategy();
        BigDecimal amount = new BigDecimal("499.00");

        Map<String, String> invalidDetails = Map.of("upiId", "notanupiid");
        PaymentResult failedResult = strategy.processPayment(1L, amount, invalidDetails);
        assertFalse(failedResult.isSuccessful());

        Map<String, String> validDetails = Map.of("upiId", "buyer@okaxis");
        PaymentResult successResult = strategy.processPayment(1L, amount, validDetails);
        assertTrue(successResult.isSuccessful());
        assertNotNull(successResult.getTransactionId());
    }

    @Test
    @DisplayName("CashOnDeliveryPaymentStrategy should succeed")
    void testCashOnDelivery() {
        PaymentStrategy strategy = new CashOnDeliveryPaymentStrategy();
        BigDecimal amount = new BigDecimal("799.00");

        PaymentResult result = strategy.processPayment(1L, amount, Map.of());
        assertTrue(result.isSuccessful());
        assertTrue(result.getTransactionId().startsWith("COD-"));
    }
}
