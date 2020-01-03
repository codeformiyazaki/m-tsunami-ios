#!/usr/bin/env python3

import math, os, time, requests, json
import numpy as np
from envirophat import motion, leds

DEVICE_ID = os.environ.get("M_TSUNAMI_DEVICE_ID")
TOKEN = os.environ.get("M_TSUNAMI_TOKEN")

RAILS_WEBHOOK = "https://m-tsunami.herokuapp.com/devices-hook"

def main():
    if DEVICE_ID == None:
        print("M_TSUNAMI_DEVICE_ID is not set.")
        return
    if TOKEN == None:
        print("M_TSUNAMI_TOKEN is not set.")
        return

    q = {'device_id': DEVICE_ID, 'token': TOKEN}
    r = requests.get(RAILS_WEBHOOK, params=q)
    print(str(r.status_code)+" "+r.text)

if __name__ == "__main__":
    main()
