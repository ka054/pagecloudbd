## python-app-docker-demo
This demo shows two steps:
+ Install `docker-ce` on Centos 7 (if already installed then Jump to Build image part, Line number 48)
+ Build and run a simple docker image with a python+flask+gunicorn web application.

### Install docker-ce on Centos 7
Refer to https://docs.docker.com/engine/installation/linux/docker-ce/centos/
You can also find [other OS installation docs from here](https://docs.docker.com/engine/installation).

#### Uninstall old versions
```
#yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine
```

#### Install using repository
```
# yum install -y yum-utils device-mapper-persistent-data lvm2
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# yum install docker-ce
# systemctl start docker
# docker run hello-world
```

Other commands: 
+ check docker status 
```
# systemctl status docker.service
```

### Build/Run a simple python+flask docker web app 

#### Create the Dockerfile

```
FROM python:3.9-slim

## Creating Application Source Code Directory
RUN mkdir -p /usr/app

## Setting Home Directory for containers
WORKDIR /usr/app

## Installing python dependencies
COPY requirements.txt /usr/app/
RUN pip install --no-cache-dir -r requirements.txt

## Copying src code to Container
COPY  . /usr/app

## Application Environment variables
##ENV APP_ENV development
##ENV PORT 8080

## Exposing Ports
EXPOSE 8080

## Setting Persistent data
##VOLUME ["/app-data"]

## Running Python Application
CMD gunicorn -b :$8080 -c gunicorn.conf.py main:app
```

#### Build your image
Normally, image name convention is something like: `
{company/application-name}:{version-number}`. In the demo, I just use `{application-name}:{version-number}`

```
# docker build -t my-python-app:v1 .
```

#### check all docker images
```
# docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
my-python-app           v1                  2b628d11ba3a        22 minutes ago      701.6 MB
docker.io/python        2.7                 b1d5c2d7dda8        13 days ago         679.3 MB
docker.io/hello-world   latest              05a3bd381fc2        5 weeks ago         1.84 kB
```

`2b628d11ba3a` is the image ID, some commands based on the ID.

+ tag 
```
# docker tag my-python-app:v1 kaiserdevops/my-python-app:v1
```

#### Run your image
```
# docker run -d -p 8080:8080 my-python-app:v1
```


You can use `sudo docker ps` to list all running containers. 
```
# docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                    NAMES
4de6041072b7        my-python-app:1.0.1   "/bin/sh -c 'gunicorn"   20 minutes ago      Up 20 minutes       0.0.0.0:8080->8080/tcp   elegant_kowalevski
```

`4de6041072b7` is the running container id. Some commands below are what you might need.

+ display logs in running container
```
# docker logs container_ID
[2017-10-23 20:29:49 +0000] [7] [INFO] Starting gunicorn 19.6.0
[2017-10-23 20:29:49 +0000] [7] [INFO] Listening at: http://0.0.0.0:8080 (7)
[2017-10-23 20:29:49 +0000] [7] [INFO] Using worker: gthread
[2017-10-23 20:29:49 +0000] [11] [INFO] Booting worker with pid: 11
[2017-10-23 20:29:49 +0000] [12] [INFO] Booting worker with pid: 12

``
+ login inside the container
```
# docker exec -it container_ID /bin/sh
# ls /usr/app
Dockerfile  README.md  gunicorn.conf.py  gunicorn_pid.txt  main.py  main.pyc  requirements.txt
# exit
```

#### Test your application
```
# curl http://localhost:8080
Hello World, This is python appliction serving by gunicorn
```
#### Push application to github
```
# git init
# git commit -m "First Commit"
# git remote add origin https://github.com/ka054/pagecloudlab11.git
# git branch -M main (master)
# git push -u origin main (master)
