<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletVoltageCurrent.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletVoltageCurrent;

$host = 'localhost';
$port = 4223;
$uid = 'ABC'; // Change to your UID

$ipcon = new IPConnection(); // Create IP connection
$vc = new BrickletVoltageCurrent($uid, $ipcon); // Create device object

$ipcon->connect($host, $port); // Connect to brickd
// Don't use device before ipcon is connected

// Get current current and voltage (unit is mA and mV)
$current = $vc->getCurrent() / 1000.0;
$voltage = $vc->getVoltage() / 1000.0;

echo "Current: $current A\n";
echo "Voltage: $voltage V\n";

echo "Press key to exit\n";
fgetc(fopen('php://stdin', 'r'));
$ipcon->disconnect();

?>
