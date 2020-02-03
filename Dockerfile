################################
# BigBlueButton
#

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
# Update repo
RUN apt-get update && apt-get -y install apt-transport-https curl wget sudo apt-utils lsb-release
RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
RUN apt-get update && apt-get -y install fakeroot openjdk-8-jdk-headless git sbt=1.2.7

ARG COMMON_VERSION="0.0.20-SNAPSHOT"

WORKDIR /bbb
RUN git clone https://github.com/bigbluebutton/bigbluebutton.git

RUN cp -a ./bigbluebutton/bbb-common-message ./
RUN cd ./bbb-common-message
 && sbt compile \
 && sbt publish \
 && sbt publishLocal

RUN cp -a ./bigbluebutton/bbb-common-web ./
RUN cd ./bbb-common-web
 && sbt compile \
 && sbt publish \
 && sbt publishLocal

#RUN cp -a ./bigbluebutton/akka-bbb-apps ./
#RUN cd ./akka-bbb-apps && sbt compile
#RUN cd ./akka-bbb-apps && sbt debian:packageBin

#RUN cp -a ./bigbluebutton/bigbluebutton-web ./
#RUN cd ./akka-bbb-apps && sbt compile
#RUN cd ./akka-bbb-apps && sbt debian:packageBin
