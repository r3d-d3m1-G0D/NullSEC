#!/bin/bash
# Usage: ./probe_origin.sh domain.com 1.2.3.4

DOMAIN=$1
IP=$2
curl -sk --resolve "$DOMAIN:443:$IP" https://$DOMAIN \
 -H "Host: $DOMAIN" -H "X-Forwarded-For: 127.0.0.1" -i