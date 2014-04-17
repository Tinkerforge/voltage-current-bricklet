function octave_example_callback
    more off;
    
    HOST = "localhost";
    PORT = 4223;
    UID = "555"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    vc = java_new("com.tinkerforge.BrickletVoltageCurrent", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set Period for current callback to 1s (1000ms)
    % Note: The callback is only called every second if the 
    %       current has changed since the last call!
    vc.setCurrentCallbackPeriod(1000);

    % Register humidity callback to function cb_humidity
    vc.addCurrentCallback(@cb_current);

    input("Press any key to exit...\n", "s");
    ipcon.disconnect();
end

% Callback function for current callback (parameter has unit mA)
function cb_current(e)
    fprintf("Current: %g A\n", e.current/1000.0);
end
