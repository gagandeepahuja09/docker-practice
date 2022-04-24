Docker Compose
* Allows to start multiple containers at once.

Dockerfile
* To build our own docker image.

Volumes
* To persist data in docker.

Containers
* A way to package application with all the necessary dependencies & configuration.
* Portable => can be easily shared and moved around within teams.
* Make development, deployment, testing more efficient.

Where do containers live? 
* Container repository
    * Private repositories
    * Public repository for Docker => Dockerhub

How do containers improve the development process?
Before Containers
    * Installation process different on each environment.
    * Installation steps are very long(inefficient) and prone to human errors.

After Containers
    * None of the dependency is installed directly on our OS. Container uses its own isolated environment(linux based).
    * One command to install the app and remains the same irrespective of the OS.
    * Possible to run 2 diff version of app on the same local env.

How do containers improve the deployment process?
Before Containers
    * Developers will share a list of artifacts & installation steps for the application as well as all the involved services. Everything needs to be installed on the OS.
    * Lot of possibilities of misunderstandings.

After Containers
    * Developers and operations work together to package the application in a container.
    * No environmental configuration needed on server - except Docker runtime.


What is a container technically?
* A container is a layer of images stacked on top each other.
* Most have linux as base image because of small size. eg alpine based.
* docker run
    * it will first see if it can find the image locally. If not, it will pull the image from docker hub.
    * on running, you will see all the layers of images on which it is dependent along with their hashes which are getting downloaded.
    * the advanatage of the layer based approach is that if a different version of postgres image needs to be installed, only those images would need to be downloaded which are new or different or updated. Layers also help in parallelizing the process of image pull.

Different between docker image and docker container
* Docker image => It's the actual package that can be moved around.
* Container is the running environment for image.
* docker ps --> to get the container id

What is the difference between docker and VM?
* There are two main layers in the operating system: the OS Kernel layer which interacts with the hardware and the application layer which interacts with the OS kernel.
* All linux distributions, even though have the same OS kernel, their applications layer varies.
* Docker virtualizes the application layer. It uses the kernel of the host because it doesn't have its own kernel.
* VM has it's own application layer and kernel.
* Size: The size of docker images is much smaller because they have to implement just one layer. Docker images => MBs, Virtual Machines => GBs.
* Speed: Docker containers start and run much faster.
* Compatibility: VM of any OS can run on any OS host. Same is not true with docker.
    * A linux based docker image might not be compatible with a windows based docker kernel. This is true for older windows versions.
    * Workaround: docker toolbox. ==> abstracts the os kernel to make it possible to run different docker images.

Components of a container
* Application image: postgres, redis, mongo, ...
* Environment configs
* It also has a port binded to it to talk to the application running inside of container.
* The file system in a container is virtual. It has its own abstraction of the OS.

Docker Commands:
* docker images => list images, ps => list all running containers
* docker run -d redis => detached mode. => pull the image and start the container.
* docker stop container_id
* docker start container_id => start the stopped container.
* docker ps -a => list running and stopped containers.
* If we are running two different redis versions via docker, how do we ensure that there are no conflicts?

Container Post vs Host Port
* How does docker port binding work?
    https://betterprogramming.pub/how-does-docker-port-binding-work-b089f23ca4c8
    * Docker containers can connect to the outside world without any configuration.
    * But the outside world cannot connect to the docker container by default. 
* While running the docker ps command, we see the container port and not the host port. The host port has to be different else it would lead to a conflict.
* We can do the port binding via the -p flag in the docker run command.
    docker run -p hostPort:containerPort.
* After this, you'll be able to see the bindings when running docker ps.


Debugging a Container
* Logs: docker logs (container_id or container_name)
* Similar to container id, there is also container name which you can specify using --name while running docker run, else a random name gets assigned. 
* docker exec ==> get the terminal of a running container.
* docker exec -it(interactive terminal) container_id /bin/bash
    => inside the container as a root user ==> virtual file system.
    => can check all files, environment variables for debugging.
    => we might be limited in the commands we can run as these are very simple linux distributions. eg we won't be able to run curl command.
* docker run => images, docker start => container.

Demo Project - Software Development Workflow
* Development
* Continuous Integration/Continuous Delivery
* Deployment

Example:
1. Building a JS application. Install MongoDB via docker.
2. Commit the code.
3. Committed code will trigger a jenkins build or any other tool integrated for continuous integration.
4. CI will create a docker image.
5. The image is pushed to a private repository.
6. Dev server pulls both images and runs them. 


Docker Network
* In order to do the connection b/w mongo and mongo-express, we need to understand the concept of docker network.
* If we deploy 2 docker containers in the same network, they can talk to each other just using the container name.
* Applications from outside can connect to them via localhost:PORT_NUMBER.
* docker network ls => there would be some auto-generated networks.
* docker network create mongo-network

Steps for Developing the network and the containers
* Pull images of both mongo, mongo-express.
* Mongo network create.
* In order to make a container run in a network, we need to specify the network name while running the command.
* docker run -d \
    > -p 27017:27017 \
    > -e MONGO_INITDB_ROOT_USERNAME=admin \
    > -e MONGO_INITDB_ROOT_PASSWORD=password \
    > --name mongodb \
    > --net mongo-network \
    > mongo
* In mongo express, even if we specify the correct container name for mongodb, it won't work if it's not running in the same network.
* docker run -d \
    > -p 8081:8081 \
    > -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
    > -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
    > --net mongo-network \
    > --name mongo-express \
    > -e ME_CONFIG_MONGODB_SERVER=mongodb \
    > mongo-express
* docker logs container_name tail -f
* tail => last few logs
* -f => stream the logs

Docker Compose
* The above process can be automated via docker compose.
* version: '3'(latest version of docker-compose), services: is common in all docker files.
* services:
    mongodb // this is the container name specified via --name in docker run.
* Docker compose takes care of creating a common network.
    * docker-compose -f mongo.yaml up
    * up will start all the containers in mongo.yaml
* When running, logs of both the containers will be mixed as we are starting them at the same time in parallel.
* Mongo express will be waiting for mongo db to start.
* Creating network "docker-practice_default" with the default driver
    * Network automatically created.
* NOTE: The data when restarting the container is gone, there is no persistence by default.
* We can use docker volumes for data persistence between container restarts.
* To stop all the containers and remove the network, we can run:
    docker-compose -f mongo.yaml down

Building Docker Image

Creating Dockerfile
* In order to build the docker image, we need to copy the contents of the application. Could be via jar, war, bundle.js, executable file.
* Dockerfile is the blueprint for building images.
* Every Dockerfile starts with basing it on another image. If Node application, then it will be node. The first line will be => FROM NODE
* If we instead do it with a lower level image like alpine, then we'll have to install node ourselves.
* RUN => Execute any linux command in dockerfile
* RUN mkdir -p /home/app => the directory will be created inside the container. 
* COPY source destination => Copy the files from source in my local inside the container image.
    * RUN cp source destination => this would copy the source from the docker image to the destination which will also be the docker image.
* CMD => Executes an entrypoint linux command.
* There could be multiple RUN commands but only one entrypoint command which will start the server.
* Env variables can be specified in env files or docker compose or dockerfile.
* Env files is the most recommended one.
* If we go to hub.docker.com => node and click on any of the image tags, we can see the dockerfile for it.
* Instead of specifying loads of RUN commands you can specify a shell script to run via ENTRYPOINT command. ENTRYPOINT ["entrypoint.sh"]

Building Docker image using Dockerfile
* docker build -t(tag) go-app:1.0 .
    Output: successfully built image_id

* writing image sha256:3c3f8fb8cb88ec9f41f321f492f7004b8d96386bf0f883acfca2e28db0  0.0s
* naming to docker.io/library/go-app:1.0
* We'll be able to see our image go-app when running docker images.
* This image can then be pushed to a docker repository by a jenkins pipeline and a server can pull the image.
* Whenever we adjust the docker file, we need to rebuild the image.
* Delete image => docker rmi image_id
    * The container should be deleted first
    * Find the docker container 
        docker ps -a | grep go-app
        docker rm container_id
* docker: Error response from daemon: OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "/home/app/entrypoint.sh": permission denied: unknown. => fixed by chmod +x

* Error on running the image: 
    docker run go-app:1.0       
    standard_init_linux.go:228: exec user process caused: no such file or directory

* docker exec -it a70ce063f80a /bin/bash
    Some of the containers might not have bash installed. In that case use /bin/sh instead of /bin/bash.
    Error response from daemon: Container is not running
* env command will give us all the environment variables.


Docker private repository
* For pushing out built docker images.
* We'll use AWS ECR.(many more options available like nexus, digital ocean).
    ECR => Elastic Container Registry
* Docker login
    
Image Naming in Docker Repositories
* registryDomain/imageName:tag ==> eg. of registryDomain => c.rzp.io
* while downloading from dockerhub, it's actually a shorthand.
    docker pull mongo:4.2 means that behind the scenes 
        docker pull docker.io/library/mongo:4.2 will get fired.
* In AWS ECR:
    docker pull random-number.dkr.ecr.region-name.amazonaws.com/go-app:1.0
* Use docker tag to make a copy of the existing image and rename it so that it has the registryDomain. 
    docker tag go-app:1.0 random-number.dkr.ecr.region-name.amazonaws.com/go-app:1.0
* docker push registryDomain/imageName:tag
* Change in version
    1. docker build
    2. docker tag
    3. docker push