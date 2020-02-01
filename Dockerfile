################################
# BigBlueButton
#

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Update repo
RUN apt-get update && apt-get -y install apt-transport-https curl wget sudo apt-utils lsb-release
RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
RUN apt-get update && apt-get -y install fakeroot openjdk-8-jdk-headless git sbt=1.2.7

ARG COMMON_VERSION=22

WORKDIR /bbb
RUN git clone https://github.com/bigbluebutton/bigbluebutton.git
COPY /bbb/bigbluebutton/bbb-common-message /bbb-common-message
RUN cd /bbb-common-message \
 && sed -i "s|\(version := \)\".*|\1\"$COMMON_VERSION\"|g" build.sbt \
 && echo 'publishTo := Some(Resolver.file("file",  new File(Path.userHome.absolutePath+"/.m2/repository")))' | tee -a build.sbt \
 && sbt compile \
 && sbt publish \
 && sbt publishLocal

COPY /bbb/bigbluebutton/akka-bbb-apps /akka-bbb-apps

RUN cd /akka-bbb-apps \
 && find -name build.sbt -exec sed -i "s|\(.*org.bigbluebutton.*bbb-common-message[^\"]*\"[ ]*%[ ]*\)\"[^\"]*\"\(.*\)|\1\"$COMMON_VERSION\"\2|g" {} \; \
 && sbt compile
RUN cd /akka-bbb-apps \
 && sbt debian:packageBin
