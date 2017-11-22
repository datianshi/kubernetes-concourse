FROM ubuntu:14.04
MAINTAINER Shaozhen Ding version: 0.1
RUN apt-get update
RUN apt-get install openssh-client -y
COPY init-key.sh /usr/bin/init-key
ENTRYPOINT  ["init-key"]
CMD []
