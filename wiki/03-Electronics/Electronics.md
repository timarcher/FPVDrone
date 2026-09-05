This page contains details about setting up the electronics used for the Drone.

# YouTube Video
- [Let’s Build an FPV Drone – Part 3 Electronics](https://youtu.be/nHAfdJlOVx4)

# Build Notes
## Flight Controller and ESC Setup
- You must have the [Mission Planner](https://ardupilot.org/planner/docs/mission-planner-installation.html) software installed on your computer.
- Ensure your motors spin in the appropriate direction as per the [ArduCopter documentation](https://ardupilot.org/copter/docs/connect-escs-and-motors.html).
- Read the [MicoAir Getting Started Guide for ArduPilot](https://micoair.com/docs/getting-started-guide-for-ardupilot/).
- View the [pinouts of the MicoAir H743 V2 Flight controller](https://store.micoair.com/product/micoair743-v2/).
- Setup your MicoAir flight controller with the proper [ArduPilot configuration](../ArduPilot-Config/ArduPilot-Config.md) in order to be able to run a motor test.

## Transmitter and Receiver Setup
- Install the RadioMaster Ranger Micro 2.4Ghz ELRS Module in the back of your radio.
- First you need to flash the ExpressLRS Firmware on the receiver.
  - Power up the receiver. On your desktop computer you should see a WiFi network named "ExpressLRS RX". Connect to it. The default WiFi password is "expresslrs".
    - Check its IP address. If it connects with IPv6 then open the properties of the adapter and disable that.
    - You should be able to open http://10.0.0.1/ in your web browser if all connects properly.
  - Download and run the [Express LRS Configurator](https://www.expresslrs.org/quick-start/installing-configurator/).
  - Select firmware version (i.e., 3.6.0)
  - Under the target select:
    - Device Category: RadioMaster 2.4 GHz
    - Device: RadioMaster RP1 2.4GHz RX
    - Flashing Method: Wi-Fi
    - Regulatory domains 2.4 GHz band: Check the 2.4 GHz ISM (Standard) box.
    - Check the Binding phrase. Enter a custom binding phrase such as "MyDrone123".
    - It should auto detect the WIFI Device at 10.0.0.1, make sure it is selected in the WIFi Device Selection dropdown.
    - Press the flash button. It should take a minute or so where it flashes the new firmware. If you go to http://10.0.0.1/ you should see the firmware version displayed that you just flashed. You may have to reconnect to the Express LRS WiFi after the receiver reboots to get its admin page to open.
- Now ensure that you flash the latest ExpressLRS Firmware on the transmitter Ranger Micro 2.4GHz TX.
  - Connect a USB-C Cable between your PC and the RadioMaster Ranger Module.
  - Use the [Express LRS Configurator](https://www.expresslrs.org/quick-start/installing-configurator/) as used above.
  - Select firmware version (i.e., 3.6.0)
  - Under the target select:
    - Device Category: RadioMaster 2.4 GHz
    - Device: RadioMaster Ranger Micro 2.4GHz TX
    - Flashing Method: UART (Serial)
    - Regulatory domains 2.4 GHz band: Check the 2.4 GHz ISM (Standard) box.
    - Check the Binding phrase. Enter a custom binding phrase such as "MyDrone123".
    - Press the flash button. It should take a minute or so where it flashes the new firmware.
- To bind the RadioMaster TX16s transmitter to the ELRS receiver, do the following:
  - Make a new model.
  - On the model setup tab, disable Internal RF, and enable External RF.
  - On the External RF settings, set the Mode to CRSF. Leave the other defaults such as Baudrate of 921k, Channel Range set to CH1 to CH16, and Receiver set to 0.
  - The transmitter should auto bind to the receiver now since we are using the Binding Phrase.
  - After binding the LED on the receiver will go solid once linked.
  - On your TX16S, go to System → Tools → ExpressLRS (you should already have this Lua script on your SD card if you installed the ELRS firmware pack). This Lua script is the main interface for your Micro Ranger. From here you set packet rate, power, bind, WiFi, etc.
    - If you don’t see ExpressLRS in your tools menu, you’ll need to download it from the [ExpressLRS GitHub releases page](https://github.com/ExpressLRS/ExpressLRS) and put it in the /SCRIPTS/TOOLS/ folder on your radio’s SD card.
    - To get telemetry messages to display correctly in the Yaapu script:
  - Adjust telemetry ratio: Look for the Telemetry Ratio setting. Increase the ratio to a higher setting like 1:4 or 1:2. Some users report that 1:2 is required for reliable ArduPilot message display.
- In the transmitter, go to the telemetry settings for the model. Press "Discover New" to get all the telemetry items discovered. Let it sit for a minute to discover as much as possible. You should see items with values appearing such as Bat%.
- For the Yasapu telemetry on the transmitter you need to enable CRSF support.
  -  Long press [SYS] -> Tools -> Yaapu Config
  -  Scroll down and enable CRSF support.
- Be sure to set the 6 position switch to channel 6 instead of 5 for the flight mode selection. ExpressLRS hard-codes channel 5 (AUX1) as a 2-position, 1-bit arming channel for safety and system performance. This is an intentional design feature of ELRS and cannot be changed, regardless of your other radio settings. You will also need to set FLTMODE_CH to 6 in ArduPilot configuration.


## Battery Percentage by Voltage
The green battery bar in the Yaapu widget is **not** voltage based. It shows ArduPilot's remaining percentage, which is calculated purely from consumed mAh against `BATT_CAPACITY`. Neither Yaapu nor ArduPilot has a setting to switch that bar to a voltage curve ([Yaapu config menu](https://github.com/yaapu/FrskyTelemetryScript/wiki/Configuration-menu), [ArduPilot issue #12897](https://github.com/ArduPilot/ardupilot/issues/12897)). Use the options below to get a voltage-driven reading.

- **Option 1 - Align the mAh bar with your voltage cutoff** (easiest, recommended)
  - Set `BATT_CAPACITY` to the *usable* capacity, not the label capacity. For the 1800 mAh 6S pack with a 20% reserve, use `1440`.
  - Set `BATT_LOW_VOLT` = `21.6` (3.6 V x 6S) and `BATT_CRT_VOLT` = `20.4` (3.4 V x 6S).
  - Set `BATT_LOW_MAH` = `0` so the failsafe triggers on voltage only.
  - Set `BATT_FS_VOLTSRC` = `1` (sag-compensated voltage) so a hard throttle punch does not trip the failsafe early.
  - Result: the bar reaches 0% at roughly the same time the pack reaches 3.6 V/cell. Still mAh based, so it drifts as the pack ages.
- **Option 2 - Make Yaapu's alerts voltage based** (do this regardless of the above)
  - Long press **[SYS]** -> Tools -> Yaapu Config.
  - Set **battery alert level 1** to `3.60` (default is 3.75) and **battery alert level 2** to `3.50`.
  - These are per-cell values and are independent of cell count. Below level 1 you get a vocal alert and a blinking `V`; below level 2 a second alert and blinking voltage digits.
- **Option 3 - Add a true voltage gauge beside Yaapu**
  - Give Yaapu a half-screen widget slot and put a battery widget in the other half.
  - EdgeTX built-in **BattAnalog** widget: graphical charge bar from total voltage with automatic cell count detection. Its curve is fixed at 3.0-4.2 V/cell (the `Lithium_Ion` option only moves the minimum to 2.8), so it will read around 35-40% at your 3.6 V point rather than 0%.
  - For an exact 4.2 V = 100% / 3.6 V = 0% scale, use the [mahRe2 Lua widget](https://github.com/fdm225/mahRe2) instead. It has a configurable full-cell voltage and reserve percentage and reports % remaining from volts. Copy it to `/SCRIPTS/WIDGETS/` on the radio's SD card.
- **Caveat:** voltage under load is a poor state-of-charge indicator on a high-current quad. A voltage-based percentage will dive during punch-outs and recover at idle, so expect the number to bounce. The mAh count is smoother; voltage is the safer hard limit. Using both (Option 1 + Option 2) gives you the best of each.

## GPS Mount
- [3d Printed TPU Mount for GPS - Rear Option](https://www.thingiverse.com/thing:6295389) - rear mount, holds video transmitter antenna and elrs receiver antenna.
- [3d Printed TPU Mount for GPS - Front Option](https://www.thingiverse.com/thing:4759922)
- [Iflight Protek 35 BN880 GPS mast](https://www.thingiverse.com/thing:5329152) - use this if you want a different option to raise the GPS up higher.