This page contains a consolidated list of the all of the configuration done in ArduPilot throughout the videos. 
Use this to easily setup a new flight controllers.


# Initial Setup
Read the [MicoAir Getting Started Guide for ArduPilot](https://micoair.com/docs/getting-started-guide-for-ardupilot/).
Also read the [ArduPilot Docs on the MicoAir H743](https://ardupilot.org/copter/docs/common-MicoAir743.html).
After flashing firmware for the first time, use Mission Planner to configure several items. I used a stock firmware with no extra options added or removed (i.e., I didnt need a custom firmware build).
- Go to Setup tab.
- Expand the Mandatory Hardware menu item.
  - On Frame Type menu item:
    - Select the Quad X pattern.
  - On Initial Tune Parameters menu item:
    - Airscrew Inch Size: 3.5
    - Battery Cellcount: 4
    - Battery cell fully discharged voltage: 3.3
    - Check the option to "Add suggested settings for 4.0 and up (Battery failsafe and Fence)".
    - Press the "Calculate Initial Parameters" button, and then the "Write to FC" button on the popup window.
  - On Accel Calibration menu item:
    - Press Calibrate Accel (use this for when you can manipulate the drone orientation)
    - Press Calibrate Level
    - Press Simple Accel Cal (use this in lieu of Calibrate Accel for large drone or simple bench testing)
    - Docs on accelerometer calibration [can be found here](https://ardupilot.org/copter/docs/common-accelerometer-calibration.html).    
  - On ESC Calibration menu item:
    - If using Bluejay ESC, it must be set to DShot300/600, otherwise the ESC will not be able to recognize the signal.
  - On Compass menu item:
    - Press start on the Onboard Mag Calibration, calibrate, and reboot. Docs on compass calibration [can be found here](https://ardupilot.org/copter/docs/common-compass-calibration-in-mission-planner.html).
  - On Radio Calibration menu item:
    - Press the Calibrate Radio button. Move joysticks and input buttons to their limits. Then press the Click when Done button.
    - Docs on radio calibration [can be found here](https://ardupilot.org/copter/docs/common-radio-control-calibration.html).
    - Be sure to test the controls in Mission Planner. Move the transmitter’s roll, pitch, throttle and yaw sticks and ensure the green bars move in the correct direction:
      - For roll, throttle and yaw channels, the green bars should move in the same direction as the transmitter’s physical sticks.
      - For pitch, the green bar should move in the opposite direction to the transmitter’s physical stick.
      - If one of the green bars moves in the incorrect direction reverse the channel in the transmitter itself. If it is not possible to reverse the channel in the transmitter you may reverse the channel in ArduPilot by checking the “Reversed” checkbox (Plane and Rover only). If the checkbox is not visible it is possible to reverse the channel by directly changing the RCx_REVERSED parameter (where “x” is the input channel from 1 to 4).
    

# Parameter Settings
To set these parameters in mission planner, navigate to the Config tab, and then the Parameter List menu option.
Note: If you are using a fresh installation of mission planner you will have to enable this page by setting Config->Planner->Layout to “Advanced”


## Parameters - MicoAir voltage and current sensors
These settings are for a 6s battery. Adjust for a 4s battery.
|Parameter Name|Value|Description|
|---|---|---|
|BATT_MONITOR|4|Set this first, and then write the params so the other ones below show. Must reboot the board after changing. 4 = Analog voltage and current.|
|BATT_AMP_PERVLT|40.2||
|BATT_ARM_VOLT|24|Minimum battery voltage required to arm the aircraft.|
|BATT_CAPACITY|1600|The battery has 1600 mah.|
|BATT_CRT_VOLT|19.2|Battery voltage that triggers a critical battery failsafe.|
|BATT_CURR_PIN|11||
|BATT_FS_CRT_ACT|1|Action to perform if the critical battery failsafe is hit. 1 = Land|
|BATT_FS_LOW_ACT|2|Action to perform if the low battery failsafe is hit. 2 = RTL|
|BATT_LOW_VOLT|21.6|Battery voltage that triggers a low battery failsafe.|
|BATT_SERIAL_NUM|-1|Leave at default of -1.|
|BATT_VOLT_MULT|21.2||
|BATT_VOLT_PIN|10||

## Parameters - Frame
|Parameter Name|Value|Description|
|---|---|---|
|FRAME_TYPE|1|X type|
|FRAME_CLASS|1|Quad|

## Parameters - ESC
|Parameter Name|Value|Description|
|---|---|---|
|MOT_PWM_TYPE|6|DShot 600.|
|SERVO1_FUNCTION|34|Motor 2|
|SERVO2_FUNCTION|35|Motor 3|
|SERVO3_FUNCTION|36|Motor 4|
|SERVO4_FUNCTION|33|Motor 1|
|SERVO_BLH_BDMASK|15|Mask of channels which support bi-directional dshot telemetry.|
|SERVO_DSHOT_ESC|4|BLHeli_S/BlueJay EDT|
|NTF_LED_TYPES|125127|Check the "DShot" checkbox to enable controlling the ESCs LEDs|
|NTF_BUZZ_TYPES|3|Check the "DShot" checkbox to enable usingthe motors as buzzers|


## Parameters - ELRS Receiver
|Parameter Name|Value|Description|
|---|---|---|
|SERIAL6_PROTOCOL|23|CRSF RCIN, which should be the default.|
|SERIAL6_BAUD|57|57 (57600) is fine. ArduPilot switches it internally to the correct CRSF baud of 400000.|
|RC_PROTOCOLS|1|This is default value, set to All.|
|RC_OPTIONS|288|The default is 32. Change to 288 to enable pass-through for CRSF telemetry.|
|RSSI_TYPE|3|Indicate RSSI is provided by the receiver protocol.|


I also had to set these to map the controls properly for my transmitter:
|Parameter Name|Value|Description|
|---|---|---|
|RCMAP_PITCH|3||
|RCMAP_ROLL|4||
|RCMAP_THROTTLE|2||
|RCMAP_YAW|1||


## Parameters - MicoAir M10 GPS
|Parameter Name|Value|Description|
|---|---|---|
|BRD_SAFETY_DEFLT|0|There is no safety switch on the GPS so we disable it. (BRD_SAFETYENABLE in older firmware versions)|
|SERIAL3_PROTOCOL|5|treat the data coming from UART3 as a GPS protocol|
|GPS1_TYPE|1|Auto. For M10 modules, ArduPilot is typically able to auto-detect and configure the GPS, so this is the recommended setting.|


## Parameters - Video Transmitter Support
|Parameter Name|Value|Description|
|---|---|---|
|VTX_ENABLE|1|Enable VTX support. Reboot flight controller after setting.|
|SERIAL2_PROTOCOL|37|Enable the SmartAudio protocol.|
|SERIAL2_BAUD|4|The required baud rate for SmartAudio.|
|SERIAL2_OPTIONS|4|For half-duplex communication, which SmartAudio requires.|
|OSD_TYPE|1|Enable the analog OSD system.|
|VTX_BAND|0|Band A.|
|VTX_CHANNEL|0|Channel 1.|
|VTX_OPTIONS|10|Pitmode until armed and Unlocked options.|
|VTX_POWER|150|Change from 25 to 150mw.|

> TODO: Do we need to set VTX_BAND, VTX_CHANNEL, VTX_POWER, and VTX_OPTIONS

## Parameters - Flight Modes
I have my flight modes configured as follows. This requires some config in ArduPilot as well as the RadioMaster controller. You can also set these up in Mission Planner on the Setup->Flight Modes screen.

|Parameter Name|Value|Description|
|---|---|---|
|FLTMODE_CH|6|RC Channel to use for flight mode control. Default is 5, but we have to change it to 6 since ELRS maps channel 5 to a hard-coded channel 5 (AUX1) as a 2-position, 1-bit arming channel for safety and system performance. This is an intentional design feature of ELRS and cannot be changed, regardless of your other radio settings.|
|FLTMODE1|5|Flight mode when pwm of Flightmode channel(FLTMODE_CH) is <= 1230. Set to Loiter.|
|FLTMODE2|15|Flight mode when pwm of Flightmode channel(FLTMODE_CH) is >1230, <= 1360. Set to AutoTune.|
|FLTMODE3|2|Flight mode when pwm of Flightmode channel(FLTMODE_CH) is >1360, <= 1490. Set to AltHold.|
|FLTMODE4|3|Flight mode when pwm of Flightmode channel(FLTMODE_CH) is >1490, <= 1620. Set to Auto.|
|FLTMODE5|6|Flight mode when pwm of Flightmode channel(FLTMODE_CH) is >1620, <= 1749. Set to RTL.|
|FLTMODE6|9|Flight mode when pwm of Flightmode channel(FLTMODE_CH) is >=1750. Set to Land.|


## Parameters - RC Failsafe
- In Mission Planner go to the Setup -> FailSafe tab. Configure the radio failsafe to Enabled always RTL, and an FS PWM of 975
- [Failsafe documentation is available here](https://ardupilot.org/copter/docs/failsafe-landing-page.html).

|Parameter Name|Value|Description|
|---|---|---|
|RC_FS_TIMEOUT|1|RC failsafe will trigger this many seconds after loss of RC.|
|FS_THR_ENABLE|1|The throttle failsafe allows you to configure a software failsafe activated by a setting on the throttle input channel. Set to Enabled, always RTL. If the GPS position is not usable, the copter will change to Land Mode instead.|
|FS_THR_VALUE|975|The PWM level in microseconds on channel 3 below which throttle failsafe triggers.|


## Parameters - GeoFence
A fence is a virtual boundary set in the flight control system that restricts the area within which an unmanned aerial vehicle (UAV) can operate, helping to ensure it stays within a predefined safe zone and enhancing flight safety. If the UAV attempts to cross this boundary, the system can trigger predefined actions like returning to launch or landing. Upon Fence breach, selectable actions are taken.

- In Mission Planner go to the Config->GeoFence tab. Configure the GeoFence settings to control the distance your drone is allowed to go from it's launch point.

|Parameter Name|Value|Description|
|---|---|---|
|FENCE_ACTION|4|4 = Brake or Land. Set to 0 for report only.|
|FENCE_ALT_MAX|30|Maximum altitude allowed before geofence triggers. Value is in meters. I set to 30 when initially testing drone.|
|FENCE_ALT_MIN|-10|Minimum altitude allowed before geofence triggers. Value is in meters.|
|FENCE_AUTOENABLE|0|Auto-enable of fences. Set to Disabled.|
|FENCE_ENABLE|1|Allows you to enable (1) or disable (0) the fence functionality.|
|FENCE_MARGIN|3|Distance that autopilot's should maintain from the fence to avoid a breach. Value is in meters.|
|FENCE_RADIUS|100|Circle fence radius which when breached will cause an RTL. Value is in meters.|
|FENCE_TYPE|7|Bitmask. Set to Max Altitude, Circle Centered on Home, and Inclusion/Exclusion Circles+Polygons|


## Parameters - Additonal RC Channel Options
- In Mission Planner you can also go to the Config->User Params tab and map actions to other channels as desired. For example you could map channel 7 to fence enable/disable. This would be the same as setting RC7_OPTION to a value of 11. Other fun things, for example, you could map it to the lost copter sound.

|Parameter Name|Value|Description|
|---|---|---|
|RC7_OPTION|11|Function assigned to this RC channel. Set to Fence Enable.|


## Parameters - Waypoint Navigation
I have adjusted these parameters to be about half the default value to make my drone move more slowly during missions.

|Parameter Name|Value|Description|
|---|---|---|
|WPNAV_SPEED|500|Defines the speed in cm/s which the aircraft will attempt to maintain horizontally during a WP mission.|
|WPNAV_SPEED_UP|150|Defines the speed in cm/s which the aircraft will attempt to maintain while climbing during a WP mission.|
|WPNAV_SPEED_DN|100|Defines the speed in cm/s which the aircraft will attempt to maintain while descending during a WP mission.|
|WPNAV_ACCEL|125|Defines the horizontal acceleration in cm/s/s used during missions.|
|WPNAV_ACCEL_Z|75|Defines the vertical acceleration in cm/s/s used during missions.|

## Parameters - Board Boot Delay
|Parameter Name|Value|Description|
|---|---|---|
|BRD_BOOT_DELAY|3000|This adds a delay in milliseconds to boot to ensure peripherals initialise fully. Value in milliseconds.|


## Parameters - Indoor Flight
To fly indoors, you must fly without GPS, and you need to explicitly configure ArduPilot to not expect GPS or compass data.
And you can only fly in these flight modes then:
- Stabilize
- AltHold
- Acro

|Parameter Name|Value|Description|
|---|---|---|
|GPS1_TYPE|0|Set to 0 to say there is no GPS. This was set to 1 by default above.|
|COMPASS_USE|0|Set to 0 to say there is no Compass. Yaw will now rely on gyro integration, which is much more stable indoors. This was set to 1 by default above.|


