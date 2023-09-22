FROM ubuntu:22.04
LABEL maintainer="Li-Yu Lin <liyu8561501@gmail.com>"

# environment
ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
ENV XDG_RUNTIME_DIR=/tmp/runtime-docker
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV GZ_PARTITION=px4_gz
ENV TERM=xterm-256color
ENV DISPLAY=:20
ENV PATH="/home/user/bin:${PATH}"

# Set default shell during Docker image build to bash
SHELL ["/bin/bash", "-l", "-c"]

# Copy docker clean script
COPY install/docker_clean.sh /docker_clean.sh
RUN chmod +x /docker_clean.sh

# Install base packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
	apt-get -y upgrade && \
	apt-get install --no-install-recommends -y \
		sudo \
		locales \
		&& \
	/docker_clean.sh

# Initialise system locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Create a user to make sure install works without root
ARG UID_INSTALLER=2001
RUN useradd -l -u $UID_INSTALLER installer -G sudo,plugdev && \
 echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER installer

# install dependencies using scripts in a manner that will cache build
# when one script is modified
COPY install/base.sh /tmp/install/base.sh
RUN bash /tmp/install/base.sh && /docker_clean.sh

COPY install/ros.sh /tmp/install/ros.sh
RUN bash /tmp/install/ros.sh && /docker_clean.sh

COPY install/gazebo.sh /tmp/install/gazebo.sh
RUN bash /tmp/install/gazebo.sh && /docker_clean.sh

# COPY install/ros_gz.sh /tmp/install/ros_gz.sh
# RUN /tmp/install/ros_gz.sh && /docker_clean.sh

# add groups before we do anything that might add a new group
ARG GID_INPUT=107
ARG GID_RENDER=110
RUN sudo groupadd -r -g $GID_INPUT input && \
 sudo groupadd -r -g $GID_RENDER render

COPY install/latex.sh /tmp/install/latex.sh
RUN bash /tmp/install/latex.sh && /docker_clean.sh

COPY install/extra.sh /tmp/install/extra.sh
RUN bash /tmp/install/extra.sh && /docker_clean.sh

# enable apt auto-completion by deleting autoclean task
RUN sudo rm /etc/apt/apt.conf.d/docker-clean

# create XDG runtime dir
RUN mkdir /tmp/runtime-docker && sudo chmod 700 /tmp/runtime-docker

# create a user for running the container
ARG UID_USER=1000
RUN sudo useradd --create-home -l -u $UID_USER -G sudo,plugdev,render,input,video user && \
 echo user: $UID_USER
USER user

COPY install/user_setup.sh /tmp/install/user_setup.sh
RUN /tmp/install/user_setup.sh && /docker_clean.sh

# create setting directory for gazebo
VOLUME /home/user/.gz
RUN mkdir -p /home/user/.gz && \
  chown -R user:user /home/user/.gz

# create ws, this is where the source code will be mounted
VOLUME /home/user/work
WORKDIR /home/user/work
RUN mkdir -p /home/user/work

COPY install/px4_setup.sh /home/user/px4_setup.sh
RUN bash /home/user/px4_setup.sh && rm /home/user/px4_setup.sh

# setup entry point
COPY install/entrypoint.sh /
RUN sudo chmod +x /entrypoint.sh
RUN sudo chsh -s /bin/bash user

USER root

CMD ["/bin/bash"]
ENTRYPOINT ["/entrypoint.sh"]

# LABEL org.opencontainers.image.source = "https://github.com/CogniPilot/docker"

# vim: set et fenc=utf-8 ff=unix ft=dockerfile sts=0 sw=2 ts=2 :
