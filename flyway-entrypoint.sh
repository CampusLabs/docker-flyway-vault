#! /bin/bash -e

function vault_token() {
  curl --fail --silent -X POST \
    -d "{\"role_id\": \"$VAULT_ROLE_ID\", \"secret_id\": \"$VAULT_SECRET_ID\"}" \
    $VAULT_CONNECT/v1/auth/approle/login \
    | jq -r '.auth.client_token'
}

function vault_db_lease {
  local default='{}'
  local secret=$(curl --fail --silent -X GET \
    -H "X-Vault-Token: $token" "$VAULT_CONNECT/v1/$VAULT_DB_PATH/creds/$VAULT_DB_ROLE" \
    | jq '.data')

  echo ${secret:-$default}
}

token=$(vault_token)
creds=$(vault_db_lease)
username=$(echo $creds | jq -r '.username')
password=$(echo $creds | jq -r '.password')

./flyway -user="$username" -password="$password" "$@"
