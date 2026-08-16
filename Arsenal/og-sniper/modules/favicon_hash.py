#!/usr/bin/env python3
import mmh3
import requests
import base64

url = input("Favicon URL: ")
response = requests.get(url)
favicon = base64.encodebytes(response.content)
hash = mmh3.hash(favicon.decode('utf-8'))
print(f"[+] Favicon Hash: {hash}")
# After we run this. Plug into shodan (shodan search http.favicon.hash:<hash>)