FROM rockylinux/rockylinux:9
RUN dnf install -y openssh-server openssh-clients && \
    dnf clean all
COPY initialize_sshd.sh /root/initialize_sshd.sh
CMD ["/usr/sbin/init"]
