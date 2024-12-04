"""
A script that will request the DigitalOcean API to schedule a deployment.
"""

import sys
import requests


def main(args: list[str]) -> int:
    """
    The entry point for the script.
    """
    if len(args) != 2:
        print("Invalid Arguments!")
        return 1

    BASE_URL = "https://api.digitalocean.com/v2/apps"
    APP_ID = args[0]
    FULL_URL = f"{BASE_URL}/{APP_ID}/deployments"

    response = requests.post(
        FULL_URL,
        headers={"Authorization": f"Bearer {args[1]}"},
        json={"force_build": False},
    )
    print(f"STATUS: {response.status_code}")
    if response.status_code != 200:
        print(f"PAYLOAD: {response.json()}")

    return 0


if __name__ == "__main__":
    args = sys.argv
    args.pop(0)
    EXIT = main(args=args)
    sys.exit(EXIT)
