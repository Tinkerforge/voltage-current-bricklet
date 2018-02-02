#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change XYZ to the UID of your Voltage/Current Bricklet

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_voltage_current import BrickletVoltageCurrent

# Callback function for power reached callback
def cb_power_reached(power):
    print("Power: " + str(power/1000.0) + " W")

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    vc = BrickletVoltageCurrent(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    vc.set_debounce_period(10000)

    # Register power reached callback to function cb_power_reached
    vc.register_callback(vc.CALLBACK_POWER_REACHED, cb_power_reached)

    # Configure threshold for power "greater than 10 W"
    vc.set_power_callback_threshold(">", 10*1000, 0)

    raw_input("Press key to exit\n") # Use input() in Python 3
    ipcon.disconnect()
