{{- define "create-tunnel-command" -}}
command: 
  - sh
  - -c
  - |
    #!/bin/bash
    
    set -o errexit
    set -o pipefail
    set -o nounset
    
    ACCOUNT_EMAIL="${ACCOUNT_EMAIL:-}"
    ACCOUNT_ID="${ACCOUNT_ID:-}"
    API_KEY="${API_KEY:-}"
    TUNNEL_NAME="${TUNNEL_NAME:-}"
    TUNNEL_SECRET_BASE64="${TUNNEL_SECRET_BASE64:-}"
    TUNNEL_CRED_FILE="${TUNNEL_CRED_FILE:-}"
    TUNNEL_ID="NotSetYet"
    
    API_ENDPOINT="https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/tunnels"
    
    create_tunnel() {
      curl -s -X POST \
        -H "Authorization: Bearer ${API_KEY}" \
        -H "Content-Type: application/json" ${API_ENDPOINT} \
        --data '{"name":"'${TUNNEL_NAME}'","tunnel_secret":"'${TUNNEL_SECRET_BASE64}'"}' \
        -o /tmp/out.json
    
      if jq -e '. | select(.id != null)' /tmp/out.json &>/dev/null
      then
        TUNNEL_ID=$(jq -r '.id' /tmp/out.json)
      else
        echo "ERR: Failed to create tunnel"
        cat /tmp/out.json
        exit 1
      fi
    }
    
    ## Does Tunnel already exist?
    
    curl -s -X GET \
      -H "Authorization: Bearer ${API_KEY}" \
      -H "Content-Type: application/json" \
      ${API_ENDPOINT}\?name=${TUNNEL_NAME}\&is_deleted=false \
      -o /tmp/getTunnel.json
    
    if jq -e '.[] | select(.id != null)' /tmp/getTunnel.json &>/dev/null
    then
      ## Yep, let's use the ID
      TUNNEL_ID=$(jq -r '.[].id' /tmp/getTunnel.json)
      echo "Found tunnel, using Tunnel ID ${TUNNEL_ID}"
    else
      ## Nope, let's create it
      echo "No Tunnel : ${TUNNEL_NAME} - Creating it..."
      create_tunnel
    fi
    
    jq -nc \
      --arg AccountTag $ACCOUNT_ID \
      --arg TunnelSecret $TUNNEL_SECRET_BASE64 \
      --arg TunnelID $TUNNEL_ID \
      --arg TunnelName $TUNNEL_NAME \
      '{"AccountTag": $AccountTag, "TunnelSecret": $TunnelSecret, "TunnelID": $TunnelID, "TunnelName": $TunnelName }' \
      > $TUNNEL_CRED_FILE
{{- end -}}
