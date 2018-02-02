#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your Voltage/Current Bricklet

# Get current voltage
tinkerforge call voltage-current-bricklet $uid get-voltage

# Get current current
tinkerforge call voltage-current-bricklet $uid get-current
