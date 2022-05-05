#!/bin/bash

#Code sourced from https://github.com/dcerisano/cloudflare-dynamic-dns, modified for personal use.

#Account Configurations
#API_TOKEN=** CF API Token **
#ZONE_ID=** CF Zone ID **
#DNS_A_RECORD_NAME="Dynamic"
#DNS_A_RECORD_ID=** CF A Record ID **
#DNS_AAAA_RECORD_ID=** CF AAAA Record ID **

### IPv4 / A Record
CLOUDFLARE_SUBMISSION_A_RECORD=$(cat <<EOF
{    "type": "A",
     "name": "$DNS_A_RECORD_NAME",
     "content": "0.0.0.0",
     "ttl": 1,
     "proxied": false    }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_A_RECORD_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $API_TOKEN" \
     -d "$CLOUDFLARE_SUBMISSION_A_RECORD"

### IPv6 / AAAA Record
DNS_AAAA_RECORD_NAME=$DNS_A_RECORD_NAME
CLOUDFLARE_SUBMISSION_AAAA_RECORD=$(cat <<EOF
{    "type": "AAAA",
     "name": "$DNS_AAAA_RECORD_NAME",
     "content": "::",
     "ttl": 1,
     "proxied": false }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_AAAA_RECORD_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $API_TOKEN" \
     -d "$CLOUDFLARE_SUBMISSION_AAAA_RECORD"

exit