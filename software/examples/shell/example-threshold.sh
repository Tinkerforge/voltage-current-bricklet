#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your Voltage/Current Bricklet

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call voltage-current-bricklet $uid set-debounce-period 10000

# Handle incoming power reached callbacks
tinkerforge dispatch voltage-current-bricklet $uid power-reached &

# Configure threshold for power "greater than 10 W"
tinkerforge call voltage-current-bricklet $uid set-power-callback-threshold threshold-option-greater 10000 0

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
