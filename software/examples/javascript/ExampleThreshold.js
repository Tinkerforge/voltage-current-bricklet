var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = 'XYZ'; // Change XYZ to the UID of your Voltage/Current Bricklet

var ipcon = new Tinkerforge.IPConnection(); // Create IP connection
var vc = new Tinkerforge.BrickletVoltageCurrent(UID, ipcon); // Create device object

ipcon.connect(HOST, PORT,
    function (error) {
        console.log('Error: ' + error);
    }
); // Connect to brickd
// Don't use device before ipcon is connected

ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function (connectReason) {
        // Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        vc.setDebouncePeriod(10000);

        // Configure threshold for power "greater than 10 W"
        vc.setPowerCallbackThreshold('>', 10*1000, 0);
    }
);

// Register power reached callback
vc.on(Tinkerforge.BrickletVoltageCurrent.CALLBACK_POWER_REACHED,
    // Callback function for power reached callback
    function (power) {
        console.log('Power: ' + power/1000.0 + ' W');
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
