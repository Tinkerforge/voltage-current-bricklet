#!/usr/bin/perl

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletVoltageCurrent;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your Voltage/Current Bricklet

# Callback subroutine for power reached callback
sub cb_power_reached
{
    my ($power) = @_;

    print "Power: " . $power/1000.0 . " W\n";
}

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $vc = Tinkerforge::BrickletVoltageCurrent->new(&UID, $ipcon); # Create device object

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$vc->set_debounce_period(10000);

# Register power reached callback to subroutine cb_power_reached
$vc->register_callback($vc->CALLBACK_POWER_REACHED, 'cb_power_reached');

# Configure threshold for power "greater than 10 W"
$vc->set_power_callback_threshold('>', 10*1000, 0);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
