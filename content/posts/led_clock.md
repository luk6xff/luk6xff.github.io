+++
title="Led Clock"
date=2021-07-18

[taxonomies]
categories = ["electronics"]
tags = ["esp32","arduino", "hw", "cpp", "rtos"]
+++

## A Supercharged LED Clock
Today, we're diving into one of my latest small projects that's perfect for anyone who loves building and coding. It's an LED clock, but not your average timekeeper. This one offers features like weather updates, automatic time adjustments, and even a web interface for tweaking things on the fly. Let's break down what makes this clock tick (literally).
Note: All the pictures, videos and schematics to be found in the [project's GitHub repository](https://github.com/luk6xff/led-clock/tree/master)

## Tech Toolbox
* **ESP32 Microcontroller:** The ESP32 boasts dual cores and real-time operating system (FreeRTOS) capabilities, allowing for smoother multitasking and handling complex tasks efficiently.
* **MAX7219 LED Driver:** This chip controls the cool LED 4 MATRIX 32x8-MAX7219, making those numbers and letters shine bright.
* **DS3231 Real-Time Clock (RTC):** This keeps perfect time even during power outages, thanks to a backup battery.
* **BH1750FVI Ambient light sensor:** Used to modify the brightness of the display automatically
* **LORA Sensor (Optional):** Want weather displayed on your clock? This sensor grabs temperature and humidity data for you.
* **Plus some wires, resistors, capacitors**
* Full BOM available [HERE](https://github.com/luk6xff/led-clock/blob/master/docs/BOM.md)


## Coding with PlatformIO
While the project leverages the familiar Arduino environment for coding the logic, it utilizes PlatformIO as the development platform. PlatformIO is a powerful tool that offers a streamlined experience for working with various microcontroller boards, including the ESP32 used in this project. It integrates seamlessly with popular code editors like Visual Studio Code, making development and debugging more efficient.

The code itself handles everything from keeping time to controlling the display, talking to sensors (if you use them), and interacting with the web interface. This web interface lets you adjust things like time zones, weather app settings, and how the clock looks – all from your web browser.


## More Than Just Telling Time
This LED clock is packed with the folowing features:

* **Automatic Time Updates:** Never worry about setting the time again! The clock can sync up with the internet to stay perfectly accurate. It also supports timezones and time changes.
* **Current weather and forecasts:**  See the weather forecasts, nowcasts from [openweathermap.org](https://openweathermap.org/) on the display.
* **Weather station:**  See the current temperature, pressure or humidity (if you have the LORA sensor) right on your clock.
* **Over-the-Air (OTA) Updates:** Keep your clock's firmware up-to-date by uploading new versions wirelessly. This ensures you have the latest features and bug fixes without needing to physically reconnect the clock to your computer.
* **Web Tweaks:** Change settings and customize how the clock looks using any web browser on your network.
* **Make it Yours:** Play around with different display styles, animations, and brightness levels to personalize your clock.

## Building and Beyond
The [project's GitHub repository](https://github.com/luk6xff/led-clock/tree/master) has detailed instructions and a shopping list (Bill of Materials) to help you put it all together. Since it's open-source, you can also get creative and add your own touches! If you run into any issues or want to learn more ping me directly.

## Summary
This LED clock project was a perfect project to learn more about ESP32 architecture and build something useful at once.
