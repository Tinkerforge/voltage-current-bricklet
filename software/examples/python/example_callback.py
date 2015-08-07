#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_voltage_current import BrickletVoltageCurrent

# Callback function for voltage callback (parameter has unit mV)
def cb_voltage(voltage):
    print('Voltage: ' + str(voltage/1000.0) + ' V')

# Callback function for current callback (parameter has unit mA)
def cb_current(current):
    print('Current: ' + str(current/1000.0) + ' A')

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    vc = BrickletVoltageCurrent(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Set period for voltage callback to 1s (1000ms)
    # Note: The voltage callback is only called every second
    #       if the voltage has changed since the last call!
    vc.set_voltage_callback_period(1000)

    # Register voltage callback to function cb_voltage
    vc.register_callback(vc.CALLBACK_VOLTAGE, cb_voltage)

    # Set period for current callback to 1s (1000ms)
    # Note: The current callback is only called every second
    #       if the current has changed since the last call!
    vc.set_current_callback_period(1000)

    # Register current callback to function cb_current
    vc.register_callback(vc.CALLBACK_CURRENT, cb_current)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.disconnect()
