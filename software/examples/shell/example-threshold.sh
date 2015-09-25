#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change to your UID

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
tinkerforge call voltage-current-bricklet $uid set-debounce-period 10000

# Handle incoming power reached callbacks (parameter has unit mW)
tinkerforge dispatch voltage-current-bricklet $uid power-reached &

# Configure threshold for power "greater than 10 W" (unit is mW)
tinkerforge call voltage-current-bricklet $uid set-power-callback-threshold greater 10000 0

echo "Press key to exit"; read dummy

kill -- -$$ # Stop callback dispatch in background
