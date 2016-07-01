<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletVoltageCurrent.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletVoltageCurrent;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your Voltage/Current Bricklet

// Callback function for current callback (parameter has unit mA)
function cb_current($current)
{
    echo "Current: " . $current/1000.0 . " A\n";
}

$ipcon = new IPConnection(); // Create IP connection
$vc = new BrickletVoltageCurrent(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Register current callback to function cb_current
$vc->registerCallback(BrickletVoltageCurrent::CALLBACK_CURRENT, 'cb_current');

// Set period for current callback to 1s (1000ms)
// Note: The current callback is only called every second
//       if the current has changed since the last call!
$vc->setCurrentCallbackPeriod(1000);

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
