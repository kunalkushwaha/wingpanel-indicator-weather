#!/bin/bash

sudo cp libweather.so /usr/lib/x86_64-linux-gnu/wingpanel/libweather.so

pkill -9 wingpanel

#crontab -e
#*/30 * * * * pkill -9 wingpanel