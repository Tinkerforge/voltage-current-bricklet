import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletVoltageCurrent;

public class ExampleThreshold {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change to your UID

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions you
	//       might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletVoltageCurrent vc = new BrickletVoltageCurrent(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		vc.setDebouncePeriod(10000);

		// Configure threshold for "greater than 5000 V" (unit is mV)
		vc.setVoltageCallbackThreshold('>', 5000*1000, 0);

		// Add threshold reached listener for voltage greater than 5000 V (parameter has unit mV)
		vc.addVoltageReachedListener(new BrickletVoltageCurrent.VoltageReachedListener() {
			public void voltageReached(int voltage) {
				System.out.println("Voltage: " + voltage/1000.0 + " V");
			}
		});

		// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
		vc.setDebouncePeriod(10000);

		// Configure threshold for "greater than 1000 A" (unit is mA)
		vc.setCurrentCallbackThreshold('>', 1000*1000, 0);

		// Add threshold reached listener for current greater than 1000 A (parameter has unit mA)
		vc.addCurrentReachedListener(new BrickletVoltageCurrent.CurrentReachedListener() {
			public void currentReached(int current) {
				System.out.println("Current: " + current/1000.0 + " A");
			}
		});

		System.out.println("Press key to exit"); System.in.read();
		ipcon.disconnect();
	}
}
