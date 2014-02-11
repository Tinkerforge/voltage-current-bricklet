var IPConnection = require('Tinkerforge/IPConnection');
var BrickletVoltageCurrent = require('Tinkerforge/BrickletVoltageCurrent');

var HOST = 'localhost';
var PORT = 4223;
var UID = '555';// Change to your UID

var ipcon = new IPConnection();// Create IP connection
var vc = new BrickletVoltageCurrent(UID, ipcon);// Create device object

ipcon.connect(HOST, PORT,
    function(error) {
        console.log('Error: '+error);        
    }
);// Connect to brickd

// Don't use device before ipcon is connected
ipcon.on(IPConnection.CALLBACK_CONNECTED,
    function(connectReason) {
        // Get current current and voltage (unit is mA and mV)
        vc.getCurrent(
            function(current) {
                console.log('Current: '+current/1000+' A');
            },
            function(error) {
                console.log('Error: '+error);
            }
        );
        vc.getVoltage(
            function(voltage) {
                console.log('Voltage: '+voltage/1000+' V');
            },
            function(error) {
                console.log('Error: '+error);
            }
        );
    }
);

console.log("Press any key to exit ...");
process.stdin.on('data',
    function(data) {
        ipcon.disconnect();
        process.exit(0);
    }
);

