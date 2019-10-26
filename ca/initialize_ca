#!/bin/bash
set -e

# Create User CA key
ssh-keygen -f /root/user_ca -N "" >/dev/null

# Login to Vault to be able to work with it
vault login -

# Enable SSH engine
vault secrets enable -path=ssh-client-signer ssh

# Provide User CA keys. An alternative would be the use
# of generate_signing_key=true, ie:
# vault write ssh-client-signer/config/ca generate_signing_key=true
vault write ssh-client-signer/config/ca \
    private_key=@/root/user_ca \
    public_key=@/root/user_ca.pub

vault write ssh-client-signer/roles/itservice -<<"EOF"
{
  "allow_user_certificates": true,
  "allowed_users": "root-everywhere",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "valid_principals": "root-everywhere",
  "key_type": "ca",
  "default_user": "root-everywhere",
  "ttl": "30m0s",
  "max_ttl": "30m0s",
  "allow_user_key_ids": "false"
}
EOF

vault write ssh-client-signer/roles/dbteam -<<"EOF"
{
  "allow_user_certificates": true,
  "allowed_users": "db",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "valid_principals": "db",
  "key_type": "ca",
  "default_user": "db",
  "ttl": "30m0s",
  "max_ttl": "30m0s",
  "allow_user_key_ids": "false"
}
EOF

vault write ssh-client-signer/roles/webteam -<<"EOF"
{
  "allow_user_certificates": true,
  "allowed_users": "web",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "valid_principals": "web",
  "key_type": "ca",
  "default_user": "web",
  "ttl": "30m0s",
  "max_ttl": "30m0s",
  "allow_user_key_ids": "false"
}
EOF

# Create some ordinary Vault users and attach policies to them.
vault auth enable userpass
vault write auth/userpass/users/globaladmin \
    password=pass \
    policies=its-policy

vault write auth/userpass/users/dbadmin \
    password=pass \
    policies=dbadmin-policy

vault write auth/userpass/users/webadmin \
    password=pass \
    policies=webadmin-policy

echo 'path "ssh-client-signer/sign/itservice" { capabilities = [ "create", "update"] }' | \
    vault policy write its-policy -

echo 'path "ssh-client-signer/sign/dbteam" { capabilities = [ "create", "update"] }' | \
    vault policy write dbadmin-policy -

echo 'path "ssh-client-signer/sign/webteam" { capabilities = [ "create", "update"] }' | \
    vault policy write webadmin-policy -

# Initialize SSH key for root user (just for convenience)
ssh-keygen -f /root/.ssh/id_rsa -N ""
