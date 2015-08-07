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

# Register threshold reached callback for power greater than 10 W (parameter has unit mW)
vc.register_callback(BrickletVoltageCurrent::CALLBACK_POWER_REACHED) do |power|
  puts "Power: #{power/1000.0} W"
end

# Configure threshold for "greater than 10 W" (unit is mW)
vc.set_power_callback_threshold '>', 10*1000, 0

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
