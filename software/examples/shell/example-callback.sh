#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# set period for illuminance callback to 1s (1000ms)
# note: the illuminance callback is only called every second if the
#       illuminance has changed since the last call!
tinkerforge call voltage-current-bricklet $uid set-current-callback-period 1000

# handle incoming illuminance callbacks (unit is mA)
tinkerforge dispatch voltage-current-bricklet $uid current
