FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Package into WAR without running tests
RUN mvn clean package -DskipTests

# Run inside Tomcat 9 (matches your pom.xml Tomcat dependency)
FROM tomcat:9.0-jdk17

# Remove default Tomcat apps to prevent conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy your war directly as the root application
COPY --from=build /app/target/PraveenMart.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]