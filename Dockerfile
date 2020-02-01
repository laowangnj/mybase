################################
# BigBlueButton
#

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Update repo

RUN echo "deb [trusted=yes] https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-get update
RUN apt-get -y install curl sudo wget fakeroot lsb-release apt-utils openjdk-8-jdk-headless git sbt=1.2.7

ARG COMMON_VERSION=22
WORKDIR /src
RUN git clone https://github.com/bigbluebutton/bigbluebutton.git bbb

WORKDIR /src/bbb/bbb-common-message
COPY . /bbb-common-message
RUN cd /bbb-common-message \
 && sed -i "s|\(version := \)\".*|\1\"$COMMON_VERSION\"|g" build.sbt \
 && echo 'publishTo := Some(Resolver.file("file",  new File(Path.userHome.absolutePath+"/.m2/repository")))' | tee -a build.sbt \
 && sbt compile \
 && sbt publish \
 && sbt publishLocal


WORKDIR /src/bbb/akka-bbb-apps
COPY . /akka-bbb-apps

RUN cd /akka-bbb-apps \
 && find -name build.sbt -exec sed -i "s|\(.*org.bigbluebutton.*bbb-common-message[^\"]*\"[ ]*%[ ]*\)\"[^\"]*\"\(.*\)|\1\"$COMMON_VERSION\"\2|g" {} \; \
 && sbt compile
RUN cd /akka-bbb-apps \
 && sbt debian:packageBin
