ARG BASE_VERSION='18.04'
FROM ubuntu:${BASE_VERSION}

# upgrade & install, of course
ARG APT_UBUNTU_ARCHIVE='http://archive.ubuntu.com/ubuntu'
ARG APT_UBUNTU_SECURITY='http://security.ubuntu.com/ubuntu'
ARG APT_DOCKER_CE='https://download.docker.com/linux/ubuntu'
RUN set -xv; \
    sed "s@http://archive.ubuntu.com/ubuntu@${APT_UBUNTU_ARCHIVE}@g" -i /etc/apt/sources.list && \
    sed "s@http://security.ubuntu.com/ubuntu/@${APT_UBUNTU_SECURITY}@g" -i /etc/apt/sources.list && \
    apt-get update --fix-missing && \
    apt-get upgrade -y && \
    apt-get install -y \
        less vim wget curl htop build-essential \
        apt-transport-https ca-certificates \
        gnupg-agent software-properties-common \
        openssh-client openssh-server \
        net-tools dnsutils iproute2 iputils-ping traceroute \
        python python-pip python3 python3-pip \
        git zip unzip pigz \
        sudo locales bash-completion \
        iotop nload stress && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository --update \
        "deb [arch=amd64] ${APT_DOCKER_CE} \
        $(lsb_release -cs) \
        stable" && \
    apt-get install -y \
        docker-ce docker-ce-cli containerd.io && \
    sed "s@${APT_UBUNTU_ARCHIVE}@http://archive.ubuntu.com/ubuntu@g" -i /etc/apt/sources.list && \
    sed "s@${APT_UBUNTU_SECURITY}@http://security.ubuntu.com/ubuntu/@g" -i /etc/apt/sources.list && \
    sed "s@${APT_DOCKER_CE}@https://download.docker.com/linux/ubuntu@g" -i /etc/apt/sources.list && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8 && \
    curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    rm -rf /tmp/*

# create, user
RUN set -xv; \
    useradd --create-home --groups docker,sudo ubuntu && \
    printf 'ubuntu:ubuntu' | chpasswd && \
    chsh -s /bin/bash ubuntu && \
    printf '\nubuntu    ALL=(ALL:ALL) NOPASSWD:ALL\n' | tee -a /etc/sudoers && \
    printf "\nexport PS1='\[\e]0;\u@\h: \w\a\]\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '\n" >> /home/ubuntu/.profile && \
    rm -rf /tmp/*
WORKDIR /home/ubuntu
USER ubuntu

# install, brew & sdk
RUN set -xv; \
    git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew && \
    mkdir ~/.linuxbrew/bin && \
    ln -s ../Homebrew/bin/brew ~/.linuxbrew/bin && \
    printf '\neval $(~/.linuxbrew/bin/brew shellenv)\n' >> ~/.profile && \
    eval $(~/.linuxbrew/bin/brew shellenv) && brew help && \
    curl -s "https://get.sdkman.io" | bash && \
    rm -rf /tmp/*

# install, cloud utils
ARG PYPI_URL='https://pypi.org'
RUN set -xv; \
    pip3 install --trusted-host 192.168.56.107 \
        --index=${PYPI_URL}/pypi \
        --index-url=${PYPI_URL}/simple \
        --user awscli && \
    printf '\nsource $(which aws_bash_completer)\n' >> ~/.profile && \
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    mv -v /tmp/eksctl ~/.local/bin/ && \
    printf '\nsource <(eksctl completion bash)\n' >> ~/.profile && \
    KC_STABLE="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)" && \
    curl --silent --location "https://storage.googleapis.com/kubernetes-release/release/${KC_STABLE}/bin/linux/amd64/kubectl" > ~/.local/bin/kubectl && \
    chmod +x ~/.local/bin/kubectl && \
    printf '\nsource <(kubectl completion bash)\n' >> ~/.profile && \
    curl --silent --location https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz | tar xz --strip-components=1 -C /tmp && \
    mv -v /tmp/helm ~/.local/bin/ && \
    mv -v /tmp/tiller ~/.local/bin/ && \
    rm -rf /tmp/*

# entry, duh
COPY entrypoint.sh /
ENTRYPOINT /entrypoint.sh
CMD /bin/bash --login
