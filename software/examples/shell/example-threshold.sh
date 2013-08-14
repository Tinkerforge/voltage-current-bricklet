#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call voltage-current-bricklet $uid set-debounce-period 10000

# configure threshold for "greater than 1A" (unit is mA)
tinkerforge call voltage-current-bricklet $uid set-current-callback-threshold greater 1000 0

# handle incoming current-reached callbacks (unit is mA)
tinkerforge dispatch voltage-current-bricklet $uid current-reached\
 --execute "echo Current is greater than 1A: {current} mA"
