#!/usr/bin/perl  

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletVoltageCurrent;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => '555'; # Change to your UID

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $vc = Tinkerforge::BrickletVoltageCurrent->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get current current and voltage (unit is mA and mV)
my $current = $vc->get_current()/1000.0;
print "Current: $current A\n";

my $voltage = $vc->get_voltage()/1000.0;
print "Voltage: $voltage V\n";

print "Press any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
