/*
 * Copyright (c) 2016 Intel Corporation
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/**
 * @file Sample app to demonstrate PWM-based servomotor control
 */

#include <zephyr/kernel.h>
#include <zephyr/sys/printk.h>
#include <zephyr/device.h>
#include <zephyr/drivers/pwm.h>

/* period of servo motor signal ->  20ms (50Hz) */
#define PERIOD (USEC_PER_SEC / 50U)

static const struct pwm_dt_spec servo = PWM_DT_SPEC_GET(DT_NODELABEL(servo));
static const uint32_t min_pulse = DT_PROP(DT_NODELABEL(servo), min_pulse);
static const uint32_t max_pulse = DT_PROP(DT_NODELABEL(servo), max_pulse);

#define STEP PWM_USEC(10)

enum direction
{
	DOWN,
	UP,
};

void main(void)
{
	int ret;

	printk("Servomotor control\n");
	printk("  device: %s\n", servo.dev->name);
	printk("  channel: %d\n", servo.channel);
	printk("  period: %d\n", servo.period);

	if (!device_is_ready(servo.dev))
	{
		printk("Error: PWM device %s is not ready\n", servo.dev->name);
		return;
	}

	uint32_t pulse_width = (min_pulse + max_pulse) / 2;
	enum direction dir = UP;
	while (1)
	{
		ret = pwm_set_pulse_dt(&servo, pulse_width);
		// ret = pwm_set_dt(&servo, PERIOD, pulse_width);
		// ret = pwm_pin_set_usec(servo.dev, 1, PERIOD, pulse_width, servo.flags);
		// ret = pwm_set(servo.dev, servo.channel, PERIOD, pulse_width, servo.flags);
		if (ret < 0)
		{
			printk("Error %d: failed to set pulse width to %d \n", ret, pulse_width);
		}

		if (dir == DOWN)
		{
			if (pulse_width <= min_pulse)
			{
				dir = UP;
				pulse_width = min_pulse;
			}
			else
			{
				pulse_width -= STEP;
			}
		}
		else
		{
			pulse_width += STEP;

			if (pulse_width >= max_pulse)
			{
				dir = DOWN;
				pulse_width = max_pulse;
			}
		}

		k_sleep(K_SECONDS(1) / 10);
	}
}
