# Overview

This repository contains the Dockerfile to create the [BIND](https://www.isc.org/bind/) DNS server Docker image. The configuration for this server is managed in the [Admin Portal](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin).

This is a zone forwarding DNS server that doesn't resolve queries itself.
Any internal zones will forward to internal DNS servers for resolution and any public DNS requests will go to the [NCSC protective DNS service](https://ncsc.gov.uk/information/pdns).

- [Getting Started](./documentation/getting-started.md)
- [Local Automated Testing](/documentation/automated-testing.md)
- [Deploying](./documentation/deploying.md)
- [Metrics](./documentation/metrics.md)
- [Monitoring](./documentation/monitoring.md)
- [Alerting](./documentation/alerting.md)
- [Health Checks](./documentation/health-checks.md)
- [Performance Testing](./documentation/performance-benchmarks.md)
