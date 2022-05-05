#!/bin/bash

#Code sourced from https://github.com/dcerisano/cloudflare-dynamic-dns, modified for personal use.

#Account Configurations
#API_TOKEN=** CF API Token **
#ZONE_ID=** CF Zone ID **
#DNS_A_RECORD_NAME="Dynamic"
#DNS_A_RECORD_ID=** CF A Record ID **
#DNS_AAAA_RECORD_ID=** CF AAAA Record ID **

### IPv4 / A Record
# Retrieve the last recorded public IP address
IPV4_RECORD="/tmp/ipv4-record-vpn"
RECORDED_IPV4=`cat $IPV4_RECORD`

# Fetch the current public IPv4 address
PUBLIC_IPV4=$(curl -4 http://www.ident.me/)

if [ "$PUBLIC_IPV4" = "$RECORDED_IPV4" ]
    then
        echo "There is no change in the IPv4 Address, no request submmited."
    else
        echo $PUBLIC_IPV4 > $IPV4_RECORD
        CLOUDFLARE_SUBMISSION_A_RECORD=$(cat <<EOF
        {   "type": "A",
            "name": "$DNS_A_RECORD_NAME",
            "content": "$PUBLIC_IPV4",
            "ttl": 1,
            "proxied": false   }
EOF
        )
        curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_A_RECORD_ID" \
            -X PUT \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $API_TOKEN" \
            -d "$CLOUDFLARE_SUBMISSION_A_RECORD"
fi

### IPv6 / AAAA Record
DNS_AAAA_RECORD_NAME=$DNS_A_RECORD_NAME
# Retrieve the last recorded public IP address
IPV6_RECORD="/tmp/ipv6-record-vpn"
RECORDED_IPV6=`cat $IPV6_RECORD`

# Fetch the current public IPv6 address
PUBLIC_IPV6=$(curl -6 http://www.ident.me/)

if [ "$PUBLIC_IPV6" = "$RECORDED_IPV6" ]
    then
        echo "There is no change in the IPv6 Address, no request submmited."
    else
        echo $PUBLIC_IPV6 > $IPV6_RECORD
        CLOUDFLARE_SUBMISSION_AAAA_RECORD=$(cat <<EOF
        {   "type": "AAAA",
            "name": "$DNS_AAAA_RECORD_NAME",
            "content": "$PUBLIC_IPV6",
            "ttl": 1,
            "proxied": false   }
EOF
        )
        curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_AAAA_RECORD_ID" \
            -X PUT \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $API_TOKEN" \
            -d "$CLOUDFLARE_SUBMISSION_AAAA_RECORD"
fi

exit