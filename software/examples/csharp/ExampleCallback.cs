using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	// Callback function for current callback (parameter has unit mA)
	static void CurrentCB(int current)
	{
		System.Console.WriteLine("Current: " + current/1000.0 + " A");
	}

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(HOST, PORT); // Create connection to brickd
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID); // Create device object
		ipcon.AddDevice(vc); // Add device to ip connection
		// Don't use device before it is added to a connection


		// Set Period for current callback to 1s (1000ms)
		// Note: The current callback is only called every second if the 
		//       current has changed since the last call!
		vc.SetCurrentCallbackPeriod(1000);

		// Register current callback to function CurrentCB
		vc.RegisterCallback(new BrickletVoltageCurrent.Current(CurrentCB));

		System.Console.WriteLine("Press ctrl+c to exit");
		ipcon.JoinThread();
    }
}
