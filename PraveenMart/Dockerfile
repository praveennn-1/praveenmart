# Step 1: Build the WAR file using Maven
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY . .
RUN mvn clean package -DskipTests

# Step 2: Run the WAR file on Apache Tomcat
FROM tomcat:10-jdk17

COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD sed -i "s/port=\"8080\"/port=\"${PORT}\"/" /usr/local/tomcat/conf/server.xml && catalina.sh run
