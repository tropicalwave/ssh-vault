FROM rockylinux/rockylinux:8
RUN dnf install -y openssh-server openssh-clients && \
    dnf clean all
RUN rm -f /run/nologin
COPY initialize_sshd.sh /root/initialize_sshd.sh
CMD ["sleep","infinity"]
