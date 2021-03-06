function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletVoltageCurrent;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change XYZ to the UID of your Voltage/Current Bricklet

    ipcon = IPConnection(); % Create IP connection
    vc = handle(BrickletVoltageCurrent(UID, ipcon), 'CallbackProperties'); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current voltage
    voltage = vc.getVoltage();
    fprintf('Voltage: %g V\n', voltage/1000.0);

    % Get current current
    current = vc.getCurrent();
    fprintf('Current: %g A\n', current/1000.0);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end
