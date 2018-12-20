use std::{io, error::Error};

use tinkerforge::{ip_connection::IpConnection, 
                  voltage_current_bricklet::*};


const HOST: &str = "localhost";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Voltage/Current Bricklet.

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection.
    let vc = VoltageCurrentBricklet::new(UID, &ipcon); // Create device object.

    ipcon.connect((HOST, PORT)).recv()??; // Connect to brickd.
    // Don't use device before ipcon is connected.

		// Get current voltage.
let voltage = vc.get_voltage().recv()?;
		println!("Voltage: {} V", voltage as f32 /1000.0);

		// Get current current.
let current = vc.get_current().recv()?;
		println!("Current: {} A", current as f32 /1000.0);

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
