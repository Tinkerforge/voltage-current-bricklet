#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "ABCD" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_voltage_current import VoltageCurrent

if __name__ == "__main__":
    ipcon = IPConnection(HOST, PORT) # Create ip connection to brickd

    vc = VoltageCurrent(UID) # Create device object
    ipcon.add_device(vc) # Add device to ip connection
    # Don't use device before it is added to a connection

    # Get current current and voltage (unit is mA and mV)
    current = vc.get_current()
    voltage = vc.get_voltage()

    print('Current: ' + str(current/1000.0) + ' A')
    print('Voltage: ' + str(voltage/1000.0) + ' V')

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.destroy()
