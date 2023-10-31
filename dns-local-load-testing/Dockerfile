FROM ubuntu:23.10

ARG EXTRA_BUNDLE_CONFIG="without 'test'"

RUN apt-get update && apt-get upgrade

RUN apt-get install -y libssl-dev libldns-dev libck-dev libnghttp2-dev

RUN apt-get install dnsperf

WORKDIR /home

COPY ./bootstrap.sh ./bootstrap.sh

EXPOSE 53/udp 53/tcp

CMD ["./bootstrap.sh"]
