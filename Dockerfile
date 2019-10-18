# Infrastructure-as-Code TestKit for Centos
#
# VERSION 7

FROM centos:7

ENV DEBIAN_FRONTEND=noninteractive

COPY requirements.txt requirements.txt

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
        curl \
        docker-ce \
        docker-compose \
        gcc \
        gzip \
        jq \
        python-devel \
        python-setuptools \
        unzip \
        wget \
        yum-utils &&\
    yum upgrade -y -q &&\
    yum clean all -y -q &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/timezone &&\
    easy_install -q --upgrade pip &&\
    pip install --ignore-installed --upgrade -qqq -r requirements.txt &&\
    wget -q -O terraform.zip https://releases.hashicorp.com/terraform/0.12.11/terraform_0.12.11_linux_amd64.zip &&\
    unzip -o -qq terraform.zip -d /usr/bin/ &&\
    wget -q -O packer.zip https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip &&\
    unzip -o -qq packer.zip -d /usr/bin/ &&\
    wget -q -O vault.zip https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip &&\
    unzip -o -qq vault.zip -d /usr/bin/ &&\
    wget -q -O consul.zip https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip &&\
    unzip -o -qq consul.zip -d /usr/bin/ &&\
    wget -q -O /usr/bin/terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.21.0/terratest_log_parser_linux_amd64

ENTRYPOINT [ "/bin/bash", "-c" ]
