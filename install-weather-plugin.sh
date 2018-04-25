#!/bin/bash

cp .weather-map.dat ~/.weather-map.dat

sudo cp libweather.so /usr/lib/x86_64-linux-gnu/wingpanel/libweather.so

pkill -9 wingpanel
