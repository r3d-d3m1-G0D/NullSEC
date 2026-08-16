#!/bin/bash
# Identify Cloudflare + Cloudfront + CDN fingerprints
DOMAIN=$1
echo "[*] Checking CDN config for $DOMAIN..."
dig +short $DOMAIN
dig +short CNAME $DOMAIN
whois $(dig +short $DOMAIN | tail -n1) | grep -Ei 'Cloudflare|Amazon|Cloudfront|Akamai'