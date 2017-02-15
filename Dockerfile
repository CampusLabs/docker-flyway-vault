FROM quay.io/orgsync/flyway:1.0

ENV VAULT_VERSION=0.6.2
ENV VAULT_DIR=/vault

RUN mkdir $VAULT_DIR && \
  cd $VAULT_DIR && \
  wget -O vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
  unzip vault.zip && \
  mv vault /usr/local/bin && \
  rm -rf $VAULT_DIR

ENTRYPOINT ["/bin/bash"]
