using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "ABC"; // Change to your UID

	static void Main() 
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get current current and voltage (unit is mA and mV)
		int current = vc.GetCurrent();
		int voltage = vc.GetVoltage();

		System.Console.WriteLine("Current: " + current/1000.0 + " A");
		System.Console.WriteLine("Voltage: " + voltage/1000.0 + " V");

		System.Console.WriteLine("Press key to exit");
		System.Console.ReadKey();
    }
}
