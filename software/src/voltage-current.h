/* voltage/current-bricklet
 * Copyright (C) 2012 Olaf Lüke <olaf@tinkerforge.com>
 *
 * voltage/current.h: Implementation of Voltage/Current Bricklet messages
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

#ifndef VOLTAGE_CURRENT_H
#define VOLTAGE_CURRENT_H

#include <stdint.h>

#include "bricklib/com/com_common.h"

#define FID_GET_CURRENT 1
#define FID_GET_VOLTAGE 2
#define FID_GET_POWER 3
#define FID_SET_CONFIGURATION 4
#define FID_GET_CONFIGURATION 5
#define FID_SET_CALIBRATION 6
#define FID_GET_CALIBRATION 7
#define FID_SET_CURRENT_CALLBACK_PERDIOD 8
#define FID_GET_CURRENT_CALLBACK_PERDIOD 9
#define FID_SET_VOLTAGE_CALLBACK_PERDIOD 10
#define FID_GET_VOLTAGE_CALLBACK_PERDIOD 11
#define FID_SET_POWER_CALLBACK_PERDIOD 12
#define FID_GET_POWER_CALLBACK_PERDIOD 13
#define FID_SET_CURRENT_CALLBACK_THRESHOLD 14
#define FID_GET_CURRENT_CALLBACK_THRESHOLD 15
#define FID_SET_VOLTAGE_CALLBACK_THRESHOLD 16
#define FID_GET_VOLTAGE_CALLBACK_THRESHOLD 17
#define FID_SET_POWER_CALLBACK_THRESHOLD 18
#define FID_GET_POWER_CALLBACK_THRESHOLD 19
#define FID_SET_DEBOUNCE_PERIOD 20
#define FID_GET_DEBOUNCE_PERIOD 22
#define FID_CURRENT 22
#define FID_VOLTAGE 23
#define FID_POWER 24
#define FID_CURRENT_REACHED 25
#define FID_VOLTAGE_REACHED 26
#define FID_POWER_REACHED 27

#define FID_LAST 27

typedef struct {
	uint8_t stack_id;
	uint8_t type;
	uint16_t length;
	uint8_t averaging;
	uint8_t voltage_conversion_time;
	uint8_t current_conversion_time;
} __attribute__((__packed__)) SetConfiguration;

typedef struct {
	uint8_t stack_id;
	uint8_t type;
	uint16_t length;
} __attribute__((__packed__)) GetConfiguration;

typedef struct {
	uint8_t stack_id;
	uint8_t type;
	uint16_t length;
	uint8_t averaging;
	uint8_t voltage_conversion_time;
	uint8_t current_conversion_time;
} __attribute__((__packed__)) GetConfigurationReturn;

typedef struct {
	uint8_t stack_id;
	uint8_t type;
	uint16_t length;
	uint16_t gain_multiplier;
	uint16_t gain_divisor;
} __attribute__((__packed__)) SetCalibration;

typedef struct {
	uint8_t stack_id;
	uint8_t type;
	uint16_t length;
} __attribute__((__packed__)) GetCalibration;

typedef struct {
	uint8_t stack_id;
	uint8_t type;
	uint16_t length;
	uint16_t gain_multiplier;
	uint16_t gain_divisor;
} __attribute__((__packed__)) GetCalibrationReturn;

typedef struct {
	uint8_t stack_id;
	uint8_t type;
	uint16_t length;
} __attribute__((__packed__)) StandardMessage;

void set_configuration(const ComType com, const SetConfiguration *data);
void get_configuration(const ComType com, const GetConfiguration *data);
void set_calibration(const ComType com, const SetCalibration *data);
void get_calibration(const ComType com, const GetCalibration *data);

#define CURRENT_40OHM_MUL 625
#define CURRENT_40OHM_DIV 1024
#define VOLTAGE_MUL 5
#define VOLTAGE_DIV 4

#define CALIBRATION_EEPROM_POSITION (BRICKLET_PLUGIN_MAX_SIZE + 96)

#define INA226_REG_CONFIGURATION 0x00
#define INA226_REG_SHUNT_VOLTAGE 0x01
#define INA226_REG_BUS_VOLTAGE   0x02
#define INA226_REG_POWER         0x03
#define INA226_REG_CURRENT       0x04
#define INA226_REG_CALIBRATION   0x05
#define INA226_REG_MASK_ENABLE   0x06
#define INA226_REG_ALERT_LIMIT   0x07
#define INA226_REG_DIE_ID        0xFF

#define INA226_CONF_AVERAGING(val)         ((val) << 9)
#define INA226_CONF_CONVERSION_BV(val)     ((val) << 6)
#define INA226_CONF_CONVERSION_SV(val)     ((val) << 3)
#define INA226_CONF_OPERATING_MODE(val)    ((val) << 0)

#define INA226_DEFAULT_AVERAGING           3
#define INA226_DEFAULT_CONVERSION_BV       4
#define INA226_DEFAULT_CONVERSION_SV       4
#define INA226_DEFAULT_OPERATING_MODE      7

#define INA226_MASK_SV_OVER_VOLTAGE        1 << 15
#define INA226_MASK_SV_UNDER_VOLTAGE       1 << 14
#define INA226_MASK_BV_OVER_VOLTAGE        1 << 13
#define INA226_MASK_BV_UNDER_VOLTAGE       1 << 12
#define INA226_MASK_OVER_LIMIT_POWER       1 << 11
#define INA226_MASK_CONVERSION_READY       1 << 10
#define INA226_MASK_ALERT_FUNCTION_FLAG    1 << 4
#define INA226_MASK_CONVERSION_READY_FLAG  1 << 3
#define INA226_MASK_MATH_OVERFLOW_FLAG     1 << 2
#define INA226_MASK_ALERT_POLARITY         1 << 1
#define INA226_MASK_ALTER_LATCH_ENABLE     1 << 0

void eeprom_read_calibration(void);
void eeprom_write_calibration(void);
void ina226_write_calibration(void);
uint16_t ina226_read_mask(void);
void ina226_write_mask(void);
uint8_t ina226_get_address(void);
void ina226_configure(void);
int16_t ina226_read_register(const uint8_t reg);
void ina226_write_register(const uint8_t reg, const uint16_t value);

void invocation(uint8_t com, uint8_t *data);
void constructor(void);
void destructor(void);
void tick(const uint8_t tick_type);

#endif
