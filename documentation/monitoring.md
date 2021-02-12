# Monitoring

DNS uses grafana as a way to display metrics. The grafana dashboard can be found [here](https://monitoring-alerting.staff.service.justice.gov.uk/d/tm5gLH1Gz/bind-dns-metrics?orgId=1)

The JSON that makes up the dashboard is stored in the [IMA dashboard configuration repo](https://github.com/ministryofjustice/staff-infrastructure-monitoring-config), when updates are made in the dashboard, the JSON needs to be saved and tracked with version control. More information around this can be found in the documenation in IMA repo.

The metrics categories are:

- AWS
- Custom DNS

The dashboard can be logically seperated into three parts:
## Panel breakdown (title placeholder)

### Alarms

![alarms](./images/alarms_panel.png)

The alarms section summaries the state of the system and categorieses them as OK, Pending or Alerting.

- OK is a sign that the system is operating normaly

- Pending indicates that the system may, over a given period, be ethier recovering or erroring

- Alerting shows that the system needs attention

### AWS

![aws](./images/aws_panel.png)

The AWS section displays all the relevant metrics to AWS. These include:

- [ECS Task Count](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cloudwatch-metrics.html)
- [NLB ProccessBytes](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-cloudwatch-metrics.html)
- [UnHealthyHostCount](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-cloudwatch-metrics.html)
- [ECS MemoryUtilization and CPUUtilization](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cloudwatch-metrics.html)

### Custom DNS

![custom_dns](./images/custom_panel.png)

The Custom section displays all DNS metrics output by [BIND](https://bind9.readthedocs.io/en/latest/reference.html#bind-9-statistics)

These

