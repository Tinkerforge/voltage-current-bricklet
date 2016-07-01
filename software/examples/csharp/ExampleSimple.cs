using System;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change XYZ to the UID of your Voltage/Current Bricklet

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get current voltage (unit is mV)
		int voltage = vc.GetVoltage();
		Console.WriteLine("Voltage: " + voltage/1000.0 + " V");

		// Get current current (unit is mA)
		int current = vc.GetCurrent();
		Console.WriteLine("Current: " + current/1000.0 + " A");

		Console.WriteLine("Press enter to exit");
		Console.ReadLine();
		ipcon.Disconnect();
	}
}
