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

	// Get threshold receivers with a debounce time of 10 seconds (10000ms).
	vc.SetDebouncePeriod(10000)

	vc.RegisterPowerReachedCallback(func(power int32) {
		fmt.Printf("Power: %f W\n", float64(power)/1000.0)
	})

	// Configure threshold for power "greater than 10 W".
	vc.SetPowerCallbackThreshold('>', 10*1000, 0)

	fmt.Print("Press enter to exit.")
	fmt.Scanln()

}
