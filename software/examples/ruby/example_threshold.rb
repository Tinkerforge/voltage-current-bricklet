#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_voltage_current'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'ABC' # Change to your UID

ipcon = IPConnection.new # Create IP connection
vc = BrickletVoltageCurrent.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
vc.set_debounce_period 10000

# Register threshold reached callback for "greater than 1A" (unit is mA)
vc.register_callback(BrickletVoltageCurrent::CALLBACK_CURRENT_REACHED) do |current|
  puts "Current is greater than 1A: #{current/1000.0}"
end

# Configure threshold for "greater than 1A" (unit is mA)
vc.set_current_callback_threshold '>', 1*1000, 0

puts 'Press key to exit'
$stdin.gets
