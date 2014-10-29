FROM ubuntu:14.04

MAINTAINER IPython Project <ipython-dev@scipy.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y 

# Python binary dependencies, developer tools
RUN apt-get install -y -q build-essential make gcc zlib1g-dev git && \
    apt-get install -y -q python python-dev python-pip python3-dev python3-pip && \
    apt-get install -y -q libzmq3-dev sqlite3 libsqlite3-dev pandoc libcurl4-openssl-dev nodejs nodejs-legacy npm

RUN pip install ipython[notebook]
