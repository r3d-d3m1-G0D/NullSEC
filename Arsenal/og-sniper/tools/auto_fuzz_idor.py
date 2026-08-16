#!/usr/bin/env python3
import requests
import sys

def fuzz_path(domain, base_path="/", fuzz_range=range(1, 100)):
    headers = {
        "User-Agent": "Mozilla/5.0",
        "X-Forwarded-For": "127.0.0.1",
    }
    
    for i in fuzz_range:
        test_url = f"{domain.rstrip('/')}{base_path}{i}/"
        try:
            r = requests.get(test_url, headers=headers, timeout=5)
            if r.status_code not in [403, 404]:
                print(f"[+] {test_url} -> {r.status_code}")
        except Exception as e:
            print(f"[-] Error on {test_url}: {e}")
            
if __name__ == "__main__":
    try:
        with open("config/targets.txt", "r") as f:
            targets = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print("[-] config/targets.txt not found.")
        sys.exit(1)
        
    print(f"[+] Loaded {len(targets)} targets.")
    for target in targets:
        print(f"\n[~] Fuzzing {target}")
        fuzz_path(target, base_path="/app/", fuzz_range=range(1, 50))
            