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

	vc.RegisterCurrentCallback(func(current int32) {
		fmt.Printf("Current: %f A\n", float64(current)/1000.0)
	})

	// Set period for current receiver to 1s (1000ms).
	// Note: The current callback is only called every second
	//       if the current has changed since the last call!
	vc.SetCurrentCallbackPeriod(1000)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()
}
