#!/bin/bash
# tools/auto_compare.sh

DOMAIN=$1
ORIGIN_IP=$2

if [[ -z "$DOMAIN" || -z "$ORIGIN_IP" ]]; then
  echo "Usage: $0 domain.com origin_ip"
  exit 1
fi

OUTDIR="output/$DOMAIN"
mkdir -p "$OUTDIR"

echo "[*] Getting CDN baseline for $DOMAIN..."
curl -sk -i "https://$DOMAIN" > "$OUTDIR/cdn_response.txt"

echo "[*] Getting origin response from $ORIGIN_IP..."
curl -sk -i --resolve "$DOMAIN:443:$ORIGIN_IP" "https://$DOMAIN" -H "Host: $DOMAIN" > "$OUTDIR/origin_response.txt"

echo "[*] Comparing headers..."
diff -u "$OUTDIR/cdn_response.txt" "$OUTDIR/origin_response.txt" > "$OUTDIR/response_diff.txt"

echo "[+] Diff saved to $OUTDIR/response_diff.txt"
