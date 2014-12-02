using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	// Callback for current greater than 1A
	static void ReachedCB(BrickletVoltageCurrent sender, int current)
	{
		System.Console.WriteLine("Current is greater than 1A: " + current/1000.0 + "A");
	}

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		vc.SetDebouncePeriod(10000);

		// Register threshold reached callback to function ReachedCB
		vc.CurrentReached += ReachedCB;

		// Configure threshold for "greater than 1A" (unit is mA)
		vc.SetCurrentCallbackThreshold('>', 1*1000, 0);

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
    }
}
