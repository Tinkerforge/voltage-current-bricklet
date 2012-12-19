#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_voltage_current'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'ABC' # Change to your UID

ipcon = IPConnection.new HOST, PORT # Create IP connection to brickd
vc = BrickletVoltageCurrent.new UID # Create device object
ipcon.add_device vc # Add device to IP connection
# Don't use device before it is added to a connection

# Get current current and voltage (unit is mA and mV)
current = vc.get_current / 1000.0
voltage = vc.get_voltage / 1000.0
puts "Current: #{current} A"
puts "Voltage: #{voltage} V"

puts 'Press key to exit'
$stdin.gets
ipcon.destroy
