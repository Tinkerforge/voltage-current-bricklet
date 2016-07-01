function octave_example_callback()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change XYZ to the UID of your Voltage/Current Bricklet

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    vc = java_new("com.tinkerforge.BrickletVoltageCurrent", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Register current callback to function cb_current
    vc.addCurrentCallback(@cb_current);

    % Set period for current callback to 1s (1000ms)
    % Note: The current callback is only called every second
    %       if the current has changed since the last call!
    vc.setCurrentCallbackPeriod(1000);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end

% Callback function for current callback (parameter has unit mA)
function cb_current(e)
    fprintf("Current: %g A\n", e.current/1000.0);
end
