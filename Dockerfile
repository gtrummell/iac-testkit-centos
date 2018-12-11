# Infrastructure-as-Code TestKit for Centos
#
# VERSION 7

FROM centos:7

ENV DEBIAN_FRONTEND=noninteractive

COPY requirements.txt requirements.txt

# hadolint ignore=DL3008
RUN yum erase -y -q docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine &&\
    yum-config-manager -y -q --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&\
    yum install -y -q \
        ansible \
        awscli \
        ca-certificates \
        curl \
        device-mapper-persistent-data \
        docker-ce \
        docker-ce-cli \
        docker-compose \
        gcc \
        gzip \
        jq \
        libffi-devel \
        libselinux-python \
        lvm2 \
        openssl-devel \
        python-devel \
        unzip \
        wget \
        yum-utils &&\
    yum upgrade -y -q &&\
    yum clean all -y -q &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/timezone &&\
    easy_install -q --upgrade pip &&\
    pip install --upgrade -qqq -r requirements.txt &&\
    wget -q -O terraform.zip https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip &&\
    unzip -o -qq terraform.zip -d /usr/bin/ &&\
    wget -q -O packer.zip https://releases.hashicorp.com/packer/1.3.2/packer_1.3.2_linux_amd64.zip &&\
    unzip -o -qq packer.zip -d /usr/bin/ &&\
    wget -q -O vault.zip https://releases.hashicorp.com/vault/1.0.0/vault_1.0.0_linux_amd64.zip &&\
    unzip -o -qq vault.zip -d /usr/bin/ &&\
    wget -q -O consul.zip https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip &&\
    unzip -o -qq consul.zip -d /usr/bin/ &&\
    wget -q -O /usr/bin/terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.13.13/terratest_log_parser_linux_amd64

ENTRYPOINT [ "/bin/bash", "-c" ]
