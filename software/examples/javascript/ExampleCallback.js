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
        //Set Period for current callback to 1s (1000ms)
        //Note: The callback is only called every second if the 
        //current has changed since the last call!
        vc.setCurrentCallbackPeriod(1000);      
    }
);

//Register current callback
vc.on(Tinkerforge.BrickletVoltageCurrent.CALLBACK_CURRENT,
    //Callback function for current callback (parameter has unit mA)
    function(current) {
        console.log('Current: '+current/1000+' A');
    }
);

console.log("Press any key to exit ...");
process.stdin.on('data',
    function(data) {
        ipcon.disconnect();
        process.exit(0);
    }
);

