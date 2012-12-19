<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletVoltageCurrent.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletVoltageCurrent;

$host = 'localhost';
$port = 4223;
$uid = 'ABC'; // Change to your UID

// Callback function for current callback (parameter has unit mA)
function cb_current($current)
{
    echo "Current: " . $current / 1000.0 . " A\n";
}

$ipcon = new IPConnection($host, $port); // Create IP connection to brickd
$vc = new BrickletVoltageCurrent($uid); // Create device object

$ipcon->addDevice($vc); // Add device to IP connection
// Don't use device before it is added to a connection

// Set Period for current callback to 1s (1000ms)
// Note: The callback is only called every second if the 
//       current has changed since the last call!
$vc->setCurrentCallbackPeriod(1000);

// Register current callback to function cb_current
$vc->registerCallback(BrickletVoltageCurrent::CALLBACK_CURRENT, 'cb_current');

echo "Press ctrl+c to exit\n";
$ipcon->dispatchCallbacks(-1); // Dispatch callbacks forever

?>
