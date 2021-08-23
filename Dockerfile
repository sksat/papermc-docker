FROM openjdk:16.0.2-jdk-slim as builder
LABEL maintainer "sksat <sksat@sksat.net>"

# Run
FROM adoptopenjdk/openjdk16:alpine-jre
WORKDIR /app
COPY Paper/paperclip.jar /bin/
COPY Paper/LICENSE.md /licenses/Paper/
COPY Paper/licenses /licenses/Paper/licenses
#RUN ls /licenses/Paper/licenses

CMD ["java", "-jar", "/bin/paperclip.jar"]
