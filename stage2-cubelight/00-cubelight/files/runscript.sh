#!/bin/sh
/usr/local/bin/demo -D 4 --led-rows=64 --led-cols=64 --led-chain=5 --led-parallel=1 --led-gpio-mapping=adafruit-hat-pwm --led-slowdown-gpio=4 &
sleep 5
killall -9 demo
