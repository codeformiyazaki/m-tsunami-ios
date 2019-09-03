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

## リンク

[岡村土研 南海地震に備える(揺れの長さ)](http://sc1.cc.kochi-u.ac.jp/~mako-ok/nankai/11duration.html)

## 履歴
- 19.09.03 次のリポジトリから移転 https://github.com/lumbermill/takachiho
