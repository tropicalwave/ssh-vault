#!/bin/bash
set -e

# Download public key of CA
curl -o /etc/ssh/trusted-user-ca-keys.pem "$VAULT_ADDR/v1/ssh-client-signer/public_key"

# Let SSHd use CA file
echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" \
    >>/etc/ssh/sshd_config

# Let SSHd check for specific principals.
echo "AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u" \
    >>/etc/ssh/sshd_config

# Allow principals db and root-everywhere
mkdir /etc/ssh/auth_principals
echo -e 'db\nroot-everywhere' > /etc/ssh/auth_principals/root

# Create SSH host keys
ssh-keygen -A

# Start SSHd
/usr/sbin/sshd -p 22 -E /var/log/sshd.log
