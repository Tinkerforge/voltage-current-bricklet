import com.tinkerforge.BrickletVoltageCurrent;
import com.tinkerforge.IPConnection;

public class ExampleSimple {
	private static final String host = "localhost";
	private static final int port = 4223;
	private static final String UID = "ABC"; // Change to your UID
	
	// Note: To make the example code cleaner we do not handle exceptions. Exceptions you
	//       might normally want to catch are described in the commnents below
	public static void main(String args[]) throws Exception {
		// Create connection to brickd
		IPConnection ipcon = new IPConnection(host, port); // Can throw IOException
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID); // Create device object

		// Add device to IP connection
		ipcon.addDevice(vc); // Can throw IPConnection.TimeoutException
		// Don't use device before it is added to a connection

		// Get current current and voltage (unit is mA and mV)
		int current = vc.getCurrent(); // Can throw IPConnection.TimeoutException
		int voltage = vc.getVoltage(); // Can throw IPConnection.TimeoutException

		System.out.println("Current: " + current/1000.0 + " A");
		System.out.println("Voltgae: " + voltage/1000.0 + " V");

		System.console().readLine("Press key to exit\n");
		ipcon.destroy();
	}
}
