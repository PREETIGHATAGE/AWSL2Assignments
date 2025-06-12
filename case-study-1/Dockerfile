# Use OpenJDK 17 slim image as base
FROM openjdk:17-jdk-slim

# Set working directory inside container
WORKDIR /app

# Copy built jar file into container
ARG JAR_FILE=target/currency-exchange-sample-service-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar

# Expose Spring Boot port
EXPOSE 8000

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
