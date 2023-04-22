#!/bin/sh
/usr/local/bin/scroll-text --led-rows=64 --led-cols=64 --led-chain=5 --led-parallel=1 --led-gpio-mapping=adafruit-hat-pwm --led-slowdown-gpio=4 -f /cubelight-python/fonts/texgyre-27.bdf -l 1 "$1"
