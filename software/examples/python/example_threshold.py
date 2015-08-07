#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_voltage_current import BrickletVoltageCurrent

# Callback function for voltage greater than 5000 V (parameter has unit mV)
def cb_voltage_reached(voltage):
    print('Voltage: ' + str(voltage/1000.0) + ' V')

# Callback function for current greater than 1000 A (parameter has unit mA)
def cb_current_reached(current):
    print('Current: ' + str(current/1000.0) + ' A')

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    vc = BrickletVoltageCurrent(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    vc.set_debounce_period(10000)

    # Register threshold reached callback to function cb_voltage_reached
    vc.register_callback(vc.CALLBACK_VOLTAGE_REACHED, cb_voltage_reached)

    # Configure threshold for "greater than 5000 V" (unit is mV)
    vc.set_voltage_callback_threshold('>', 5000*1000, 0)

    # Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    vc.set_debounce_period(10000)

    # Register threshold reached callback to function cb_current_reached
    vc.register_callback(vc.CALLBACK_CURRENT_REACHED, cb_current_reached)

    # Configure threshold for "greater than 1000 A" (unit is mA)
    vc.set_current_callback_threshold('>', 1000*1000, 0)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
