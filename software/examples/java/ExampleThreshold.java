import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletVoltageCurrent;

public class ExampleThreshold {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change to your UID

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions
	//       you might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		vc.setDebouncePeriod(10000);

		// Add power reached listener (parameter has unit mW)
		vc.addPowerReachedListener(new BrickletVoltageCurrent.PowerReachedListener() {
			public void powerReached(int power) {
				System.out.println("Power: " + power/1000.0 + " W");
			}
		});

		// Configure threshold for power "greater than 10 W" (unit is mW)
		vc.setPowerCallbackThreshold('>', 10*1000, 0);

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
