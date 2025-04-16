# Description

A java image that will download the application on Simple File Vault (https://github.com/foilen/simple_file_vault) and run it.

You can point to a specific version or a tag. If it is a tag and the previous files of the same version are already downloaded (if you keep the same volume between runs), it will not download them again.

# Build and test

```
./create-local-release.sh && \
docker run -ti --rm \
    -p 55447:55447 \
    -v /tmp/fdi-vault-java-test/:/app \
    -e VAULT_HOSTNAME=deploy.foilen.com \
    -e VAULT_NAMESPACE=test-vault-java \
    -e VAULT_VERSION=latest \
    -e VAULT_FILE=test-vault-java.jar \
    --name fdi-vault-java-test \
    fdi-vault-java:main-SNAPSHOT
```

# Available environment config and their defaults

- VAULT_HOSTNAME: The hostname where the vault is running
- VAULT_USER: The user to use to download from the vault (default: none for public vault)
- VAULT_PASSWORD: The password to use to download from the vault (default: none for public vault)
- VAULT_NAMESPACE: The namespace to use to download from the vault
- VAULT_VERSION: The version or tag to use
- VAULT_FILE: The file to download

# Usage

```
./create-local-release.sh

docker run -ti --rm \
    -v /tmp/fdi-vault-java-test/:/app \
    -p 8080:80 \
    -e VAULT_HOSTNAME=$VAULT_HOSTNAME \
    -e VAULT_USER=$VAULT_USER \
    -e VAULT_PASSWORD=$VAULT_PASSWORD \
    -e VAULT_NAMESPACE=xxxxxxxxx \
    -e VAULT_VERSION=xxxxxxxxx \
    -e VAULT_FILE=xxxxxxxxx.jar \
    --name fdi-vault-java-test \
    foilen/fdi-vault-java:latest
```
