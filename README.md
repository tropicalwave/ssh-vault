# Vault and SSH keys self-service

[![GitHub Super-Linter](https://github.com/tropicalwave/ssh-vault/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

## Big picture

This tutorial shows the use of SSH user key certificates with Vault
using podman-compose. This setup will then allow users to connect
via SSH to hosts based on their defined role in Vault.

The servers furthermore use SSH host key certificates (set up
with Vault), ie. there is no need to verify the keys manually at
login time.

## Overview

![Architecture](/images/architecture.svg)

Four machines will configured:

1. Vault server
2. CA server (including SSH client, but this could also be used from any other host)
3. Web server (accepting logins for all global and web administrators)
4. Database server (accepting logins for all global and DB administrators)

Furthermore, three Vault users will be created (with the Vault password "pass"):

1. globaladmin (should be able to login on all hosts)
2. dbadmin (should only be able to login on host db)
3. webadmin (should only be able to login on host web)

## Initialization

The following commands need to be executed for this tutorial

```bash
podman-compose up -d --build
podman-compose logs vault | awk '/Token/ { print $NF }' >.vault-token
cat .vault-token | podman-compose exec -T ca /root/initialize_ca.sh
cat .vault-token | podman-compose exec -T web /root/initialize_sshd.sh
cat .vault-token | podman-compose exec -T db /root/initialize_sshd.sh
```

## User perspective

### Creating SSH key and a certificate

The following commands will allow you to log-in on the hosts web and db:

```bash
podman-compose exec ca /bin/bash
> vault login -method=userpass username=globaladmin password=pass
> vault write -field=signed_key ssh-client-signer/sign/itservice public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub
> ssh ...
```

The following commands will allow you to log-in only to the host web:

```bash
podman-compose exec ca /bin/bash
> vault login -method=userpass username=webadmin password=pass
> vault write -field=signed_key ssh-client-signer/sign/webteam public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub
> ssh web
```

The following commands will allow you to log-in only to the host db:

```bash
podman-compose exec ca /bin/bash
> vault login -method=userpass username=dbadmin password=pass
> vault write -field=signed_key ssh-client-signer/sign/dbteam public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub
> ssh db
```

## Further reading

- <https://abridge2devnull.com/posts/2018/05/leveraging-hashicorp-vaults-ssh-secrets-engine/>
- <https://engineering.fb.com/security/scalable-and-secure-access-with-ssh/>
- <https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates>
