################################
# BigBlueButton
#
# BASH script to install BigBlueButton in 15 minutes.

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Update the system
RUN apt-get update

# Update repo
RUN apt-get -y install curl sudo wget fakeroot lsb_release
RUN wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v xenial-220
RUN apt-get clean
