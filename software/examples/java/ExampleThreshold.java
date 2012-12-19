import com.tinkerforge.BrickletVoltageCurrent;
import com.tinkerforge.IPConnection;

public class ExampleThreshold {
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

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		vc.setDebouncePeriod(10000);

		// Configure threshold for "greater than 1A" (unit is mA)
		vc.setCurrentCallbackThreshold('>', 1*1000, 0);

		// Add and implement current reached listener (called if current is greater than 1A)
		vc.addListener(new BrickletVoltageCurrent.CurrentReachedListener() {
			public void currentReached(int current) {
				System.out.println("Current is greater than 1A: " + current/1000.0);
			}
		});

		System.console().readLine("Press key to exit\n");
		ipcon.destroy();
	}
}
