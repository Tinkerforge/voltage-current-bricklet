#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "ABCD" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_voltage_current import VoltageCurrent

# Callback for current greater than 1A
def cb_reached(current):
    print('Current is greater than 1A: ' + str(current/1000.0))

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    vc = VoltageCurrent(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected


    # Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    vc.set_debounce_period(10000)

    # Register threshold reached callback to function cb_reached
    vc.register_callback(vc.CALLBACK_CURRENT_REACHED, cb_reached)

    # Configure threshold for "greater than 1A" (unit is mA)
    vc.set_current_callback_threshold('>', 1*1000, 0)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
