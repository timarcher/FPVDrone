This page contains details about setting up the electronics used for the Drone.

# YouTube Video
- TBD

# Build Notes
## Transmitter and Receiver Setup
- Ensure your motors spin in the appropriate direction as per the [ArduCopter documentation](https://ardupilot.org/copter/docs/connect-escs-and-motors.html).
- Read the [MicoAir Getting Started Guide for ArduPilot](https://micoair.com/docs/getting-started-guide-for-ardupilot/).
- View the [pinouts of the MicoAir H743 V2 Flight controller0(https://store.micoair.com/product/micoair743-v2/).
- Setup your MicoAir flight controller with the proper [ArduPilot configuration](../ArduPilot-Config/ArduPilot-Config.md) in order to be able to run a motor test.
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
  - On the External RF settings, set the Mode to CRSF. Leave the other defaults such as Baudrate of 400k, Channel Range set to CH1 to CH16, and Receiver set to 0.
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