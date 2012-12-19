<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletVoltageCurrent.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletVoltageCurrent;

$host = 'localhost';
$port = 4223;
$uid = 'ABC'; // Change to your UID

$ipcon = new IPConnection($host, $port); // Create IP connection to brickd
$vc = new BrickletVoltageCurrent($uid); // Create device object

$ipcon->addDevice($vc); // Add device to IP connection
// Don't use device before it is added to a connection

// Get current current and voltage (unit is mA and mV)
$current = $vc->getCurrent() / 1000.0;
$voltage = $vc->getVoltage() / 1000.0;

echo "Current: $current A\n";
echo "Voltage: $voltage V\n";

echo "Press key to exit\n";
fgetc(fopen('php://stdin', 'r'));
$ipcon->destroy();

?>
