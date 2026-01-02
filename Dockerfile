# Build stage
FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /app
COPY pom.xml .
COPY settings.xml .
COPY src ./src
RUN mvn clean package -DskipTests -s settings.xml

# Run stage
FROM eclipse-temurin:8-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Install font libraries required by Aspose
RUN apt-get update && apt-get install -y libfreetype6 fontconfig fonts-dejavu && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
