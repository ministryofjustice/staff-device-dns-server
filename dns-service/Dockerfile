ARG SHARED_SERVICES_ACCOUNT_ID
FROM ${SHARED_SERVICES_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/dns:ruby-2-7-2-alpine3-12

ARG EXTRA_BUNDLE_CONFIG="without 'test'"

RUN apk --update upgrade && apk add bash bind bind-tools bind-plugins aws-cli less \
  && apk add --update --no-cache --virtual deps g++ make openssl-dev bind-dev \
  && wget https://www.dns-oarc.net/files/dnsperf/dnsperf-2.3.4.tar.gz \
  && tar zxvf dnsperf-2.3.4.tar.gz \
  && cd dnsperf-2.3.4 \
  && sh configure \
  && make \
  && strip ./src/dnsperf ./src/resperf \
  && make install \
  && rm -rf /dnsperf-2.3.4* \
  && chmod 644 /etc/bind/rndc.key

WORKDIR /home

COPY ./bootstrap.sh ./bootstrap.sh
COPY ./metrics ./metrics
COPY ./zones /etc/bind/zones

RUN cd metrics && \
  bundle config set no-cache 'true' ${EXTRA_BUNDLE_CONFIG} && \
  bundle install

RUN apk del deps

EXPOSE 53 53/udp

CMD ["./bootstrap.sh"]
