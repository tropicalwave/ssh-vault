# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
FROM rockylinux/rockylinux:9
ARG VAULT_VERSION
RUN dnf install -y openssh-server openssh-clients unzip systemd && \
    dnf clean all
RUN curl -O "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" && \
    unzip "vault_${VAULT_VERSION}_linux_amd64.zip" && \
    mv vault /usr/bin && \
    rm "vault_${VAULT_VERSION}_linux_amd64.zip"
COPY initialize_sshd.sh /root/initialize_sshd.sh
CMD ["/usr/sbin/init"]
