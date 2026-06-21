# Skill: Evaluate ArduPilot Parameters

Evaluate the ArduPilot drone parameter configuration in this repository and produce a
structured safety/tuning/best-practices audit report.

## When to invoke

Use this skill when asked to:
- Evaluate, audit, or review the drone parameters
- Check if the drone is safe to fly
- Check if the tune is correct
- Find missing or incorrectly configured parameters
- Compare the configuration against ArduPilot best practices

## How to run this skill

Work through each step below in order. Read files directly — do not summarize or skip sections.

---

### Step 1 — Discover the configuration

1. Find all AMC vehicle directories: `Glob("ardupilot-methodic-configurator/*/vehicle_components.json")`
2. If multiple directories exist, ask the user which one to evaluate.
3. Set `VEHICLE_DIR` = the matched directory (e.g., `ardupilot-methodic-configurator/FPVDroneV2/`)

---

### Step 2 — Read hardware specification

Read `$VEHICLE_DIR/vehicle_components.json` fully. Extract and note:
- **Frame**: manufacturer, model, TOW (kg)
- **FC**: manufacturer, model, firmware version
- **Battery**: chemistry, cell count, capacity mAh, per-cell voltages (max/arm/low/crit/min)
- **Motors**: KV rating
- **Props**: diameter (inches), blade count
- **ESC**: protocol (DShot speed), bidirectional DShot support
- **GPS**: model, connection serial port
- **RC Receiver**: protocol (CRSF/SBUS/etc.), connection serial port
- **ESC Telemetry**: UART or bidirectional DShot or None

Flag any internal inconsistencies (e.g., model name says "4S" but cell count says 6).

---

### Step 3 — Read parameter files

Read `$VEHICLE_DIR/complete.param` fully. This is the intended final parameter state.

Also read `$VEHICLE_DIR/last_uploaded_filename.txt`. Compare the filename to the numbered
`.param` files in the directory to identify any files NOT yet uploaded to the physical FC.
List the filenames of un-uploaded steps and extract their key parameter changes.

---

### Step 4 — Run the evaluation checklist

Evaluate each category below. For each item, mark: ✅ Good / ⚠️ Review / ❌ Issue.

#### 4A — Battery configuration
- `BATT_MONITOR` ≠ 0 (monitoring enabled)
- Cell count from JSON × 4.2V = `MOT_BAT_VOLT_MAX` (within 0.1V tolerance)
- Cell count from JSON × cell-arm-voltage = `BATT_ARM_VOLT` (within 0.1V tolerance)
- Cell count × cell-low-voltage = `BATT_LOW_VOLT`
- Cell count × cell-crit-voltage = `BATT_CRT_VOLT`
- `BATT_CAPACITY` ≤ battery capacity mAh (conservative is good)
- `BATT_FS_LOW_ACT` = 2 (RTL on low battery) or 1 (Land) — not 0 (disabled)
- `BATT_FS_CRT_ACT` = 1 (Land) — not 0 (disabled)

#### 4B — Failsafe completeness
- `FS_THR_ENABLE` = 1 (throttle/RC failsafe enabled)
- `FS_THR_VALUE` in range 925–975 µs (below RC minimum signal)
- `RC_FS_TIMEOUT` ≤ 2 seconds
- `FS_EKF_ACTION` ≠ 0 (EKF failsafe active)
- `FS_CRASH_CHECK` = 1 (crash detection enabled)
- `FS_VIBE_ENABLE` = 1 (vibration failsafe enabled)
- `FS_DR_ENABLE` ≥ 1 (dead-reckoning failsafe enabled)
- `FENCE_ENABLE` = 1 and `FENCE_TYPE` ≠ 0
- `FENCE_ACTION` ≠ 0 (fence breach triggers action)
- `ARMING_CHECK` = 1 (all arming checks enabled)

#### 4C — PID and attitude tuning
- `ATC_ANG_RLL_P`, `ATC_ANG_PIT_P`, `ATC_ANG_YAW_P`: flag if > 25 (unusually high)
- `ATC_RAT_RLL_SMAX`, `ATC_RAT_PIT_SMAX` set (> 0): limits slew rate, reduces oscillation
- `ATC_RAT_YAW_SMAX` set (> 0)
- `MOT_THST_HOVER` between 0.1 and 0.4: flag if outside (< 0.1 = overpowered, > 0.4 = underpowered)
- `MOT_THST_EXPO`: for ducted props flag if > 0.60 (recommend 0.4–0.55)
- `ANGLE_MAX` ≥ 3500 (35°) for FPV; flag if ≤ 3000 as overly restrictive
- `ATC_INPUT_TC` between 0.1 and 0.3 (input smoothing; 0.2 is good for cinematic)
- Rate PIDs roll vs pitch symmetry: flag if pitch P > 3× roll P (asymmetric airframe)
- `QUIK_ENABLE`: should be 0 for everyday flying (flag if 1)

#### 4D — Harmonic notch filter
- `INS_HNTCH_ENABLE` = 1 (primary notch active)
- `INS_HNTCH_MODE` = 3 (ESC RPM tracking) or 1 (throttle-based): 3 preferred
- `INS_HNTCH_HMNCS` ≥ 3 (at least 1st and 2nd harmonics filtered)
- `INS_HNTCH_BW` ≥ 20 Hz (sufficient bandwidth)
- `INS_HNTCH_ATT` ≥ 30 dB (sufficient attenuation)
- `SERVO_BLH_BDMASK` covers all motor outputs if bidirectional DShot is used
- If mode=3: confirm `SERVO_BLH_BDMASK` ≠ 0 (bidirectional DShot provides RPM)

#### 4E — EKF configuration
- `AHRS_EKF_TYPE` = 3 (EKF3 enabled)
- `EK3_ENABLE` = 1
- `EK3_SRC1_POSXY` = 3 (GPS position) if GPS equipped
- `EK3_SRC1_VELXY` = 3 (GPS velocity) if GPS equipped
- `EK3_MAG_CAL` = 3 (when GPS available) — not 0 (never) or 1 (always)
- `EK3_SRC_OPTIONS` = 1 if multiple position sources configured (auto-switch)
- `EK3_GPS_CHECK` ≥ 7 (basic GPS health checks enabled)

#### 4F — Flight modes
- At least one of FLTMODE1–6 = 6 (RTL) — easy access to RTL
- At least one = 9 (Land)
- `FLTMODE_CH` assigned to a physical switch channel
- Stabilize (0) accessible as emergency manual override
- Auto (15) only if GPS and arming checks are reliable

#### 4G — Safety and rate limits
- `MOT_SPIN_ARM` 0.01–0.05 (motor just barely spins at arm)
- `MOT_SPIN_MIN` > `MOT_SPIN_ARM` (min spin above arm spin)
- `MOT_SPIN_MAX` ≤ 0.95
- `MOT_PWM_TYPE` = 6 (DShot600) or appropriate for ESC
- `SERVO_BLH_POLES` or `SERVO_FTW_POLES` matches motor pole count
- `DISARM_DELAY` ≥ 2 seconds (prevent accidental disarm)
- `TKOFF_RPM_MIN` > 0 (dead motor detection on takeoff)
- `GPS_HDOP_GOOD` ≤ 200 (GPS quality gate)
- `GPS_NAVFILTER` = 8 (Airborne 4G) for dynamic FPV flight
- `RTL_ALT` > 0 (RTL climbs to safe altitude)

#### 4H — Hardware/serial consistency
Compare serial port protocols in `complete.param` vs components JSON:
- RC receiver serial port → `SERIAL{N}_PROTOCOL` = 23 (RCIN/CRSF)
- GPS serial port → `SERIAL{N}_PROTOCOL` = 5 (GPS)
- Check `SERVO_BLH_BDMASK` covers motors 1–4 if bidirectional DShot used
- `MOT_PWM_TYPE` = 6 (DShot600) consistent with ESC protocol in components
- `INS_HNTCH_MODE` = 3 requires `SERVO_BLH_BDMASK` ≠ 0 — flag mismatch
- Any `SERIAL{N}_PROTOCOL` configured but not reflected in components JSON — flag as orphaned

---

### Step 5 — Upload gap check

If `last_uploaded_filename.txt` is NOT the last numbered `.param` file in the directory:
1. List all un-uploaded step files in order
2. For each, read the file and summarize which parameters it changes
3. Highlight any safety-critical changes (battery thresholds, failsafe, QUIK_ENABLE, logging)
4. State clearly: **"The physical FC has a different configuration than complete.param"**

---

### Step 6 — Output the report

Structure the report as follows:

```
## ArduPilot Parameter Audit — [Vehicle Directory Name]
Hardware: [brief one-liner from components JSON]
Firmware: [version]
Upload status: [complete / INCOMPLETE — last uploaded: filename]

### 🔴 CRITICAL (fix before next flight)
[List each critical item as: param_name = value → problem description → recommended action]

### 🟡 TUNING (review / consider adjusting)
[List each tuning item]

### 🔵 BEST PRACTICES (minor improvements)
[List each best-practice item]

### ✅ LOOKS GOOD
[Brief bullet list of things done correctly]
```

---

### Step 7 — Offer to apply fixes

Ask: "Would you like me to apply any of these fixes to the parameter files?"

If yes:
- Make changes in the **specific numbered step `.param` file** that owns that parameter,
  not in `complete.param` directly (which is auto-generated by AMC).
- If no existing step file owns the parameter, add it to the highest numbered results file
  or create a new `67_post_audit_fixes.param` file.
- Do NOT change `complete.param` directly — it is regenerated by AMC.
- After edits, note which files to re-upload to the FC via AMC.

---

## Reference: Common ArduPilot 4.6 best-practice values for FPV cinewhoops

| Parameter | Recommended | Notes |
|-----------|-------------|-------|
| `ANGLE_MAX` | 4500 (45°) | 30° is too restrictive for FPV |
| `MOT_THST_EXPO` | 0.45–0.55 | Lower for ducted props |
| `MOT_SPIN_ARM` | 0.02–0.04 | Just barely spins |
| `MOT_SPIN_MIN` | 0.05–0.08 | Above arm, below flight |
| `ATC_THR_MIX_MAN` | 0.5 | Balance attitude vs throttle |
| `ATC_INPUT_TC` | 0.15–0.20 | Cinematic: 0.20, Sport: 0.10 |
| `GPS_NAVFILTER` | 8 | Airborne 4G for FPV |
| `GPS1_RATE_MS` | 100 | 10 Hz if GPS supports it |
| `INS_HNTCH_MODE` | 3 | Dynamic RPM tracking |
| `INS_HNTCH_HMNCS` | 3 | 1st + 2nd harmonics |
| `QUIK_ENABLE` | 0 | Disable for everyday flying |
| `FENCE_ENABLE` | 1 | Always |
| `FS_THR_ENABLE` | 1 | Always |
| `FS_VIBE_ENABLE` | 1 | Always |
| `TKOFF_RPM_MIN` | 100–300 | Dead-motor detection |
