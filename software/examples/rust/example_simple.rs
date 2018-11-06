use std::{error::Error, io};

use tinkerforge::{ipconnection::IpConnection, voltage_current_bricklet::*};

const HOST: &str = "127.0.0.1";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your Voltage/Current Bricklet

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection
    let voltage_current_bricklet = VoltageCurrentBricklet::new(UID, &ipcon); // Create device object

    ipcon.connect(HOST, PORT).recv()??; // Connect to brickd
                                        // Don't use device before ipcon is connected

    // Get current voltage
    let voltage = voltage_current_bricklet.get_voltage().recv()?;
    println!("Voltage: {}{}", voltage as f32 / 1000.0, " V");

    // Get current current
    let current = voltage_current_bricklet.get_current().recv()?;
    println!("Current: {}{}", current as f32 / 1000.0, " A");

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
