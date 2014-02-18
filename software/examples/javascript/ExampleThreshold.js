var Tinkerforge = require('tinkerforge');

var HOST = 'localhost';
var PORT = 4223;
var UID = '555';// Change to your UID

var ipcon = new Tinkerforge.IPConnection();// Create IP connection
var vc = new Tinkerforge.BrickletVoltageCurrent(UID, ipcon);// Create device object

ipcon.connect(HOST, PORT,
    function(error) {
        console.log('Error: '+error);        
    }
);// Connect to brickd

// Don't use device before ipcon is connected
ipcon.on(Tinkerforge.IPConnection.CALLBACK_CONNECTED,
    function(connectReason) {
        //Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        vc.setDebouncePeriod(10000);
        //Configure threshold for "greater than 1A" (unit is mA)
        vc.setCurrentCallbackThreshold('>', 1*1000, 0);     
    }
);

// Register threshold reached callback
vc.on(Tinkerforge.BrickletVoltageCurrent.CALLBACK_CURRENT_REACHED,
    //Callback for current greater than 1A
    function(current) {
        console.log('Current is greater than 1A: '+current/1000+' A');
    }
);

console.log("Press any key to exit ...");
process.stdin.on('data',
    function(data) {
        ipcon.disconnect();
        process.exit(0);
    }
);


