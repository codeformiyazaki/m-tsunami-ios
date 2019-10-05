#!/usr/bin/env python

import math, os, time, requests, json
import numpy as np
from envirophat import motion, leds

# For debug use:
SLACK_WEBHOOK = os.environ.get("SLACK_WEBHOOK")
SLACK_THRESH = 30.0

# TODO: implements function to send push notifications to railsapp.
RAILS_WEBHOOK = "https://desolate-headland-83158.herokuapp.com/quakes"
RAILS_THRESH = 30.0

DETECT_THRESH = 0.01
DETECT_INTERVAL = 0.01
DETECT_NUM = 4
DETECT_NOOP = int(0.3 / DETECT_INTERVAL) #  0.3 sec
DATA_MAX = int(60 / DETECT_INTERVAL)  # 60.0 sec

def strength(data,l):
    """
    Returns the strength of earthquake as tuple (P(z),S(xy))
    """

    # FFT
    # https://momonoki2017.blogspot.com/2018/03/pythonfft-1-fft.html
    # Fast Fourier Transform
    # fx = np.fft.fft(data[0])
    # fy = np.fft.fft(data[1])
    # fz = np.fft.fft(data[2])
    # What's is the filter??
    # https://www.data.jma.go.jp/svd/eqev/data/kyoshin/kaisetsu/calc_sindo.htm
    # Inverse Fast Fourier Transform
    # ifx = np.fft.ifft(fx)
    # ify = np.fft.ifft(fy)
    # ifz = np.fft.ifft(fz)

    # rpi-seismometer
    # https://github.com/p2pquake/rpi-seismometer
    # for i in range(3):
    #     rv[i] = rv[i] * 0.94 + d[i]*0.06
    #     gals[i] = (rv[i] - avgs[i]) * 1.13426
    avgs = [0,0,0]
    for i in range(3):
        avgs[i] = sum(data[i][-l:]) / len(data[i][-l:])

    gals_z = [] # P wave?
    gals_xy = [] # S wave?
    for d in np.array(data).T[-l:]:
        dd = 0
        for i in range(2):
            dd += (d[i] - avgs[i])**2
        gals_xy.append(math.sqrt(dd))
        gals_z.append(math.sqrt((d[2]-avgs[2])**2))
    avg_z = sum(gals_z) / len(gals_z) * 100
    avg_xy = sum(gals_xy) / len(gals_xy) * 100
    return avg_z,avg_xy


def main():
    print("Press Ctrl+C to exit.")

    data = [[],[],[]]
    last_d = [-1,-1,-1]
    started = -1
    started_at = None

    try:
        while True:
            v = motion.accelerometer()
            data[0].append(v.x)
            data[1].append(v.y)
            data[2].append(v.z)
            shaked = False
            for i in range(3):
                data[i] = data[i][-DATA_MAX:]
                if len(data[i]) < DETECT_NUM: continue
                d = sum(data[i][-DETECT_NUM:]) / DETECT_NUM
                if last_d[i] > 0 and abs(d - last_d[i]) > DETECT_THRESH:
                    shaked = True
                last_d[i] = d
            if shaked:
                started = DETECT_NOOP
                if started_at == None:
                    started_at = time.time()
                    print("detected the quake!")
                    leds.on()
            time.sleep(DETECT_INTERVAL)
            started -= 1
            if started == 0:
                elapsed = time.time() - started_at
                sp,ss = strength(data,int(elapsed / DETECT_INTERVAL))
                msg = "An earthquake detected! %.2f P:%.2f S:%.2f" % (elapsed,sp,ss)
                print(msg)
                started_at = None
                leds.off()
                if elapsed > RAILS_THRESH:
                    requests.post(RAILS_WEBHOOK, data = json.dumps({
                      'elapsed': elapsed , 'p': sp, 's': ss
                    })))
                if SLACK_WEBHOOK and elapsed > SLACK_THRESH:
                    requests.post(SLACK_WEBHOOK, data = json.dumps({
                      'text': msg ,
                    }))
    except KeyboardInterrupt:
        leds.off()

if __name__ == "__main__":
    main()
