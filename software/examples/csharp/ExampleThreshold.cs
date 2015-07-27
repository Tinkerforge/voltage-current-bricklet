using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	// Callback function for voltage greater than 5000 V (parameter has unit mV)
	static void VoltageReachedCB(BrickletVoltageCurrent sender, int voltage)
	{
		System.Console.WriteLine("Voltage: " + voltage/1000.0 + " V");
	}

	// Callback function for current greater than 1000 A (parameter has unit mA)
	static void CurrentReachedCB(BrickletVoltageCurrent sender, int current)
	{
		System.Console.WriteLine("Current: " + current/1000.0 + " A");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		vc.SetDebouncePeriod(10000);

		// Register threshold reached callback to function VoltageReachedCB
		vc.VoltageReached += VoltageReachedCB;

		// Configure threshold for "greater than 5000 V" (unit is mV)
		vc.SetVoltageCallbackThreshold('>', 5000*1000, 0);

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		vc.SetDebouncePeriod(10000);

		// Register threshold reached callback to function CurrentReachedCB
		vc.CurrentReached += CurrentReachedCB;

		// Configure threshold for "greater than 1000 A" (unit is mA)
		vc.SetCurrentCallbackThreshold('>', 1000*1000, 0);

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
