using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(HOST, PORT); // Create connection to brickd
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID); // Create device object
		ipcon.AddDevice(vc); // Add device to ip connection
		// Don't use device before it is added to a connection


		// Get current current and voltage (unit is mA and mV)
		int current = vc.GetCurrent();
		int voltage = vc.GetVoltage();

		System.Console.WriteLine("Current: " + current/1000.0 + " A");
		System.Console.WriteLine("Voltage: " + voltage/1000.0 + " V");

		System.Console.WriteLine("Press ctrl+c to exit");
		ipcon.JoinThread();
    }
}
