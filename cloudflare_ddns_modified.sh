#!/bin/bash

#Original Author: https://github.com/dcerisano/cloudflare-dynamic-dns
#Modified for personal use.

#Account Configurations
#AUTH_EMAIL=example@example.com
#AUTH_KEY=** CF Authorization  key **
#ZONE_ID=** CF Zone ID **
#A_RECORD_NAME="Dynamic"
#A_RECORD_ID=** CF A-record ID **
#AAAA_RECORD_ID=** CF AAAA-record ID **

#IPv4
# Retrieve the last recorded public IP address
IPv4_RECORD="/tmp/ipv4-record"
RECORDED_IPv4=`cat $IPv4_RECORD`

# Fetch the current public IP address
PUBLIC_IPv4=$(curl --silent https://v4.ident.me/) || exit 1

#If the public ip has not changed, nothing needs to be done, exit.
if [ "$PUBLIC_IPv4" = "$RECORDED_IPv4" ]
    then
        echo $PUBLIC_IPv4 > $IPv4_RECORD
        #IPv6
        AAAA_RECORD_NAME=$A_RECORD_NAME
        # Retrieve the last recorded public IP address
        IPv6_RECORD="/tmp/ipv6-record"
        RECORDED_IPv6=`cat $IPv6_RECORD`

        # Fetch the current public IP address
        PUBLIC_IPv6=$(curl --silent https://v6.ident.me/) || exit 1

        #If the public ip has not changed, nothing needs to be done, exit.
        if [ "$PUBLIC_IPv6" = "$RECORDED_IPv6" ]; then
            echo $PUBLIC_IPv6 > $IPv6_RECORD
            exit 0
        fi

        # Otherwise, your Internet provider changed your public IP again.
        # Record the new public IP address locally
        echo $PUBLIC_IPv6 > $IPv6_RECORD

        # Record the new public IP address on Cloudflare using API v4
        RECORD=$(cat <<EOF
        { "type": "AAAA",
        "name": "$AAAA_RECORD_NAME",
        "content": "$PUBLIC_IPv6",
        "ttl": 1,
        "proxied": false }
EOF
        )
        curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$AAAA_RECORD_ID" \
            -X PUT \
            -H "Content-Type: application/json" \
            -H "X-Auth-Email: $AUTH_EMAIL" \
            -H "X-Auth-Key: $AUTH_KEY" \
            -d "$RECORD"
    else
# Otherwise, your Internet provider changed your public IP again.
# Record the new public IP address locally
echo $PUBLIC_IPv4 > $IPv4_RECORD

# Record the new public IP address on Cloudflare using API v4
RECORD=$(cat <<EOF
{ "type": "A",
"name": "$A_RECORD_NAME",
"content": "$PUBLIC_IPv4",
"ttl": 1,
"proxied": false }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$A_RECORD_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "X-Auth-Email: $AUTH_EMAIL" \
     -H "X-Auth-Key: $AUTH_KEY" \
     -d "$RECORD"


#IPv6
AAAA_RECORD_NAME=$A_RECORD_NAME
# Retrieve the last recorded public IP address
IPv6_RECORD="/tmp/ipv6-record"
RECORDED_IPv6=`cat $IPv6_RECORD`

# Fetch the current public IP address
PUBLIC_IPv6=$(curl --silent https://v6.ident.me/) || exit 1

#If the public ip has not changed, nothing needs to be done, exit.
if [ "$PUBLIC_IPv6" = "$RECORDED_IPv6" ]; then
    echo $PUBLIC_IPv6 > $IPv6_RECORD
    exit 0
fi

# Otherwise, your Internet provider changed your public IP again.
# Record the new public IP address locally
echo $PUBLIC_IPv6 > $IPv6_RECORD

# Record the new public IP address on Cloudflare using API v4
RECORD=$(cat <<EOF
{ "type": "AAAA",
"name": "$AAAA_RECORD_NAME",
"content": "$PUBLIC_IPv6",
"ttl": 1,
"proxied": false }
EOF
)
curl "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$AAAA_RECORD_ID" \
     -X PUT \
     -H "Content-Type: application/json" \
     -H "X-Auth-Email: $AUTH_EMAIL" \
     -H "X-Auth-Key: $AUTH_KEY" \
     -d "$RECORD"
fi

exit