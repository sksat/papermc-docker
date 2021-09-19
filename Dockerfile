FROM openjdk:16.0.2-jdk-slim as builder
LABEL maintainer "sksat <sksat@sksat.net>"

FROM alpine as mc-monitor
COPY utils/download-mc-monitor.sh .
RUN ./download-mc-monitor.sh
RUN cp ./mc-monitor/mc-monitor /bin/

# Run
FROM adoptopenjdk/openjdk16:alpine-jre
WORKDIR /app
COPY Paper/paperclip.jar /bin/
COPY Paper/LICENSE.md /licenses/Paper/
COPY Paper/licenses /licenses/Paper/licenses
#RUN ls /licenses/Paper/licenses

COPY --from=mc-monitor /bin/mc-monitor /bin/
RUN mc-monitor version

COPY health.sh /bin/

CMD ["java", "-jar", "/bin/paperclip.jar"]
HEALTHCHECK --start-period=1m --interval=10s --timeout=30s --retries=3 CMD /bin/health.sh
