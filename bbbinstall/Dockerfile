################################
# BigBlueButton
#
# BASH script to install BigBlueButton in 15 minutes.

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Update the system
RUN apt-get update

# Update repo
RUN apt-get -y install curl sudo wget fakeroot lsb-release apt-utils
RUN wget -qO- https://raw.githubusercontent.com/laowangnj/mybase/master/bbbinstall/bbb-install.sh | bash -x -s -- -v xenial-220
