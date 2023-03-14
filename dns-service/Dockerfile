FROM ruby:3.2.1-alpine3.16

ARG EXTRA_BUNDLE_CONFIG="without 'test'"

RUN apk --update upgrade && apk add bash bind bind-tools bind-plugins aws-cli less \
  && apk add --update --no-cache --virtual deps g++ make openssl-dev bind-dev \
  && chmod 644 /etc/bind/rndc.key

WORKDIR /home

COPY ./bootstrap.sh ./bootstrap.sh
COPY ./metrics ./metrics
COPY ./zones /etc/bind/zones

RUN cd metrics && \
  bundle config set no-cache 'true' ${EXTRA_BUNDLE_CONFIG} && \
  bundle install

RUN apk del deps

EXPOSE 53/udp 53/tcp

CMD ["./bootstrap.sh"]
