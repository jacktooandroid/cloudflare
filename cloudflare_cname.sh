#!/bin/bash

#Code sourced from https://github.com/dcerisano/cloudflare-dynamic-dns, modified for personal use.

#Account Configurations
#API_TOKEN=** CF API Token **
#ZONE_ID=** CF Zone ID **
#DNS_CNAME_RECORD_NAME="Dynamic"
#DNS_CNAME_RECORD_ID=** CF CNAME Record ID **
#DNS_CNAME_RECORD_CONTENT=** CF CNAME Record Content **

CLOUDFLARE_SUBMISSION_CNAME_RECORD=$(cat <<EOF
{    "type": "CNAME",
     "name": "$DNS_CNAME_RECORD_NAME",
     "content": "$DNS_CNAME_RECORD_CONTENT",
     "ttl": 1,
     "proxied": false    }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_CNAME_RECORD_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $API_TOKEN" \
     -d "$CLOUDFLARE_SUBMISSION_CNAME_RECORD"

exit