FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn package -DskipTests

FROM openjdk:8-jre
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/*.jar /opt/jars/

CMD java \
  -Dspring.config.location=/opt/config/config.yml \
  -jar /opt/jars/mongo-postgresql-streamer-0.0.1-SNAPSHOT.jar \
  --mappings=/opt/config/mappings.json