#!/usr/bin/env python
# -*- coding: utf-8 -*-

HOST = "localhost"
PORT = 4223
UID = "XYZ" # Change XYZ to the UID of your Voltage/Current Bricklet

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_voltage_current import BrickletVoltageCurrent

if __name__ == "__main__":
    ipcon = IPConnection() # Create IP connection
    vc = BrickletVoltageCurrent(UID, ipcon) # Create device object

    ipcon.connect(HOST, PORT) # Connect to brickd
    # Don't use device before ipcon is connected

    # Get current voltage
    voltage = vc.get_voltage()
    print("Voltage: " + str(voltage/1000.0) + " V")

    # Get current current
    current = vc.get_current()
    print("Current: " + str(current/1000.0) + " A")

    raw_input("Press key to exit\n") # Use input() in Python 3
    ipcon.disconnect()
