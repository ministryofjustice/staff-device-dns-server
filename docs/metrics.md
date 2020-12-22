## Bind Statistics

[Enabling Statistics](https://bind9.readthedocs.io/en/latest/reference.html#the-statistics-file)

[API format](https://bind9.readthedocs.io/en/latest/reference.html#statschannels)

### server and resolver 

`curl localhost:8080/json/v1/server` 

[example](./stats/server_stats.json)

### zones 

`curl localhost:8080/json/v1/zones` 

[example](./stats/zones.json)

### traffic 

`curl localhost:8080/json/v1/traffic`

[example](./stats/traffic.json)

### network status and socket 

`curl localhost:8080/json/v1/net` 

[example](./stats/net.json)


## Metrics agent

The [metrics agent](../dns-service/metrics/) is written in Ruby and runs directly on the BIND9 container. It publishes custom metrics to Cloudwatch, which then acts as a data source for Grafana. Metrics are published every 10 seconds.
