#!/usr/bin/perl  

use Tinkerforge::IPConnection;
use Tinkerforge::BrickletVoltageCurrent;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => '555'; # Change to your UID

my $ipcon = IPConnection->new(); # Create IP connection
my $vc = BrickletVoltageCurrent->new(&UID, $ipcon); # Create device object

# Callback for current greater than 1A
sub cb_reached
{
    my($current) = @_;

    print "\nCurrent is greater than 1A: ".$current/1000.0."\n";
}

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$vc->set_debounce_period(10000);

# Register threshold reached callback to function cb_reached
$vc->register_callback($vc->CALLBACK_CURRENT_REACHED, 'cb_reached');

# Configure threshold for "greater than 1A" (unit is mA)
$vc->set_current_callback_threshold('>', 200, 0);

print "\nPress any key to exit...\n";
<STDIN>;
$ipcon->disconnect();
