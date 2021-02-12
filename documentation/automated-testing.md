# Automated Testing

To run the tests locally run

```bash
$ make test
```

This will create 2 containers:

1. A [DNS server](https://www.isc.org/bind/)
1. A DNS client. [DNSPerf](https://www.dnsperf.com/) is installed, to look up domains and ensure that the server is functioning as expected.
