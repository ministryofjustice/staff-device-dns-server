# Benchmarks

## DNS

ssh to corsham
run ```
echo "Running dnsperf..."
# -s DNS server address
# -d query file path
# -c number of clients
# -Q nuber of requests per second
# -t timmeout (seconds)
dnsperf -s dns \
        -d test_queryfile \
        -c 1 \
        -Q 10 \
        -t 15 > ./test_result
        ```

# Q = 1000 C = 1
```
dnsperf -s dns \
        -d 1k_test_queryfile \
        -c 1 \
        -Q 1000 \
        -t 2 \
        -l 300
```

```
Statistics:

  Queries sent:         300000
  Queries completed:    298991 (99.66%)
  Queries lost:         1009 (0.34%)

  Response codes:       NOERROR 210898 (70.54%), SERVFAIL 4394 (1.47%), NXDOMAIN 83699 (27.99%)
  Average packet size:  request 37, response 101
  Run time (s):         300.014971
  Queries per second:   996.586934

  Average Latency (s):  0.010422 (min 0.005613, max 1.986681)
  Latency StdDev (s):   0.051944
```

# Q = 10000 C = 1
```
dnsperf -s dns \
        -d 1k_test_queryfile \
        -c 1 \
        -Q 10000 \
        -t 2 \
        -l 300
```

```
Statistics:

  Queries sent:         2093154
  Queries completed:    2085454 (99.63%)
  Queries lost:         7700 (0.37%)

  Response codes:       NOERROR 1471482 (70.56%), SERVFAIL 29988 (1.44%), NXDOMAIN 583984 (28.00%)
  Average packet size:  request 37, response 101
  Run time (s):         301.763520
  Queries per second:   6910.888367

  Average Latency (s):  0.006962 (min 0.004236, max 1.998273)
  Latency StdDev (s):   0.030665
```

# Q = 1000 c = 2
```
dnsperf -s dns \
        -d 1k_test_queryfile \
        -c 2 \
        -Q 1000 \
        -t 2 \
        -l 300
```
```
Statistics:

  Queries sent:         300000
  Queries completed:    299060 (99.69%)
  Queries lost:         940 (0.31%)

  Response codes:       NOERROR 210890 (70.52%), SERVFAIL 4475 (1.50%), NXDOMAIN 83695 (27.99%)
  Average packet size:  request 37, response 101
  Run time (s):         300.941649
  Queries per second:   993.747462

  Average Latency (s):  0.009875 (min 0.004681, max 1.974171)
  Latency StdDev (s):   0.052271
```

# Q = 1000 c = 5
```
dnsperf -s dns \
        -d 1k_test_queryfile \
        -c 5 \
        -Q 1000 \
        -t 2 \
        -l 300
```


There is a Terraform module called `api_gateway_load_test` which is able to simulate a high volume of logs sent to the custom logging API.

By default, it is disabled, but it can be enabled by setting the `TF_VAR_enable_load_testing` variable to true.

This will cause a number of EC2 instances to be spun up, each of which will generate requests to the API Gateway for a short period of time.
The parameters for the load test can be configured in the [main terraform file](/main.tf) under the section `api_gateway_load_test`.

### Load Test Results 16th July 2020

The process used for this performance test was relatively simple. Leveraging a load testing tool and combining this with our infrastructure-as-code approach, we were able to simulate large throughput on the system from multiple machines.

[ArtilleryJS](https://artillery.io/) was the chosen load testing tool, which has a couple of key parameters used to define test runs: arrival rate, and duration. 

* Arrival rate describes the number of new requests that will be made by the tool each second.

* Duration describes the number of seconds that the test run will last for. 

An arrival rate of 5 requests per second, and a duration of 10 seconds results in 50 requests being made overall.

Artillery processes were run simultaneously on multiple EC2 T2-Micro instances. These are programatically created and destroyed using Terraform. The EC2 instances are enabled using a flag that is injected by the CI pipeline via an environment variable. 

One point worth noting is that Terraform is unable to bring all EC2 instances up instantly. This means that while Artillery is configured to perform a test run lasting 1 minute, the actual run time, across all instances, will last longer than this. 

The total number of requests in a run is the product of the Artillery arrival rate, Artillery duration, and the number of EC2 instances spun up. The requests will be spread across 5 or 10 minutes as AWS infrastructure is created, with a surge in the middle when the majority of the instances come online.

Two sets of tests were run: 

* Test A: Initial run of 500 client instances with an arrival rate of 60 requests per second for a duration of 60 seconds. This equates to a total of 1.8 million requests over the course of the test. The parameters were found to be close to the maximum that could be achieved using EC2 T2-Micro instances through prior experimentation.

* Test B: Second run of 100 client instances with an arrival rate of 40 requests per second for 60 seconds, equating to 240 thousand requests over the course of the test. This was estimated to be the maximum sustainable throughput achievable given the observed average execution time of the lambda, and a concurrency limit set to 100 (the default limit) of simultaneous lambda invocations.

### Results

#### API Gateway Requests and Latency

###### Test A:
![image alt text](images/performance_test/API_Gateway_Requests_and_Latency_A.png)

###### Test B:
![image alt text](images/performance_test/API_Gateway_Requests_and_Latency_B.png)


The above graphs show the time taken for the API gateway to process requests and add the logs that they contain to the queue. It’s interesting to note the initial latency on both test A and B. This is due to AWS automatically scaling to handle the increasing load. As the requests go above 1, the latency drops to between 1ms and 10ms over a 5-10 second period. Towards the end of the test there is a corresponding increase in latency.  During the load phase the highest latency is 25ms. The average latency during the spike is approximately 10ms which could be considered a normal baseline.

#### Age of the Oldest Message in the Queue

###### Test A:
![image alt text](images/performance_test/Age_of_the_Oldest_Message_in_the_Queue_A.png)

###### Test B:
![image alt text](images/performance_test/Age_of_the_Oldest_Message_in_the_Queue_B.png)

The above graphs indicate the length of time a message stays in the queue before being processed by a lambda. It serves as a good indicator of how the logging solution is performing. The age of the oldest message is expected to remain constant and low when there is sufficient capacity to handle all incoming messages as seen in *test B*. In *Test A* the average age of the oldest message was up to 25 seconds. This is because the lambdas that read messages from the queue reach the concurrency limit and are unable to process logs as soon as they arrive. This is acceptable for short spikes in demand, as the queue will eventually be cleared. If we see that the age of the oldest message is not returning to a constant number then it is an indicator that more capacity is needed in the system.

#### SQS Lambda Concurrent Executions

###### Test A:
![image alt text](images/performance_test/SQS_Lambda_Concurrent_Executions_A.png)

###### Test B:
![image alt text](images/performance_test/SQS_Lambda_Concurrent_Executions_B.png)

These charts show the number of concurrent lambda executions over the course of the tests. We can observe that both reach the concurrency limit of 100 (which is expected and desired behaviour - we always want to be processing as many messages in parallel as we can). It’s worth noting the difference in time between the two test runs however. Test A took significantly longer to process all the messages than in Test B. If there was no concurrency limit, we would expect both runs to take a similar amount of time (assuming test data could be generated fast enough).

### Messages Received and Sent on the Queue

###### Test A:
![image alt text](images/performance_test/Messages_Received_and_Sent_on_the_Queue_A.png)

###### Test B:
![image alt text](images/performance_test/Messages_Received_and_Sent_on_the_Queue_B.png)


These charts show the volume of messages arriving over the course of the tests. These match the number of requests hitting the API gateway for each test. The dip in the middle of Test A is due to limitations in how quickly Terraform  can create EC2 instances.

### Conclusion

Through testing, an approximate maximum sustained capacity for the logging system has been established.  In its current configuration it is able to 4k requests per second with a maximum latency of 25 milliseconds and no messages remaining on the queue for more than 1 second.

The system can handle significantly larger spikes of demand, but this can cause a backlog of messages that need to be processed. Monitoring the *approximate age of the oldest message* metric for the sqs queue for any sustained increases would alert us if the service became saturated.

Capacity can be tuned when production usage metrics exist. Calculations show that lambdas are able to process approximately 40 logs per second per concurrent instance. The concurrent cap can be adjusted as required.

## Syslog

There is a Terraform module called `syslog_load_test` which is able to simulate a high volume of logs sent to the Syslog endpoint.

By default, it is disabled, but it can be enabled by setting the `TF_VAR_enable_syslog_endpoint_load_test` variable to true in the buildspec.yml file.

When enabled, it will target the Development AWS account and will cause a number of EC2 load test instances to be spun up, each of which will simulate logs sent to the Syslog Network Load Balancer.
These logs are then distributed between the tasks (default 2) running in the ECS cluster.

The parameters for the load test can be configured in the [main terraform file](/main.tf) under the section `syslog_load_test` to increase or decrease the load on the service.

### Load Test Results 02 November 2020

The process used for this performance test was relatively simple. For this test Syslog messages were simulated with a Python script, executed with EC2 user data. Requests are sent over UDP to port 514.

The load test was focussed on the receiving endpoint and not the shipment of these messages, as the limits around Lambda are well understood from previous load tests.

Services that were tested:

- Network Load Balancer
- ECS Cluster

### Results

The traffic during the load test was ramped up to 400 requests per second at peak, and the effects on ECS can be seen in the image below. The test was unable to create enough load for the service to go down.

#### Network Load Balancer

![image alt text](images/syslog_performance_test/nlb.png)

#### ECS Cluster

![image alt text](images/syslog_performance_test/ecs.png)

### Conclusion

The ECS cluster for the Syslog service has auto scaling enabled, but enough load could not be generated to cause an auto scaling event.

The first limit that will be hit is the concurrent lambda executions on the Syslog Functionbeat Lambdas.
The current production request rate is around 70 per minute. The ECS service can accomodate at least 400 times the current load.
