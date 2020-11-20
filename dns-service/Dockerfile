ARG ACCOUNT_ID
FROM ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/testing-alpine-image:latest

EXPOSE 53 53/udp

RUN apk --update upgrade && apk add bash bind bind-tools bind-plugins aws-cli
RUN apk add --update --no-cache --virtual deps g++ make openssl-dev bind-dev \
  && wget https://www.dns-oarc.net/files/dnsperf/dnsperf-2.3.4.tar.gz \
  && tar zxvf dnsperf-2.3.4.tar.gz \
  && cd dnsperf-2.3.4 \
  && sh configure \
  && make \
  && strip ./src/dnsperf ./src/resperf \
  && make install \
  && apk del deps \
  && rm -rf /dnsperf-2.3.4*

WORKDIR /home
RUN chown root:root /home

COPY ./bootstrap.sh ./bootstrap.sh

CMD ["./bootstrap.sh"]
