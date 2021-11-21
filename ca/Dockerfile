FROM rockylinux/rockylinux:8
ARG VAULT_VERSION
RUN dnf install -y unzip openssh-clients && \
    dnf clean all
RUN curl -sO https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
	unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
	mv vault /usr/local/bin
COPY initialize_ca.sh /root/initialize_ca.sh
CMD ["sleep","infinity"]
