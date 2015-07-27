#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_voltage_current.h"

#define HOST "localhost"
#define PORT 4223
#define UID "XYZ" // Change to your UID

// Callback function for voltage greater than 5000 V (parameter has unit mV)
void cb_voltage_reached(int32_t voltage, void *user_data) {
	(void)user_data; // avoid unused parameter warning

	printf("Voltage: %f V\n", voltage/1000.0);
}

// Callback function for current greater than 1000 A (parameter has unit mA)
void cb_current_reached(int32_t current, void *user_data) {
	(void)user_data; // avoid unused parameter warning

	printf("Current: %f A\n", current/1000.0);
}

int main() {
	// Create IP connection
	IPConnection ipcon;
	ipcon_create(&ipcon);

	// Create device object
	VoltageCurrent vc;
	voltage_current_create(&vc, UID, &ipcon);

	// Connect to brickd
	if(ipcon_connect(&ipcon, HOST, PORT) < 0) {
		fprintf(stderr, "Could not connect\n");
		exit(1);
	}
	// Don't use device before ipcon is connected

	// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
	voltage_current_set_debounce_period(&vc, 10000);

	// Register threshold reached callback to function cb_voltage_reached
	voltage_current_register_callback(&vc,
	                                  VOLTAGE_CURRENT_CALLBACK_VOLTAGE_REACHED,
	                                  (void *)cb_voltage_reached,
	                                  NULL);

	// Configure threshold for "greater than 5000 V" (unit is mV)
	voltage_current_set_voltage_callback_threshold(&vc, '>', 5000*1000, 0);

	// Get threshold callbacks with a debounce time of 10 seconds (10000ms)
	voltage_current_set_debounce_period(&vc, 10000);

	// Register threshold reached callback to function cb_current_reached
	voltage_current_register_callback(&vc,
	                                  VOLTAGE_CURRENT_CALLBACK_CURRENT_REACHED,
	                                  (void *)cb_current_reached,
	                                  NULL);

	// Configure threshold for "greater than 1000 A" (unit is mA)
	voltage_current_set_current_callback_threshold(&vc, '>', 1000*1000, 0);

	printf("Press key to exit\n");
	getchar();
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
}
