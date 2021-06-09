![shellcheck workflow](https://github.com/tropicalwave/ssh-vault/actions/workflows/shellcheck.yml/badge.svg)

# Vault and SSH keys self-service

## Big picture

This tutorial shows the use of SSH user key certificates with Vault
using docker-compose. This setup will then allow users to connect
to hosts via SSH based on their defined role in Vault.

## Overview

Four machines will configured:

1. Vault server
2. CA server (including SSH client, but this could also be used from any other host)
3. Web server (accepting logins for all global and web administrators)
3. Database server (accepting logins for all global and DB administrators)

Furthermore, three Vault users will be created (with the Vault password "pass"):
1. globaladmin (should be able to login on all hosts)
2. dbadmin (should only be able to login on host db)
3. webadmin (should only be able to login on host web)

## Initialization

The following commands need to be executed for this tutorial
```
docker-compose up -d --build
docker-compose logs vault | awk '/Token/ { print $NF }' >.vault-token
cat .vault-token | docker-compose exec -T ca /root/initialize_ca.sh
docker-compose exec -T web /root/initialize_sshd.sh
docker-compose exec -T db /root/initialize_sshd.sh
```

## User perspective

### Creating SSH key and a certificate

The following commands will allow you to log-in on the hosts web and db:
```
docker-compose exec ca /bin/bash
> vault login -method=userpass username=globaladmin password=pass
> vault write -field=signed_key ssh-client-signer/sign/itservice public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub
```

The following commands will allow you to log-in only to the host web:
```
docker-compose exec ca /bin/bash
> vault login -method=userpass username=webadmin password=pass
> vault write -field=signed_key ssh-client-signer/sign/webteam public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub
> ssh web
```

The following commands will allow you to log-in only to the host db:
```
docker-compose exec ca /bin/bash
> vault login -method=userpass username=dbadmin password=pass
> vault write -field=signed_key ssh-client-signer/sign/dbteam public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub
> ssh db
```

# Further reading

* https://abridge2devnull.com/posts/2018/05/leveraging-hashicorp-vaults-ssh-secrets-engine/
* https://engineering.fb.com/security/scalable-and-secure-access-with-ssh/
* https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates.html
