#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_voltage_current'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change to your UID

ipcon = IPConnection.new # Create IP connection
vc = BrickletVoltageCurrent.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
vc.set_debounce_period 10000

# Register threshold reached callback for voltage greater than 5000 V (parameter has unit mV)
vc.register_callback(BrickletVoltageCurrent::CALLBACK_VOLTAGE_REACHED) do |voltage|
  puts "Voltage: #{voltage/1000.0} V"
end

# Configure threshold for "greater than 5000 V" (unit is mV)
vc.set_voltage_callback_threshold '>', 5000*1000, 0

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
vc.set_debounce_period 10000

# Register threshold reached callback for current greater than 1000 A (parameter has unit mA)
vc.register_callback(BrickletVoltageCurrent::CALLBACK_CURRENT_REACHED) do |current|
  puts "Current: #{current/1000.0} A"
end

# Configure threshold for "greater than 1000 A" (unit is mA)
vc.set_current_callback_threshold '>', 1000*1000, 0

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
