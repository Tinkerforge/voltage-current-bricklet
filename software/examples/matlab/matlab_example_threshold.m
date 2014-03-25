function matlab_example_threshold
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletVoltageCurrent;

    HOST = 'localhost';
    PORT = 4223;
    UID = '555'; % Change to your UID
    
    ipcon = IPConnection(); % Create IP connection
    vc = BrickletVoltageCurrent(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get threshold callbacks with a debounce time of 10 seconds (10000ms)
    vc.setDebouncePeriod(10000);

    % Register threshold reached callback to function cb_reached
    set(vc, 'CurrentCallback', @(h, e)cb_reached(e.current));

    % Configure threshold for "greater than 1A" (unit is mA)
    vc.setCurrentCallbackThreshold('>', 1*1000, 0);

    input('\nPress any key to exit...\n', 's');
    ipcon.disconnect();
end

% Callback for current greater than 1A
function cb_reached(current_value)
    fprintf('Current is greater than 1A: %g \n', current_value/1000);
end

