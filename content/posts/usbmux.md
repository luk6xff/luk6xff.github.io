+++
title="UsbMux And Relay Remote Controller"
date=2020-09-22

[taxonomies]
categories = ["electronics"]
tags = ["esp8266","arduino", "hw", "cpp"]
+++


## Project Overview

This project tackles the need for remote device control using a single USB connection for both firmware flashing and serial communication, a challenge highlighted during the pandemic. For source code, hardware schematics, build instructions, and additional images, visit the [project's GitHub repository](https://github.com/luk6xff/usbmux/tree/master).

## Core Features

- **Dual-Function USB Port:** Utilizing a USB 2.0 multiplexer, the device switches between:
    - **Flashing Mode (Bootloader):** Activated when a USB pin (USB_ID) is high, enabling firmware updates.
    - **Operational Mode:** Engages when USB_ID is low, starting the device normally for serial communication over USB.
- **Power Management:** Integrates a power relay for remote power toggling.
- **Control Interfaces:** Offers UART CLI and an HTTP server for device management through serial commands or web requests.

## Development Insights
Developed with [PlatformIO](https://platformio.org/) for C++ programming on the ESP8266 microcontroller, focusing on cost-efficiency and compact design. The TS3USB221 USB 2.0 two-channel multiplexer facilitates the USB port's dual functionality. The development prioritized technical efficacy to achieve reliable remote control and adaptable usage.

## Advantages

- **Remote Management:** Enhances the capability to remotely switch device modes, manage power, and adjust settings via both serial and web interfaces.
- **Flexibility:** The USB port's dual use and varied control interfaces provide versatile options for firmware updates and device management.

## Expanded Capabilities

- **Relay Control Extension:** The [power_relays branch](https://github.com/luk6xff/usbmux/tree/power_relays) extends functionality to manage up to 8 relays simultaneously, expanding device control capabilities.

## Summary

Focused on the TS3USB221 for its USB multiplexing capabilities, this project employs the ESP8266 microcontroller for its balance of cost and performance, streamlined for remote device control. Utilizing the PlatformIO ecosystem for C++ development ensures a streamlined, technically grounded approach to device management and firmware deployment. Further information and visuals will be updated in the project repository.

![Usb Mux Case](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/media/usbmux/usb_mux_case.png)
*Figure 1: USB Mux case ver 1.0.*

![Usb Mux Case - Power relays](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/media/usbmux/usb_mux_power_relays.png)
*Figure 2: USB Mux case ver 1.1 - branch power_relays*

![Usb Mux Case - UART CLI](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/media/usbmux/usb_mux_uart_cli.png)
*Figure 3: USB Mux UART CLI.*

![Usb Mux Case - HTTP Server](https://github.com/luk6xff/luk6xff.github.io/tree/master/content/other/media/usbmux/usb_mux_http_server.png)
*Figure 4: USB Mux HTTP Server.*
