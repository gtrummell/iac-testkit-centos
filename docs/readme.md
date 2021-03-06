Infrastructure-as-Code Test Kit
===============================

[![Build Status](https://travis-ci.org/gtrummell/iac-testkit-centos.svg?branch=master)](https://travis-ci.org/gtrummell/iac-testkit-centos)

This repository contains code necessary to build a Docker container for use
with containerized testing of Infrastructure-as-Code.  This image mimics a
full-size Centos instance (i.e. EC2) and is pre-built with:
- Ansible roles with Molecule on Docker
- Ansible roles with Molecule on EC2 via Packer
- Terraform with Terratest
- AWSCLI
- JQ

How to use IAC TestKit for Centos
---------------------------------

The primary use for this code is via Docker/Dockerhub.  This container is
usually pre-built and available for use on Dockerhub as
gtrummell/iac-testkit-centos.  The following examples show how to use each
installed tool.

### Ansible

Ansible is pre-built into the image.  A simple smoke test for an Ansible
role can be run like as follows:

`docker run -it -v /my/ansible/repo:/etc/ansible --rm gtrummell/iac-testkit-centos:latest /usr/local/bin/ansible-playbook /etc/ansible/my-playbook.yml`
