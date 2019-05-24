FROM ubuntu:18.04

ARG JENA_VERSION=3.9.0

ENV LANG=ja_JP.UTF-8
ENV HOME=/root
ENV JENA_HOME=${HOME}/.jena/apache-jena-${JENA_VERSION}
ENV PATH=${PATH}:$JENA_HOME/bin


RUN apt-get update \
  && apt-get install -y python3-dev python3-pip language-pack-ja-base language-pack-ja openjdk-11-jdk wget \
  && pip3 install rdflib \
  && locale-gen ja_JP.UTF-8 \
  && ln -s /bin/bash /usr/bin/bash \
  && mkdir -p ${JENA_HOME} \
  && wget -O - https://archive.apache.org/dist/jena/binaries/apache-jena-${JENA_VERSION}.tar.gz | tar zx -C ${JENA_HOME}/..

WORKDIR /root

