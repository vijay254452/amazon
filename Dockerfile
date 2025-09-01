# Use JDK base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy jar from Maven target folder
COPY target/prime-clone-1.0.0.jar app.jar

# Expose port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
