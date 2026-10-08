package com.praveen.praveenmart.util;

import java.math.BigDecimal;
import java.util.regex.Pattern;

public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private ValidationUtil() {
    }

    public static boolean isValidEmail(String email) {
        return email != null && !email.trim().isBlank() && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.trim().length() >= 8;
    }

    public static boolean isValidName(String name) {
        return name != null && !name.trim().isBlank() && name.trim().length() <= 100;
    }

    public static boolean isValidPrice(BigDecimal price) {
        return price != null && price.compareTo(BigDecimal.ZERO) > 0;
    }

    public static boolean isValidStock(Integer stock) {
        return stock != null && stock >= 0;
    }

    public static boolean isValidCategory(String category) {
        return category != null && !category.trim().isBlank() && category.trim().length() <= 100;
    }
}
