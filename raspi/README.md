# seismometer
Raspi + Pimoroni で地震計

Installation:
```
sudo rasip-config  # Enable I2C interface.
sudo apt-get install pimoroni
pimoroni-dashboard
sudo apt-get install python3-envirophat
```

How to use the library:
```
from envirophat import weather
print(weather.temperature())
```

## How to build the hardware

|Part|Price|
|----|-----|
|[Pi Zero WH Official Simple Kit](https://base.lmlab.net/products/204)|3080|
|[Enviro pHAT](https://base.lmlab.net/products/198)|2494|
|[USB電源アダプター 5V/1A 1m](https://base.lmlab.net/products/207)|880|
|[Team microSDHC 8GB CL10]()|825|
|Total|7279|

((1gbp=138.54yen))

1. Install Raspbian to the SD card

## リンク
- [岡村土研 南海地震に備える(揺れの長さ)](http://sc1.cc.kochi-u.ac.jp/~mako-ok/nankai/11duration.html)
- [Mukoyama IoT Project](https://iot.lmlab.net/howto?locale=ja)

## 履歴
- 19.09.03 [旧リポジトリ](https://github.com/lumbermill/takachiho) から移転
