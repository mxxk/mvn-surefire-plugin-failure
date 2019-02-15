FROM adoptopenjdk/openjdk11:jdk-11.0.2.9-alpine
RUN \
    wget http://ftp.wayne.edu/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -O mvn.tar.gz && \
    mkdir /opt/mvn && \
    tar --strip 1 -C /opt/mvn -xf mvn.tar.gz && \
    rm mvn.tar.gz
ENV PATH="/opt/mvn/bin:${PATH}"
WORKDIR /app
COPY src ./src
COPY pom.xml .
CMD ["mvn", "test"]
