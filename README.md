# Overview

This repository contains the Dockerfile to create the [BIND](https://www.isc.org/bind/) DNS server Docker image. The configuration for this server is managed in the [Admin Portal](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin).

This is a zone forwarding DNS server that doesn't resolve queries itself.
Any internal zones will forward to internal DNS servers for resolution and any public DNS requests will go to the [NCSC protective DNS service](https://www.ncsc.gov.uk/information/pdns).

- [Getting Started](./docs/getting-started.md)
- [Deploying](./docs/deploying.md)
- [Metrics](./docs/metrics.md)
- [Monitoring](./docs/monitoring.md)
- [Alerting](./docs/alerting.md)
- [Health Checks](./docs/health-checks.md)
