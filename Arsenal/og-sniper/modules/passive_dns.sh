#!/bin/bash
DOMAIN=$1
ECHO "[+] Checking historical IPs for $DOMAIN via SecurityTrails"
curl -s "https://api.securitytrails.com/v1/domain/$DOMAIN/subdomains" \
 -H "APIKEY: $ST_API_KEY" | jq '.subdomains[]' | tee recon/$DOMAIN.dns.txt
 
