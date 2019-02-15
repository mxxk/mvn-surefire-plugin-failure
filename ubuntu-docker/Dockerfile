FROM adoptopenjdk/maven-openjdk11:latest
WORKDIR /app
COPY src ./src
COPY pom.xml .
CMD ["mvn", "test"]
