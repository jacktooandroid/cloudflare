#!/bin/bash

#Code sourced from https://github.com/dcerisano/cloudflare-dynamic-dns, modified for personal use.

#Account Configurations
#API_TOKEN=** CF API Token **
#ZONE_ID=** CF Zone ID **
#DNS_CNAME_RECORD_1_NAME="Dynamic"
#DNS_CNAME_RECORD_1_ID=** CF CNAME Record 1 ID **
#DNS_CNAME_RECORD_2_NAME="Dynamic"
#DNS_CNAME_RECORD_2_ID=** CF CNAME Record 2 ID **
#DNS_CNAME_RECORD_CONTENT=** CF CNAME Record Content **

#Cloudflare CNAME Record 1
CLOUDFLARE_SUBMISSION_CNAME_RECORD_1=$(cat <<EOF
{    "type": "CNAME",
     "name": "$DNS_CNAME_RECORD_1_NAME",
     "content": "$DNS_CNAME_RECORD_CONTENT",
     "ttl": 1,
     "proxied": false    }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_CNAME_RECORD_1_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $API_TOKEN" \
     -d "$CLOUDFLARE_SUBMISSION_CNAME_RECORD_1"

#Cloudflare CNAME Record 2
CLOUDFLARE_SUBMISSION_CNAME_RECORD_2=$(cat <<EOF
{    "type": "CNAME",
     "name": "$DNS_CNAME_RECORD_2_NAME",
     "content": "$DNS_CNAME_RECORD_CONTENT",
     "ttl": 1,
     "proxied": false    }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_CNAME_RECORD_2_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $API_TOKEN" \
     -d "$CLOUDFLARE_SUBMISSION_CNAME_RECORD_2"

exit