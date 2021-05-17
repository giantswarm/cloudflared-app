{{- define "clean+delete-argo-tunnel-command" -}}
command:
  - sh
  - -c
  - |
    #!/bin/bash

    set -o errexit
    set -o pipefail
    set -o nounset

    ACCOUNT_ID="${ACCOUNT_ID:-}"
    API_KEY="${API_KEY:-}"
    TUNNEL_NAME="NotSetYet"
    TUNNEL_ID="NotSetYet"

    API_ENDPOINT="https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/tunnels"

    set_tunnel_id() {
      curl -s -X GET \
        -H "Authorization: Bearer ${API_KEY}" \
        -H "Content-Type: application/json" \
        ${API_ENDPOINT}\?name=${TUNNEL_NAME}\&is_deleted=false \
        -o /tmp/getTunnel.json

      if jq -e '.[] | select(.id != null)' /tmp/getTunnel.json &>/dev/null
      then
        TUNNEL_ID=$(jq -r '.[].id' /tmp/getTunnel.json)
        echo "Found tunnel, using Tunnel ID ${TUNNEL_ID}"
      else
        echo "ERR: No Tunnel : ${TUNNEL_NAME}"
        exit 1
      fi
    }

    clean_delete_tunnel() {
      curl -s -X DELETE \
        -H "Authorization: Bearer ${API_KEY}" \
        -H "Content-Type: application/json" \
        ${API_ENDPOINT}/${TUNNEL_ID}/connections \
        -o /tmp/cleanTunnel.json

      curl -s -X DELETE \
        -H "Authorization: Bearer ${API_KEY}" \
        -H "Content-Type: application/json" \
        ${API_ENDPOINT}/${TUNNEL_ID}
    }

    set_tunnel_id
    clean_delete_tunnel
{{- end -}}
