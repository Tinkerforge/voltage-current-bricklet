#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletVoltageCurrent;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your Voltage/Current Bricklet

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $vc = Tinkerforge::BrickletVoltageCurrent->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get current voltage (unit is mV)
my $voltage = $vc->get_voltage();
print "Voltage: " . $voltage/1000.0 . " V\n";

# Get current current (unit is mA)
my $current = $vc->get_current();
print "Current: " . $current/1000.0 . " A\n";

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
