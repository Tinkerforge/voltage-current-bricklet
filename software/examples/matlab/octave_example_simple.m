function octave_example_simple()
    more off;
    
    HOST = "localhost";
    PORT = 4223;
    UID = "555"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    vc = java_new("com.tinkerforge.BrickletVoltageCurrent", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current current and voltage (unit is mA and mV)
    current = vc.getCurrent();
    voltage = vc.getVoltage();
    fprintf('Current: %g A\n', current/1000.0);
    fprintf('Voltage: %g V\n', voltage/1000.0);

    input("Press any key to exit...\n", "s");
    ipcon.disconnect();
end
