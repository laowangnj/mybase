################################
# BigBlueButton
#

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
# Update repo
RUN apt-get update && apt-get -y install apt-transport-https curl wget sudo apt-utils lsb-release
RUN wget https://static-meteor.netdna-ssl.com/packages-bootstrap/1.9.3/meteor-bootstrap-os.linux.x86_64.tar.gz
