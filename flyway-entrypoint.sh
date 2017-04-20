#! /bin/bash -e

function vault_token() {
  set -e

  echo "Attempting vault approle login: " \
    "VAULT_CONNECT=${VAULT_CONNECT}, " \
    "ROLE_ID=${VAULT_ROLE_ID:0:4}***, " \
    "SECRET_ID=${VAULT_SECRET_ID:0:4}***" >&2

  result=$(curl -fsS -X POST \
    -d "{\"role_id\": \"$VAULT_ROLE_ID\", \"secret_id\": \"$VAULT_SECRET_ID\"}" \
    $VAULT_CONNECT/v1/auth/approle/login)

   echo "$result" | jq -r '.auth.client_token'
}

function vault_db_lease() {
  set -e

  vault_path="$VAULT_CONNECT/v1/$VAULT_DB_PATH/creds/$VAULT_DB_ROLE"

  echo "Attempting to get vault lease: " \
    "VAULT_CONNECT=${vault_path}, " \
    "TOKEN=${token:0:4}***" >&2

  result=$(curl -fsS -X GET \
    -H "X-Vault-Token: $token" "$vault_path")

   echo "$result" | jq '.data'
}

token=$(vault_token)
creds=$(vault_db_lease)
username=$(echo $creds | jq -r '.username')
password=$(echo $creds | jq -r '.password')

echo "Running flyway for user ${username}" >&2
./flyway -user="$username" -password="$password" "$@"
