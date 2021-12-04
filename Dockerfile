FROM ubuntu

RUN apt-get update -y \
  && apt-get install -y curl zip unzip sudo tar tzdata openssh-server openssh-client \
  && apt-get clean \
  && rm -fr /var/lib/apt/lists/*

# timezone, ssh
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && sed -i '/pam_loginuid\.so/s/required/optional/' /etc/pam.d/sshd \
  && ssh-keygen -A \
  && mkdir /run/sshd

# create docker user
RUN useradd -m -d /home/docker -s /bin/bash -u 1000 -g 50 docker \
  && echo 'docker:tcuser' | chpasswd \
  && echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# install sdkman
USER 1000
WORKDIR /home/docker
RUN curl -s https://get.sdkman.io | bash
RUN /bin/bash -l -c "source /home/docker/.sdkman/bin/sdkman-init.sh;sdk install java;sdk install kotlin;sdk install gradle"

USER root
WORKDIR /root

CMD ["true"]