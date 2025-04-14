FROM maven:3.9.9-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-alpine
WORKDIR /app

ARG EVENT_SERVICE_URL
ARG LOG_SERVICE_URL
ARG NOTIFICATION_SERVICE_URL

ENV EVENT_SERVICE_URL=${EVENT_SERVICE_URL}
ENV LOG_SERVICE_URL=${LOG_SERVICE_URL}
ENV NOTIFICATION_SERVICE_URL=${NOTIFICATION_SERVICE_URL}

LABEL org.opencontainers.image.visibility=public

COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/app.jar"]