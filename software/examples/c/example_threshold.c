
#include <stdio.h>

#include "ip_connection.h"
#include "bricklet_voltage_current.h"

#define HOST "localhost"
#define PORT 4223
#define UID "ABCD" // Change to your UID

// Callback for current greater than 1A
void cb_reached(int16_t current, void *user_data) {
	(void)user_data;

	printf("Current is greater than 1A: %f\n", current/1000.0);
}

int main() {
	// Create ip connection to brickd
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

	// Register threshold reached callback to function cb_reached
	voltage_current_register_callback(&vc,
	                                  VOLTAGE_CURRENT_CALLBACK_CURRENT_REACHED,
	                                  (void *)cb_reached,
	                                  NULL);

	// Configure threshold for "greater than 1A" (unit is mA)
	voltage_current_set_current_callback_threshold(&vc, '>', 1*1000, 0);

	printf("Press key to exit\n");
	getchar();
	ipcon_destroy(&ipcon); // Calls ipcon_disconnect internally
}
