FROM adoptopenjdk:8u242-b08-jdk-hotspot AS builder

WORKDIR /workdir/app
COPY .mvn   /workdir/app/.mvn
COPY pom.xml /workdir/app/pom.xml
COPY mvnw /workdir/app/mvnw
RUN ./mvnw dependency:go-offline

COPY src /workdir/app/src
RUN ./mvnw package

FROM adoptopenjdk:8u242-b08-jre-hotspot
COPY --from=builder /workdir/app/target/*.jar /app.jar
EXPOSE 8080

CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]