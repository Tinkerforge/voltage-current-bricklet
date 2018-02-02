#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_voltage_current'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = 'XYZ' # Change XYZ to the UID of your Voltage/Current Bricklet

ipcon = IPConnection.new # Create IP connection
vc = BrickletVoltageCurrent.new UID, ipcon # Create device object

ipcon.connect HOST, PORT # Connect to brickd
# Don't use device before ipcon is connected

# Register current callback
vc.register_callback(BrickletVoltageCurrent::CALLBACK_CURRENT) do |current|
  puts "Current: #{current/1000.0} A"
end

# Set period for current callback to 1s (1000ms)
# Note: The current callback is only called every second
#       if the current has changed since the last call!
vc.set_current_callback_period 1000

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect
