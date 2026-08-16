#!/bin/bash
# modules/cert.sh

if [ -z "$1" ]; then
  echo "Usage: $0 domain.com"
  exit 1
fi

DOMAIN=$1
OUTDIR="output/$DOMAIN"
mkdir -p "$OUTDIR"

echo "[*] Querying crt.sh for certificate records on $DOMAIN..."
curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" |
  jq -r '.[].name_value' |
  sed 's/\*\.//g' |
  sort -u > "$OUTDIR/cert_subdomains.txt"

echo "[+] Saved to $OUTDIR/cert_subdomains.txt"
