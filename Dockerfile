FROM quay.io/orgsync/flyway:1.0

# Install jq
RUN apt-get update \
  && apt-get install -y jq \
  && rm -rf /var/lib/apt/lists/*

COPY flyway-entrypoint.sh /usr/local/bin/flyway-entrypoint.sh

WORKDIR /code

ENTRYPOINT ["flyway-entrypoint.sh"]
CMD ["--help"]
