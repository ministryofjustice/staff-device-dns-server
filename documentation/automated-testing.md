# Automated Testing

To run the tests locally run

```bash
$ make test
```

This will spin up 2 containers, one acting as a DNS client and one as the [DNS server](https://www.isc.org/bind/).
[DNSPerf](https://www.dnsperf.com/) is installed on the client container and is used to look up domains and ensure that the server is functioning as expected.
