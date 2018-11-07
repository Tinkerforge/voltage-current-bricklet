use std::{error::Error, io, thread};
use tinkerforge::{ip_connection::IpConnection, voltage_current_bricklet::*};

const HOST: &str = "localhost";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Voltage/Current Bricklet.

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection.
    let vc = VoltageCurrentBricklet::new(UID, &ipcon); // Create device object.

    ipcon.connect((HOST, PORT)).recv()??; // Connect to brickd.
                                          // Don't use device before ipcon is connected.

    // Get threshold receivers with a debounce time of 10 seconds (10000ms).
    vc.set_debounce_period(10000);

    let power_reached_receiver = vc.get_power_reached_callback_receiver();

    // Spawn thread to handle received callback messages.
    // This thread ends when the `vc` object
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for power_reached in power_reached_receiver {
            println!("Power: {} W", power_reached as f32 / 1000.0);
        }
    });

    // Configure threshold for power "greater than 10 W".
    vc.set_power_callback_threshold('>', 10 * 1000, 0);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
