package com.praveen.praveenmart;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.bridge.SLF4JBridgeHandler;

import java.io.File;

/**
 * Main application launcher for PraveenMart.
 * Automatically resolves the webapp directory whether executed from root or sub-module directory.
 */
public class Main {
    private static final Logger logger = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) throws Exception {
        // Route java.util.logging (Tomcat logs) through SLF4J / Logback
        SLF4JBridgeHandler.removeHandlersForRootLogger();
        SLF4JBridgeHandler.install();

        // Skip TLD scanning in JARs to eliminate TldScanner log noise
        System.setProperty("tomcat.util.scan.StandardJarScanFilter.jarsToSkip", "*.jar");

        // Resolve webapp directory dynamically
        File webappDir = new File("PraveenMart/src/main/webapp");
        if (!webappDir.exists()) {
            webappDir = new File("src/main/webapp");
        }
        if (!webappDir.exists()) {
            throw new IllegalStateException("Could not find webapp directory at PraveenMart/src/main/webapp or src/main/webapp from " + new File(".").getAbsolutePath());
        }

        Tomcat tomcat = new Tomcat();

        String portStr = System.getProperty("app.http.port", "8083");
        int port = Integer.parseInt(portStr);
        tomcat.setPort(port);

        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir.getAbsolutePath());
        ctx.setParentClassLoader(Main.class.getClassLoader());

        // Resolve compiled target classes directory dynamically
        File additionWebInfClasses = new File("PraveenMart/target/classes");
        if (!additionWebInfClasses.exists()) {
            additionWebInfClasses = new File("target/classes");
        }
        if (additionWebInfClasses.exists()) {
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
            ctx.setResources(resources);
        }

        tomcat.getConnector();
        tomcat.start();

        String appUrl = "http://localhost:" + port + "/";
        System.out.println("\n" +
                "======================================================================\n" +
                "  PraveenMart Application is LIVE and Running!\n" +
                "  Click to open in browser: " + appUrl + "\n" +
                "======================================================================\n");

        logger.info("PraveenMart Application started successfully. Accessible at {}", appUrl);

        tomcat.getServer().await();
    }
}
