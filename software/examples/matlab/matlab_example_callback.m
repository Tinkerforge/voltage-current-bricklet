function matlab_example_callback
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletVoltageCurrent;

    HOST = 'localhost';
    PORT = 4223;
    UID = '555'; % Change to your UID
    
    ipcon = IPConnection(); % Create IP connection
    vc = BrickletVoltageCurrent(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Set Period for current callback to 1s (1000ms)
    % Note: The callback is only called every second if the 
    %       current has changed since the last call!
    vc.setCurrentCallbackPeriod(1000);

    % Register current callback to function cb_current
    set(vc, 'CurrentCallback', @(h, e)cb_current(e.current));

    input('\nPress any key to exit...\n', 's');
    ipcon.disconnect();
end

% Callback function for humidity callback (parameter has unit %RH/10)
function cb_current(current_value)
    fprintf('Current: %g A\n', current_value/1000);
end
