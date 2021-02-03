# Bind Statistics

Statistics need to be [enabled](https://bind9.readthedocs.io/en/latest/reference.html#the-statistics-file) in Bind 9.

[API format](https://bind9.readthedocs.io/en/latest/reference.html#statschannels)

## Server and resolver

`curl localhost:8080/json/v1/server`

[example](./stats/server_stats.json)

## Zones

`curl localhost:8080/json/v1/zones`

[example](./stats/zones.json)

## Traffic

`curl localhost:8080/json/v1/traffic`

[example](./stats/traffic.json)

## Network status and socket

`curl localhost:8080/json/v1/net`

[example](./stats/net.json)

## Metrics agent

The [metrics agent](../dns-service/metrics/) is written in Ruby and runs directly on the BIND9 container. It publishes custom metrics to Cloudwatch, which then acts as a data source for Grafana. Metrics are published every 10 seconds.
