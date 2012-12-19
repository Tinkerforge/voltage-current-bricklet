using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	// Callback for current greater than 1A
	static void ReachedCB(int current)
	{
		System.Console.WriteLine("Current is greater than 1A: " + current/1000.0 + "A");
	}

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(HOST, PORT); // Create connection to brickd
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID); // Create device object
		ipcon.AddDevice(vc); // Add device to ip connection
		// Don't use device before it is added to a connection


		// Get threshold callbacks with a debounce time of 1 seconds (1000ms)
		vc.SetDebouncePeriod(1000);

		// Register threshold reached callback to function ReachedCB
		vc.RegisterCallback(new BrickletVoltageCurrent.CurrentReached(ReachedCB));

		// Configure threshold for "greater than 1A" (unit is mA)
		vc.SetCurrentCallbackThreshold('>', 1*1000, 0);

		System.Console.WriteLine("Press ctrl+c to exit");
		ipcon.JoinThread();
    }
}
