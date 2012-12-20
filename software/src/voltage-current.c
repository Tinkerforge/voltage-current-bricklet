/* voltage/current-bricklet
 * Copyright (C) 2012 Olaf Lüke <olaf@tinkerforge.com>
 *
 * voltage-current.c: Implementation of Voltage/Current Bricklet messages
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "voltage-current.h"

#include "brickletlib/bricklet_entry.h"
#include "bricklib/bricklet/bricklet_communication.h"
#include "config.h"

#define I2C_EEPROM_ADDRESS_HIGH 84

#define I2C_ADDRESS_HIGH 65 // 0b1000001
#define I2C_ADDRESS_LOW 64 // 0b1000000
#define I2C_INTERNAL_ADDRESS_CURRENT 0x0
#define I2C_INTERNAL_ADDRESS_BYTES 1
#define I2C_DATA_LENGTH 2

#define SIMPLE_UNIT_CURRENT 0
#define SIMPLE_UNIT_VOLTAGE 1
#define SIMPLE_UNIT_POWER 2

const SimpleMessageProperty smp[] = {
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_VALUE,     SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT
	{SIMPLE_UNIT_VOLTAGE, SIMPLE_TRANSFER_VALUE,     SIMPLE_DIRECTION_GET}, // TYPE_GET_VOLTAGE
	{SIMPLE_UNIT_POWER,   SIMPLE_TRANSFER_VALUE,     SIMPLE_DIRECTION_GET}, // TYPE_GET_POWER
	{0, 0, 0}, // TYPE_SET_CONFIGURATION
	{0, 0, 0}, // TYPE_GET_CONFIGURATION
	{0, 0, 0}, // TYPE_SET_CALIBRATION
	{0, 0, 0}, // TYPE_GET_CALIBRATION
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_PERIOD,    SIMPLE_DIRECTION_SET}, // TYPE_SET_CURRENT_CALLBACK_PERIOD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_PERIOD,    SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT_CALLBACK_PERIOD
	{SIMPLE_UNIT_VOLTAGE, SIMPLE_TRANSFER_PERIOD,    SIMPLE_DIRECTION_SET}, // TYPE_SET_VOLTAGE_CALLBACK_PERIOD
	{SIMPLE_UNIT_VOLTAGE, SIMPLE_TRANSFER_PERIOD,    SIMPLE_DIRECTION_GET}, // TYPE_GET_VOLTAGE_CALLBACK_PERIOD
	{SIMPLE_UNIT_POWER,   SIMPLE_TRANSFER_PERIOD,    SIMPLE_DIRECTION_SET}, // TYPE_SET_POWER_CALLBACK_PERIOD
	{SIMPLE_UNIT_POWER,   SIMPLE_TRANSFER_PERIOD,    SIMPLE_DIRECTION_GET}, // TYPE_GET_POWER_CALLBACK_PERIOD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_SET}, // TYPE_SET_CURRENT_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_VOLTAGE, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_SET}, // TYPE_SET_VOLTAGE_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_VOLTAGE, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_GET}, // TYPE_GET_VOLTAGE_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_POWER,   SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_SET}, // TYPE_SET_POWER_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_POWER,   SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_GET}, // TYPE_GET_POWER_CALLBACK_THRESHOLD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_SET}, // TYPE_SET_DEBOUNCE_PERIOD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_GET}, // TYPE_GET_DEBOUNCE_PERIOD
};

const SimpleUnitProperty sup[] = {
	{NULL, SIMPLE_SIGNEDNESS_INT, FID_CURRENT, FID_CURRENT_REACHED, SIMPLE_UNIT_CURRENT}, // current
	{NULL, SIMPLE_SIGNEDNESS_INT, FID_VOLTAGE, FID_CURRENT_REACHED, SIMPLE_UNIT_CURRENT}, // voltage
	{NULL, SIMPLE_SIGNEDNESS_INT, FID_POWER, FID_CURRENT_REACHED, SIMPLE_UNIT_CURRENT} // power
};

const uint8_t smp_length = sizeof(smp);

void invocation(uint8_t com, uint8_t *data) {
	switch(((StandardMessage*)data)->type) {
		case FID_SET_CONFIGURATION: {
			set_configuration(com, (SetConfiguration*)data);
			return;
		}

		case FID_GET_CONFIGURATION: {
			get_configuration(com, (GetConfiguration*)data);
			return;
		}

		case FID_SET_CALIBRATION: {
			set_calibration(com, (SetCalibration*)data);
			return;
		}

		case FID_GET_CALIBRATION: {
			get_calibration(com, (GetCalibration*)data);
			return;
		}

		default: {
			simple_invocation(com, data);
			break;
		}
	}
}

void constructor(void) {
	simple_constructor();

	BC->pin_alert = &BS->pin2_da;
	BC->pin_alert->type = PIO_INPUT;
	BC->pin_alert->attribute = PIO_PULLUP;
	BA->PIO_Configure(BC->pin_alert, 1);

	BC->averaging = INA226_DEFAULT_AVERAGING;
	BC->voltage_conversion_time = INA226_DEFAULT_CONVERSION_BV;
	BC->current_conversion_time = INA226_DEFAULT_CONVERSION_SV;

	ina226_configure();
	eeprom_read_calibration();
	ina226_write_mask();

	// 2 Milliohm
	// (((0.002/(2.5/1000/1000))*2097.152)/2048)*40.0 = 2^15

	// 4 Milliohm
	// (((0.004/(2.5/1000/1000))*2097.152)/2048)*20.0 = 2^15
	ina226_write_register(INA226_REG_CALIBRATION, 2048);
}

void destructor(void) {
	simple_destructor();
}

void tick(const uint8_t tick_type) {
    if(!(BC->pin_alert->pio->PIO_PDSR & BC->pin_alert->mask)) {
    	if(BA->mutex_take(*BA->mutex_twi_bricklet, 10)) {
    		if(BC->gain_muldiv[1] != 0) {
    			BC->value[SIMPLE_UNIT_CURRENT] = (ina226_read_register(INA226_REG_CURRENT)*CURRENT_40OHM_MUL/CURRENT_40OHM_DIV)*BC->gain_muldiv[0]/BC->gain_muldiv[1];
    		} else {
    			BC->value[SIMPLE_UNIT_CURRENT] = ina226_read_register(INA226_REG_CURRENT);
    		}
    		BC->value[SIMPLE_UNIT_VOLTAGE] = ina226_read_register(INA226_REG_BUS_VOLTAGE)*VOLTAGE_MUL/VOLTAGE_DIV;

    		// clear alert pin
    		ina226_read_mask();
    		BA->mutex_give(*BA->mutex_twi_bricklet);

    		BC->value[SIMPLE_UNIT_POWER]   = BC->value[SIMPLE_UNIT_CURRENT]*BC->value[SIMPLE_UNIT_VOLTAGE]/1000;
    	}
    }

	simple_tick(tick_type);
}

void eeprom_read_calibration(void) {
	BA->bricklet_select(BS->port - 'a');
	BA->i2c_eeprom_master_read(BA->twid->pTwi,
	                           CALIBRATION_EEPROM_POSITION,
	                           (char *)BC->gain_muldiv,
	                            4);
	BA->bricklet_deselect(BS->port - 'a');
}

void eeprom_write_calibration(void) {
	BA->bricklet_select(BS->port - 'a');
	BA->i2c_eeprom_master_write(BA->twid->pTwi,
	                            CALIBRATION_EEPROM_POSITION,
	                            (char *)BC->gain_muldiv,
	                            4);
	BA->bricklet_deselect(BS->port - 'a');
	if(BC->gain_muldiv[0] == 0 || BC->gain_muldiv[1] == 0) {
		BC->gain_muldiv[0] = 1;
		BC->gain_muldiv[1] = 1;
	}
}

uint8_t ina226_get_address(void) {
	if(BS->address == I2C_EEPROM_ADDRESS_HIGH) {
		return I2C_ADDRESS_HIGH;
	} else {
		return I2C_ADDRESS_LOW;
	}
}

uint16_t ina226_read_mask(void) {
	return ina226_read_register(INA226_REG_MASK_ENABLE);
}

void ina226_write_mask(void) {
	ina226_write_register(INA226_REG_MASK_ENABLE, INA226_MASK_CONVERSION_READY);
}

void ina226_configure(void) {
	ina226_write_register(INA226_REG_CONFIGURATION,
	                      INA226_CONF_AVERAGING(BC->averaging) |
	                      INA226_CONF_CONVERSION_BV(BC->voltage_conversion_time) |
	                      INA226_CONF_CONVERSION_SV(BC->current_conversion_time) |
	                      INA226_CONF_OPERATING_MODE(INA226_DEFAULT_OPERATING_MODE));
}

int16_t ina226_read_register(const uint8_t reg) {
	const uint8_t port = BS->port - 'a';
	uint8_t value_be[2];

	BA->bricklet_select(port);

	BA->TWID_Read(BA->twid,
	              ina226_get_address(),
	              reg,
	              1,
	              value_be,
	              2,
	              NULL);

	BA->bricklet_deselect(port);


	return value_be[1] | (value_be[0] << 8);
}

void ina226_write_register(const uint8_t reg, const uint16_t value) {
	const uint8_t port = BS->port - 'a';

	uint8_t value_be[2];
	value_be[0] = ((uint8_t*)&value)[1];
	value_be[1]= ((uint8_t*)&value)[0];

	BA->bricklet_select(port);

	BA->TWID_Write(BA->twid,
	               ina226_get_address(),
	               reg,
	               1,
	               value_be,
	               2,
	               NULL);

	BA->bricklet_deselect(port);
}

void set_configuration(const ComType com, const SetConfiguration *data) {
	BC->averaging               = data->averaging;
	BC->current_conversion_time = data->current_conversion_time;
	BC->voltage_conversion_time = data->voltage_conversion_time;

	ina226_configure();
}

void get_configuration(const ComType com, const GetConfiguration *data) {
	GetConfigurationReturn gcr;

	gcr.stack_id                = data->stack_id;
	gcr.type                    = data->type;
	gcr.length                  = sizeof(GetConfigurationReturn);
	gcr.averaging               = MIN(BC->averaging, 7);
	gcr.current_conversion_time = MIN(BC->current_conversion_time, 7);
	gcr.voltage_conversion_time = MIN(BC->voltage_conversion_time, 7);

	BA->send_blocking_with_timeout(&gcr,
	                               sizeof(GetConfigurationReturn),
	                               com);
}

void set_calibration(const ComType com, const SetCalibration *data) {
	BC->gain_muldiv[0]  = data->gain_multiplier;
	BC->gain_muldiv[1]  = data->gain_divisor;

	eeprom_write_calibration();
}

void get_calibration(const ComType com, const GetCalibration *data) {
	GetCalibrationReturn gcr;

	gcr.stack_id        = data->stack_id;
	gcr.type            = data->type;
	gcr.length          = sizeof(GetCalibrationReturn);
	gcr.gain_multiplier = BC->gain_muldiv[0];
	gcr.gain_divisor    = BC->gain_muldiv[1];

	BA->send_blocking_with_timeout(&gcr,
	                               sizeof(GetCalibrationReturn),
	                               com);
}
