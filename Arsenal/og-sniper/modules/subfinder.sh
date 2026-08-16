#!/bin/bash
DOMAIN=$1
echo "[+] Finding Subdomains for $DOMAIN"
subfinder -d "$DOMAIN" --silent | tee recon/$DOMAIN.subs.txt