FROM openjdk:16.0.1-jdk-slim as builder
LABEL maintainer "sksat <sksat@sksat.net>"

ARG MINECRAFT_VERSION
ARG PAPER_VERSION
ARG PAPER_COMMIT

SHELL ["/bin/bash", "-c"]
RUN if [[ ${PAPER_VERSION} != "${MINECRAFT_VERSION}"* ]]; then echo "version mismatch!!!!"; exit 1; fi;

# Build PaperMC
WORKDIR /build
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y  git patch time
RUN git config --global user.name sksat && git config --global user.email sksat@sksat
RUN git clone https://github.com/PaperMC/Paper
RUN cd Paper && git checkout $PAPER_COMMIT

# version check
RUN diff <(echo $MINECRAFT_VERSION) <(cat Paper/gradle.properties | grep 'mcVersion =' | sed -e 's/mcVersion = //')
RUN diff <(echo $PAPER_VERSION) <(cat Paper/gradle.properties | grep 'version =' | sed -e 's/version = //')

RUN cd Paper && ./gradlew tasks
RUN cd Paper && time ./gradlew applyPatches && time ./gradlew paperclipJar

RUN find Paper | grep jar
RUN ls Paper/build/libs -lh
RUN cp Paper/build/libs/Paper-${PAPER_VERSION}.jar Paper/paperclip.jar

# Run
FROM adoptopenjdk/openjdk16:alpine-jre
WORKDIR /app
COPY --from=builder /build/Paper/paperclip.jar /bin/
COPY --from=builder /build/Paper/LICENSE.md /licenses/Paper/
COPY --from=builder /build/Paper/licenses /licenses/Paper/licenses
#RUN ls /licenses/Paper/licenses

CMD ["java", "-jar", "/bin/paperclip.jar"]
