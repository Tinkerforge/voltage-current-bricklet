function octave_example_threshold()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your Voltage/Current Bricklet

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    vc = java_new("com.tinkerforge.BrickletVoltageCurrent", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    vc.setDebouncePeriod(10000);

    % Register power reached callback to function cb_power_reached
    vc.addPowerReachedCallback(@cb_power_reached);

    % Configure threshold for power "greater than 10 W" (unit is mW)
    vc.setPowerCallbackThreshold(">", 10*1000, 0);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end

% Callback function for power reached callback (parameter has unit mW)
function cb_power_reached(e)
    fprintf("Power: %g W\n", e.power/1000.0);
end
