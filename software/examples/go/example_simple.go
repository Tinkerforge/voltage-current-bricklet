package main

import (
	"fmt"
	"github.com/Tinkerforge/go-api-bindings/ipconnection"
	"github.com/Tinkerforge/go-api-bindings/voltage_current_bricklet"
)

const ADDR string = "localhost:4223"
const UID string = "XYZ" // Change XYZ to the UID of your Voltage/Current Bricklet.

func main() {
	ipcon := ipconnection.New()
	defer ipcon.Close()
	vc, _ := voltage_current_bricklet.New(UID, &ipcon) // Create device object.

	ipcon.Connect(ADDR) // Connect to brickd.
	defer ipcon.Disconnect()
	// Don't use device before ipcon is connected.

	// Get current voltage.
	voltage, _ := vc.GetVoltage()
	fmt.Printf("Voltage: %f V\n", float64(voltage)/1000.0)

	// Get current current.
	current, _ := vc.GetCurrent()
	fmt.Printf("Current: %f A\n", float64(current)/1000.0)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
