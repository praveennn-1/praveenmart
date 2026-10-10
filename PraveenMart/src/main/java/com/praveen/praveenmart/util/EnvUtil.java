package com.praveen.praveenmart.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Utility for loading configuration from .env files and environment/system properties.
 */
public class EnvUtil {

    private static final Logger logger = LoggerFactory.getLogger(EnvUtil.class);
    private static final Map<String, String> ENV_MAP = new ConcurrentHashMap<>();
    private static volatile boolean loaded = false;

    static {
        load();
    }

    /**
     * Loads variables from the nearest .env file found in common project locations.
     */
    public static synchronized void load() {
        if (loaded) {
            return;
        }

        String userDir = System.getProperty("user.dir", ".");
        String[] candidatePaths = new String[]{
                userDir + "/.env",
                userDir + "/praveenmart/PraveenMart/.env",
                userDir + "/PraveenMart/.env",
                ".env",
                "praveenmart/PraveenMart/.env",
                "PraveenMart/.env",
                "../.env",
                "../../.env"
        };

        File envFile = null;
        for (String path : candidatePaths) {
            File f = new File(path);
            if (f.exists() && f.isFile()) {
                envFile = f;
                break;
            }
        }

        if (envFile != null) {
            logger.info("Loading environment variables from: {}", envFile.getAbsolutePath());
            try (BufferedReader reader = new BufferedReader(new FileReader(envFile, StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty() || line.startsWith("#")) {
                        continue;
                    }
                    int eqIdx = line.indexOf('=');
                    if (eqIdx > 0) {
                        String key = line.substring(0, eqIdx).trim();
                        String value = line.substring(eqIdx + 1).trim();
                        if ((value.startsWith("\"") && value.endsWith("\"")) ||
                                (value.startsWith("'") && value.endsWith("'"))) {
                            value = value.substring(1, value.length() - 1);
                        }
                        ENV_MAP.put(key, value);
                        if (System.getProperty(key) == null) {
                            System.setProperty(key, value);
                        }
                    }
                }
                loaded = true;
                logger.info("Loaded {} configuration keys from .env", ENV_MAP.size());
            } catch (Exception e) {
                logger.error("Failed to read .env file at {}", envFile.getAbsolutePath(), e);
            }
        } else {
            logger.debug("No .env file found in candidate locations.");
        }
    }

    /**
     * Retrieves the configuration value for the specified key.
     * Lookup priority: System Property -> System Env -> Loaded .env map.
     *
     * @param key configuration key
     * @return value or null if not found
     */
    public static String get(String key) {
        return get(key, null);
    }

    /**
     * Retrieves the configuration value for the specified key with a fallback default.
     *
     * @param key configuration key
     * @param defaultValue default value if not found
     * @return value or defaultValue
     */
    public static String get(String key, String defaultValue) {
        if (!loaded) {
            load();
        }

        // 1. Check System Property
        String val = System.getProperty(key);
        if (val != null && !val.isBlank()) {
            return val.trim();
        }

        // 2. Check OS Environment Variable
        val = System.getenv(key);
        if (val != null && !val.isBlank()) {
            return val.trim();
        }

        // 3. Check loaded .env map
        val = ENV_MAP.get(key);
        if (val != null && !val.isBlank()) {
            return val.trim();
        }

        return defaultValue;
    }
}
