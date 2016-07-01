<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletVoltageCurrent.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletVoltageCurrent;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your Voltage/Current Bricklet

// Callback function for power reached callback (parameter has unit mW)
function cb_powerReached($power)
{
    echo "Power: " . $power/1000.0 . " W\n";
}

$ipcon = new IPConnection(); // Create IP connection
$vc = new BrickletVoltageCurrent(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$vc->setDebouncePeriod(10000);

// Register power reached callback to function cb_powerReached
$vc->registerCallback(BrickletVoltageCurrent::CALLBACK_POWER_REACHED, 'cb_powerReached');

// Configure threshold for power "greater than 10 W" (unit is mW)
$vc->setPowerCallbackThreshold('>', 10*1000, 0);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
