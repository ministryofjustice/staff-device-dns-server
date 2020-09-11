FROM alpine:3.12

EXPOSE 53 53/udp

RUN apk --update upgrade && apk add bind bind-tools bind-plugins

WORKDIR /home
RUN chown root:root /home

COPY test_named.conf named.conf
COPY ./bootstrap.sh ./bootstrap.sh

CMD ["./bootstrap.sh"]
