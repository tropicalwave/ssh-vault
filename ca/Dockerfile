# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
FROM rockylinux/rockylinux:10
ARG VAULT_VERSION
RUN dnf install -y unzip openssh-clients systemd && \
    dnf clean all
RUN curl -sO https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
	unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
	mv vault /usr/local/bin
COPY initialize_ca.sh /root/initialize_ca.sh
CMD ["/usr/sbin/init"]
