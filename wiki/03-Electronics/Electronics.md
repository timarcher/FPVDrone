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

## Yaapu Battery Alarm Config
To get the Yaapu telemetry widget to show remaining battery based on pack voltage instead of computed mAh, do the following:
- On the RadioMaster TX16s with Yaapu widget already installed, press the Sys button.
- Scroll down to Yaapu Config in the Apps.
- Set enable battery % by voltage to yes.
- Configure batt alert level 1 to be the Ardupilot BATT_LOW_VOLT value divided by the number of cells.
- Configure batt alert level 2 to be the Ardupilot BATT_CRT_VOLT value divided by the number of cells.
- Press Exit/Rtn to save.
- Put the battery curve file on the radio SD card. 
  - Copy the file modelname_batt.lua into /WIDGETS/yaapu/cfg/
  - You must rename it before using it. Take the active model name on your TX16S, convert it to lowercase, remove spaces and punctuation, then append _batt.lua. For example, a radio model named ProTek 35 requires protek35_batt.lu
  - Restart the radio after copying the file so Yaapu loads it, then check with the aircraft disarmed and telemetry connected. The widget loads the curve from the model-specific file.

## Yaapu Map Display
- Switch off the Yaapu telemetry screen to the normal screen by cycling through the page buttons.
- Short-press TELE. You should see a settings page with numbered screen tabs across the top and options such as Layout, Setup widgets, and Top bar.
- Select the + tab across the top
- Set Layout to one large, undivided rectangle.
Turn off the surrounding display elements for this new screen: Top bar, Flight mode, Sliders, and Trims, where shown. Older versions may combine the last two as Sliders+Trims. Leave your original screen’s settings alone.
- Select Setup widgets and click the wheel. You should now see the large widget area outlined on the display.
- Select that large empty area, then choose Yaapu from the widget list. Click the wheel to confirm. EdgeTX normally opens the new widget’s configuration options immediately afterward.
- In the widget options, find Screen Type. On older Yaapu versions, the option is named Page.
- Change it to 5. Select the number, click the wheel, turn it until it reads 5, then click to confirm. Type 5 is the map; type 1 is the normal instrument display.
- Press RTN to back out to the normal display. Use PAGE> or PAGE< to move between your original Yaapu screen and the new map screen.

## Yaapu Map Display - Adding Map Tiles
- Power on radio. Connect usb cable to the top USB port. Select USB storage mode.
- Navigate to https://martinovem.github.io/High-Resolution-Map-Generator/
- Make the following selections:
  - Output Target Widget: Yaapu
  - Yaapu Sub-Target: Yaapu – EdgeTX
  - Provider: Google High-Res
  - Map Type: Hybrid (Sat + Labels)
  - Min Zoom: 16 as a starting point
  - Max Zoom: 18 as a starting point
- Find your flying location using the map’s search control, or pan and zoom there manually. Click the rectangle drawing tool, then draw a box around the area you need.
- Press Link SD Card on the website. Select your SD card drive.
- Click Sync to SD Card, review the selected area and tile count, then click Confirm Sync.

Then on the radio in Yaapu Config:
- map provider → Google
- map type → GoogleHybridMap

## GPS Mount
- [3d Printed TPU Mount for GPS - Rear Option](https://www.thingiverse.com/thing:6295389) - rear mount, holds video transmitter antenna and elrs receiver antenna.
- [3d Printed TPU Mount for GPS - Front Option](https://www.thingiverse.com/thing:4759922)
- [Iflight Protek 35 BN880 GPS mast](https://www.thingiverse.com/thing:5329152) - use this if you want a different option to raise the GPS up higher.