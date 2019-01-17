#use latest armv7hf compatible raspbian OS version from group resin.io as base image
FROM balenalib/armv7hf-debian:stretch

#enable building ARM container on x86 machinery on the web (comment out next line if built on Raspberry)
RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="netpi@hilscher.com" \
      version="V1.0.0" \
      description="IBM Watson IoT node.js"

#version
ENV HILSCHERNETPI_IBM_WATSONIOT_NODEJS 1.0.0

#copy files
COPY "./init.d/*" /etc/init.d/

RUN apt-get update \
    && apt-get install -y openssh-server \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && mkdir /var/run/sshd \
    && apt-get install git nano

#install node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -  \
    && apt-get install -y nodejs 

#install Watson IoT node.js client library
RUN npm config set unsafe-perm true \
    && npm install -g babel mocha \
    && git clone https://github.com/ibm-watson-iot/iot-nodejs \
    && cd /iot-nodejs \
    && npm install

# change default shell folder after login
RUN echo "cd /iot-nodejs/samples" >> /root/.bashrc
WORKDIR /iot-nodejs/samples

#remove package lists
RUN rm -rf /var/lib/apt/lists/*

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#SSH port
EXPOSE 22

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]
