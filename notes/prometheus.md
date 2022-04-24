* Prometheus was created to monitor highly dynamic container environments like kubernetes, docker swarm, etc.
* It can only be used in traditional, non-container infra.

Why use Prometheus?
* To constantly monitor all services.
* In case of cascading failures, rather than working backwards, we can create alerts for each services to identify which service caused the error.
* We can also identify the problem even before it occurs.
* Application metrics like memory, cpu usage spiking up.


Prometheus Architecture

* The main component of prometheus is the prometheus server. It has 3 components:
1. Time Series Database
    * stores all the metrics. eg Cpu usage, no of errors of specific kind.
2. Data Retrieval Worker
    * pulls all the metric data from various target sources(servers, services, etc).
    * it pushes them to the time series database.
3. HTTP Server
    * it accepts queries(promql) for the stored data.
    * it can be viewed through Prometheus UI / Grafana(data visualization tool).