FROM alpine:latest
LABEL maintainer="Juan Bautista Mesa Roldán <juan.mesa@hidup.io>"

ENV DIST_MIRROR http://archive.apache.org/dist/nifi
ENV VERSION 1.7.0

ENV NIFI_BACKUP=/opt/nifi-backup
ENV NIFI_TOOLKIT=/opt/nifi-toolkit
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

RUN apk --no-cache update
RUN apk --no-cache add tzdata dcron curl wget rsync ca-certificates bash curl openjdk8

RUN mkdir -p /var/log/cron
RUN mkdir -m 0644 -p /var/spool/cron/crontabs
RUN touch /var/log/cron/cron.log
RUN mkdir -m 0644 -p /etc/cron.d

RUN mkdir -p ${NIFI_BACKUP}
WORKDIR    ${NIFI_BACKUP}

RUN mkdir -p ${NIFI_TOOLKIT}
RUN curl ${DIST_MIRROR}/${VERSION}/nifi-toolkit-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_TOOLKIT}
RUN mv ${NIFI_TOOLKIT}/nifi-toolkit-${VERSION}/* ${NIFI_TOOLKIT}
RUN rm -rf ${NIFI_TOOLKIT}/nifi-toolkit-${VERSION}

COPY deploy/start.sh /
RUN chmod +x /start.sh

COPY deploy/backup.sh /
RUN chmod +x /backup.sh

ENTRYPOINT ["/start.sh"]
