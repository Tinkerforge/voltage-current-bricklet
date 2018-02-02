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
        // Get current voltage
        vc.getVoltage(
            function (voltage) {
                console.log('Voltage: ' + voltage/1000.0 + ' V');
            },
            function (error) {
                console.log('Error: ' + error);
            }
        );

        // Get current current
        vc.getCurrent(
            function (current) {
                console.log('Current: ' + current/1000.0 + ' A');
            },
            function (error) {
                console.log('Error: ' + error);
            }
        );
    }
);

console.log('Press key to exit');
process.stdin.on('data',
    function (data) {
        ipcon.disconnect();
        process.exit(0);
    }
);
