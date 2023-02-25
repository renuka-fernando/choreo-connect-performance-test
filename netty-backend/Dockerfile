FROM ubuntu:22.04

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# install JDK Dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales python-is-python3 \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION jdk-11.0.14+9

# install OpenJDK 8
RUN set -eux; \
    BINARY_URL='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u362-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u362b09.tar.gz'; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

# Verify Java installation
RUN echo Verifying install ... \
    && echo javac -version && javac -version \
    && echo java -version && java -version \
    && echo Complete.

COPY netty-http-echo-service-0.4.6-SNAPSHOT.jar /netty-http-echo-service-0.4.6-SNAPSHOT.jar
COPY netty-start.sh /netty-start.sh

# expose ports
EXPOSE 8688

ENTRYPOINT ["/netty-start.sh"]
