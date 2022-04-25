* Kubernetes: Container orchestration tool.
* Helps us manage containerized applications in different cloud environments.

Features offered by orchestration tools:
1. High availability or no downtime.
2. Scalability.
3. Disaster recovery - backup and restore.


Main K8s Components

Node & Pod
Pod:
* Smallest unit of K8s.
* Abstration over container.
    * It creates a running environment on top of container.
    * Reason for abstraction
        * So that these containers can be replaced when needed.
        * We don't need to interact with the docker container and can directly interact with the kubernetes layer.
* It is meant to run exactly one container. Can run multiple containers inside one pod but usually it's only one container along with some side car or side service.
* Each pod has its own IP address. Kubernetes offers out-of-the-box virtual network.
* This IP address can be used for communication. It's not a public IP address.
* Pods are ephemeral(can die very easily). A new pod will get created in its place with a new IP address.
* This change in IP address can cause an issue and for that the service concept in K8s is used.

Service
* It's a permanent IP address that can be attached to each pod.
* The lifecycle of a pod and service are not connected.
* App should be accessible through browser through a public IP, so for that, we'll use an external service. 
* Something like DB shouldn't be open to external requests and hence we'll create an internal service.

Ingress 
* The external url should be in a human-readable format. This forwarding from url to ip address is done by ingress.

ConfigMap
* Generally URL for external services like DB is in the env variables.
* If we want to change this, we'll have to rebuild app -> push it to repo -> pull in pod -> restart.
* To simplify this, we can use ConfigMap to keep external configuration of our application.

Secret
* Component used to store secret data like credentials, certificates, etc.
* Stored in base64 encoding.
* ConfigMap and secret variables can be used as env variables/properties file.