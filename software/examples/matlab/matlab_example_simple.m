function matlab_example_simple()
    import com.tinkerforge.IPConnection;
    import com.tinkerforge.BrickletVoltageCurrent;

    HOST = 'localhost';
    PORT = 4223;
    UID = 'XYZ'; % Change to your UID

    ipcon = IPConnection(); % Create IP connection
    vc = BrickletVoltageCurrent(UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current voltage (unit is mV)
    voltage = vc.getVoltage();
    fprintf('Voltage: %g V\n', voltage/1000.0);

    % Get current current (unit is mA)
    current = vc.getCurrent();
    fprintf('Current: %g A\n', current/1000.0);

    input('Press key to exit\n', 's');
    ipcon.disconnect();
end
