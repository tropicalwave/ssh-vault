FROM centos:7
ARG VAULT_VERSION
RUN yum install -y unzip \
	openssh-clients
RUN curl -sO https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
	unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
	mv vault /usr/local/bin
COPY initialize_ca /root/initialize_ca
CMD sleep infinity
