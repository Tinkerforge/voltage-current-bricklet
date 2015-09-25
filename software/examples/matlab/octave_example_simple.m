function octave_example_simple()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change to your UID

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    vc = java_new("com.tinkerforge.BrickletVoltageCurrent", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Get current voltage (unit is mV)
    voltage = vc.getVoltage();
    fprintf("Voltage: %g V\n", voltage/1000.0);

    % Get current current (unit is mA)
    current = vc.getCurrent();
    fprintf("Current: %g A\n", current/1000.0);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end
