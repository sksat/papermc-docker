ARG BASE_IMG="adoptopenjdk/openjdk16:alpine-jre"

FROM alpine as builder
LABEL maintainer "sksat <sksat@sksat.net>"

FROM alpine as mc-monitor
COPY utils/download-mc-monitor.sh .
RUN ./download-mc-monitor.sh
RUN cp ./mc-monitor/mc-monitor /bin/

# Run
#FROM adoptopenjdk/openjdk16:alpine-jre
#FROM openjdk:16.0.2-slim-buster
FROM ${BASE_IMG}
WORKDIR /app
COPY Paper/paperclip.jar /bin/
COPY Paper/LICENSE.md /licenses/Paper/
COPY Paper/licenses /licenses/Paper/licenses
#RUN ls /licenses/Paper/licenses

COPY --from=mc-monitor /bin/mc-monitor /bin/

COPY health.sh /bin/
COPY entrypoint.sh /bin/

ENTRYPOINT ["/bin/entrypoint.sh"]
HEALTHCHECK --start-period=10m --interval=20s --timeout=1m --retries=5 CMD /bin/health.sh
