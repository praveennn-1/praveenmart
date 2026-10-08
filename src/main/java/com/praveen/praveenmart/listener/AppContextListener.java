package com.praveen.praveenmart.listener;

import com.praveen.praveenmart.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger logger = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Initializing PraveenMart application context...");
        try {
            DBUtil.initDataSource();
            sce.getServletContext().setAttribute("dataSource", DBUtil.getDataSource());
            logger.info("PraveenMart application context initialized successfully.");
        } catch (Exception e) {
            logger.error("Failed to initialize database connection pool on startup", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Shutting down PraveenMart application context...");
        DBUtil.shutdown();
        logger.info("PraveenMart application context destroyed.");
    }
}
