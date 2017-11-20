Docker
======
The following instructions can be used with the given [Dockerfile](./Dockerfile "Dockerfile")

### In order to build a docker image:
docker build -t <desired image name> .

### In order to run a docker image:
docker run -it -v <local path to cs3650 directory>:<desired path on container> <desired image name>

