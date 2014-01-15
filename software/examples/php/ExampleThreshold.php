<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletVoltageCurrent.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletVoltageCurrent;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'ABC'; // Change to your UID

// Callback for current greater than 1A
function cb_reached($current)
{
    echo "Current is greater than 1A: " . $current / 1000.0 . "\n";
}

$ipcon = new IPConnection(); // Create IP connection
$vc = new BrickletVoltageCurrent(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
$vc->setDebouncePeriod(10000);

// Register threshold reached callback to function cb_reached
$vc->registerCallback(BrickletVoltageCurrent::CALLBACK_CURRENT_REACHED, 'cb_reached');

// Configure threshold for "greater than 1A" (unit is mA)
$vc->setCurrentCallbackThreshold('>', 1*1000, 0);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
