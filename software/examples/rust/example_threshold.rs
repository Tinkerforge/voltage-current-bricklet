use std::{error::Error, io, thread};
use tinkerforge::{ipconnection::IpConnection, voltage_current_bricklet::*};

const HOST: &str = "127.0.0.1";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Voltage/Current Bricklet

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection
    let voltage_current_bricklet = VoltageCurrentBricklet::new(UID, &ipcon); // Create device object

    ipcon.connect(HOST, PORT).recv()??; // Connect to brickd
                                        // Don't use device before ipcon is connected

    // Get threshold listeners with a debounce time of 10 seconds (10000ms)
    voltage_current_bricklet.set_debounce_period(10000);

    //Create listener for power reached events.
    let power_reached_listener = voltage_current_bricklet.get_power_reached_receiver();
    // Spawn thread to handle received events. This thread ends when the voltage_current_bricklet
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for event in power_reached_listener {
            println!("Power: {}{}", event as f32 / 1000.0, " W");
        }
    });

    // Configure threshold for power "greater than 10 W"
    voltage_current_bricklet.set_power_callback_threshold('>', 10 * 1000, 0);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
