function octave_example_threshold
    more off;
    
    HOST = "localhost";
    PORT = 4223;
    UID = "555"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    vc = java_new("com.tinkerforge.BrickletVoltageCurrent", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    vc.setDebouncePeriod(10000);

    % Register threshold reached callback to function cb_reached
    vc.addCurrentReachedListener("cb_reached");

    % Configure threshold for "greater than 1A" (unit is mA)
    vc.setCurrentCallbackThreshold(vc.THRESHOLD_OPTION_GREATER, 1*1000, 0);

    % Register humidity callback to function cb_humidity
    vc.addCurrentListener("cb_current");

    input("\nPress any key to exit...\n", "s");
    ipcon.disconnect();
end

% Callback for current greater than 1A
function cb_reached(current_value)
    fprintf("Current is greater than 1A: %g \n", current_value/1000);
end
