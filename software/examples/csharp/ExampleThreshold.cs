using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	// Callback function for power greater than 10 W (parameter has unit mW)
	static void PowerReachedCB(BrickletVoltageCurrent sender, int power)
	{
		System.Console.WriteLine("Power: " + power/1000.0 + " W");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		vc.SetDebouncePeriod(10000);

		// Register threshold reached callback to function PowerReachedCB
		vc.PowerReached += PowerReachedCB;

		// Configure threshold for "greater than 10 W" (unit is mW)
		vc.SetPowerCallbackThreshold('>', 10*1000, 0);

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
