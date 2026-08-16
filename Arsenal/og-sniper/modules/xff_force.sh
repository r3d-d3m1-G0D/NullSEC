#!/bin/bash
# Inject X-Forwarded-For to test origin trust

DOMAIN=$1
curl -sk -H "Host: $DOMAIN" \
 -H "X-Forwarded-For: 127.0.0.1" \
 -H "X-Originating-IP: 127.0.0.1" \
 https://$DOMAIN -i