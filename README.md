# STM32 PWM Configuration Finder

## Overview
This project provides a MATLAB script for calculating and listing all possible configurations for generating a desired PWM frequency using the basic timers of the STM32 microcontroller family. The script determines suitable values for Prescaler (PSC) and Auto-Reload Register (ARR) that produce the closest possible frequency within a given tolerance.

This script is useful for simple PWM generation and can be applied to basic timers (e.g., TIM2, TIM3, TIM4) in STM32F1, making it ideal for tasks such as LED dimming, motor control, and other applications requiring precise PWM signals.

## How It Works

The PWM frequency in STM32 is determined using the following equation:

$$
f_{\text{PWM}} = \frac{f_{\text{timer}}}{(PSC+1) \times (ARR+1)}
$$

where:
- `f_PWM` is the output PWM frequency,
- `f_timer` is the timer clock frequency (typically **72 MHz** in STM32F1),
- `PSC` is the prescaler value (0 to 65535),
- `ARR` is the auto-reload register value (1 to 65535).

The script:

* Defines the timer clock frequency (typically 72 MHz for STM32F1).
* Takes a desired PWM frequency as input.
* Iterates through all possible PSC values (0–65535).
* Calculates the optimal ARR values to achieve the desired frequency.
* Filters results based on valid ARR values and an error tolerance.
* Computes the actual frequency, relative error, and resolution (in bits).
* Sorts and displays the best matching configurations.

## Usage
* Run the script in MATLAB.
* Modify the desired frequency and tolerance as needed.
* The script outputs a table with valid configurations.
* Optionally, save the results as a CSV file for later use.

## Potential Applications
This tool is useful for:

* Embedded developers working with STM32 timers and PWM.
* Simple PWM generation in applications such as motor control, servo positioning, and LED dimming.
* Frequency generation tasks where exact timing is required.
* Educational purposes, demonstrating how STM32 timers, prescalers, and ARR values interact.
