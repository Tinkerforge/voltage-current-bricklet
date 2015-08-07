using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change to your UID

	// Callback function for current callback (parameter has unit mA)
	static void CurrentCB(BrickletVoltageCurrent sender, int current)
	{
		System.Console.WriteLine("Current: " + current/1000.0 + " A");
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Set period for current callback to 1s (1000ms)
		// Note: The current callback is only called every second
		//       if the current has changed since the last call!
		vc.SetCurrentCallbackPeriod(1000);

		// Register current callback to function CurrentCB
		vc.Current += CurrentCB;

		System.Console.WriteLine("Press enter to exit");
		System.Console.ReadLine();
		ipcon.Disconnect();
	}
}
