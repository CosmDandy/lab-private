#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = ["cryptography"]
# ///
"""Generate Cloudflare WARP credentials for Terraform variables."""

import base64
import json
import urllib.request

from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PrivateKey
from cryptography.hazmat.primitives import serialization


def main():
    private_key = X25519PrivateKey.generate()
    priv_bytes = private_key.private_bytes(
        serialization.Encoding.Raw,
        serialization.PrivateFormat.Raw,
        serialization.NoEncryption(),
    )
    pub_bytes = private_key.public_key().public_bytes(
        serialization.Encoding.Raw, serialization.PublicFormat.Raw
    )
    priv_b64 = base64.b64encode(priv_bytes).decode()
    pub_b64 = base64.b64encode(pub_bytes).decode()

    payload = json.dumps(
        {
            "key": pub_b64,
            "install_id": "",
            "fcm_token": "",
            "tos": "2024-01-01T00:00:00+00:00",
            "model": "PC",
            "serial_number": "",
            "locale": "en_US",
        }
    ).encode()

    req = urllib.request.Request(
        "https://api.cloudflareclient.com/v0a2158/reg",
        data=payload,
        headers={
            "Content-Type": "application/json",
            "User-Agent": "okhttp/3.12.1",
            "CF-Client-Version": "a-6.11-2223",
        },
    )

    with urllib.request.urlopen(req) as resp:
        result = json.loads(resp.read())

    addrs = result["config"]["interface"]["addresses"]

    print(f'warp_private_key = "{priv_b64}"')
    print(f'warp_address_v4  = "{addrs["v4"]}"')
    print(f'warp_address_v6  = "{addrs["v6"]}"')


if __name__ == "__main__":
    main()
