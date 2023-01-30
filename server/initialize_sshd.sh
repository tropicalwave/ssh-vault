#!/bin/bash
set -e

# Download public key of CA
curl -o /etc/ssh/trusted-user-ca-keys.pem "$VAULT_ADDR/v1/ssh-client-signer/public_key"

# Allow server-specific principals and root-everywhere
mkdir -p /etc/ssh/auth_principals
echo -e "${SERVERNAME}\nroot-everywhere" > /etc/ssh/auth_principals/root

# Login to Vault to be able to work with it
vault login -

# Acquire certificate for SSH host key
vault write -field=signed_key ssh-host-signer/sign/hostrole \
    cert_type=host \
    public_key=@/etc/ssh/ssh_host_rsa_key.pub > /etc/ssh/ssh_host_rsa_key-cert.pub

chmod 0640 /etc/ssh/ssh_host_rsa_key-cert.pub

cat >>/etc/ssh/sshd_config <<EOF
TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem
AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u
HostKey /etc/ssh/ssh_host_rsa_key
HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub
EOF

# Reload SSHd
systemctl reload sshd
