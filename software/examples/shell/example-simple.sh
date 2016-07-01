#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your Voltage/Current Bricklet

# Get current voltage (unit is mV)
tinkerforge call voltage-current-bricklet $uid get-voltage

# Get current current (unit is mA)
tinkerforge call voltage-current-bricklet $uid get-current
