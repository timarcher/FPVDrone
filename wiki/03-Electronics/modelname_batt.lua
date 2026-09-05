-- Yaapu battery percentage by voltage.
-- Rename this file to match the active EdgeTX model name:
-- lowercase, remove spaces/punctuation, then append _batt.lua.
-- Example: model "ProTek 35" -> protek35_batt.lua
-- Copy to the RADIO SD card: /WIDGETS/yaapu/cfg/
-- In Yaapu Config: enable battery % by voltage = yes;
-- batt[1] cell count override = 6 for a 6S pack.
-- This is a linear voltage-margin gauge, NOT measured remaining capacity.
-- On 6S: 25.2 V = full; 21.6 V = 0%; 23.6 V = about 56%.
-- Yaapu returns 99% at or above the upper endpoint.

return {
    voltageDrop = 0.00,
    useCellVoltage = true,
    dischargeCurve = {
        -- Volts per cell, percentage
        {3.60,   0},
        {4.20, 100}
    }
}
