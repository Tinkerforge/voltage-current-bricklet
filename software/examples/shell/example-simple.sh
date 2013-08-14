#!/bin/sh
# connects to localhost:4223 by default, use --host and --port to change it

# change to your UID
uid=XYZ

# get current current and voltage (unit is mA and mV)
tinkerforge call voltage-current-bricklet $uid get-current
tinkerforge call voltage-current-bricklet $uid get-voltage
