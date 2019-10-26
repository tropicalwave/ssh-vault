FROM centos:7
ARG VAULT_VERSION
RUN yum install -y openssh-server openssh-clients
COPY initialize_sshd /root/initialize_sshd
CMD sleep infinity
