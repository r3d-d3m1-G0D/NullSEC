#!/bin/bash
# tools/origin-sniper.sh - CDN/Cloud WAF Bypass IP Prober v1.1

DOMAIN=$1
IP_LIST=$2

OUTDIR="output/$DOMAIN/origin-sniper"
mkdir -p "$OUTDIR"

# If no IP list is provided, extract passively from prior modules
if [[ -z "$IP_LIST" ]]; then
  echo "[*] No IP list provided, extracting from prior recon..."

  # From passive DNS JSON (BufferOver.run output)
  if [[ -f "output/$DOMAIN/dns_history.json" ]]; then
    echo "[*] Extracting from dns_history.json..."
    jq -r '.FDNS_A[]?' "output/$DOMAIN/dns_history.json" 2>/dev/null | \
      cut -d',' -f2 | sort -u > "$OUTDIR/passive_ips.txt"
  fi

  # From dig results
  if [[ -f "output/$DOMAIN/dns.txt" ]]; then
    echo "[*] Extracting from dns.txt..."
    grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "output/$DOMAIN/dns.txt" >> "$OUTDIR/passive_ips.txt"
  fi

  # Deduplicate
  sort -u "$OUTDIR/passive_ips.txt" -o "$OUTDIR/passive_ips.txt"
  IP_LIST="$OUTDIR/passive_ips.txt"
fi

echo "[*] Probing origin IPs for $DOMAIN..."
while read -r IP; do
  [[ -z "$IP" ]] && continue
  echo "[*] Testing $IP..."

  curl -sk --resolve "$DOMAIN:443:$IP" "https://$DOMAIN" \
    -H "Host: $DOMAIN" \
    -H "X-Forwarded-For: 127.0.0.1" \
    -H "User-Agent: Mozilla/5.0" \
    -i > "$OUTDIR/$IP.txt"

  if grep -q "HTTP/1.1 200 OK" "$OUTDIR/$IP.txt"; then
    echo -e "[${GREEN}+${NC}] $IP → 200 OK"
  elif grep -qi "403 Forbidden" "$OUTDIR/$IP.txt"; then
    echo -e "[${YELLOW}–${NC}] $IP → 403 Forbidden"
  else
    echo -e "[?] $IP returned different status"
  fi
done < "$IP_LIST"

echo "[✓] Origin-sniper scan complete. Results in $OUTDIR"
