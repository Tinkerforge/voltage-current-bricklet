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

    let current_receiver = vc.get_current_callback_receiver();

    // Spawn thread to handle received callback messages.
    // This thread ends when the `vc` object
    // is dropped, so there is no need for manual cleanup.
    thread::spawn(move || {
        for current in current_receiver {
            println!("Current: {} A", current as f32 / 1000.0);
        }
    });

    // Set period for current receiver to 1s (1000ms).
    // Note: The current callback is only called every second
    //       if the current has changed since the last call!
    vc.set_current_callback_period(1000);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
