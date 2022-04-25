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

Targets And Metrics
Targets => Whatever a prometheus server is monitoring. It could be any of the following
    * Linux/Windows server
    * Apache server
    * Single application
    * Service like database

Metrics => Each target has units of monitoring.
    * Eg. CPU status, Memory/Disk space usage, Exceptions count, etc.
    * They have human readable text based format.
        It has TYPE, HELP attributes for increasing its readability.
        HELP => Metrics description.
        TYPE => 3 metric types
            1) Counter => how many times x happened. eg no of requests, no of exceptions, etc.
            2) Gauge => what is the current value of x now. can go both up and down. eg. CPU usage value, Disk space, etc.
            3) Histogram => For tracking how long something took or how big the size of a request was.

How does prometheus collect metrics from the target?
* Prom data retrieval worker pulls data from HTTP endpoints.
* Data must be pushed at hostadress/metrics.
* The data must be in a correct format that prometheus understands.
* Some services expose /metrics endpoint by default.

Exporter
1. Script or service that fetches metrics from the target.
2. Converts into a format that prometheus understands.
3. Exposes them at /metrics where prometheus data retrieval worker can scrape them.
    Prometheus has exporters for various different kinds of services.