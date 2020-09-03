FROM alpine:3.12

EXPOSE 53 53/udp

RUN apk --update upgrade && apk add bind bind-tools bind-plugins

COPY named.conf /etc/bind/

CMD ["/usr/sbin/named", "-f", "-g"]
