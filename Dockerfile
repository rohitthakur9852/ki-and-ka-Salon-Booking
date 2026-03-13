# Stage 1: Build the application
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml to download dependencies
COPY pom.xml .
# Download project dependencies (this step is cached unless pom.xml changes)
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src
# Build the application, skipping tests to speed up the build process
RUN mvn clean package -DskipTests

# Stage 2: Run the application
# Using a lightweight JRE image for the final runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built jar file from the build stage
COPY --from=build /app/target/salon-0.0.1-SNAPSHOT.jar app.jar

# Explicitly expose the port your application is running on 
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
