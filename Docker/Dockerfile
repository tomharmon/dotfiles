FROM ubuntu:16.04

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y libbsd-dev && \
  apt-get install -y libc6-dbg gdb valgrind && \
  apt-get install -y pkg-config && \
  apt-get install -y libfuse-dev && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget time && \
  apt-get update -y && \
  rm -rf /var/lib/apt/lists/*

