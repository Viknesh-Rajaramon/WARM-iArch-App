import "package:flutter/rendering.dart";

import "package:warm_app/class.dart";

// Mapping different sensor readings to their display names and respective units
const List<Map<String, String>> displayNames = [
  {"reading": "PM2.5", "displayName": "PM\u2082\u002e\u2085", "unit": "µg/m³", "decimalPoint": "1", "info": "PM 2.5 level (PM - Particulate Matter)"},
  {"reading": "PM10", "displayName": "PM\u2081\u2080", "unit": "µg/m³", "decimalPoint": "1", "info": "PM 10 level (PM - Particulate Matter)"},
  {"reading": "TVOC", "displayName": "TVOC", "unit": "ppm", "decimalPoint": "3", "info": "Total Volatile Organic Compound level in ppm (parts per million)"},
  {"reading": "CO2", "displayName": "CO\u2082", "unit": "ppm", "decimalPoint": "0", "info": "CO\u2082 level in ppm (parts per million)"},
  {"reading": "RH", "displayName": "RH", "unit": "%", "decimalPoint": "0", "info": "Relative Humidity in percent"},
  {"reading": "T", "displayName": "T", "unit": "\u2070F", "decimalPoint": "2", "info": "Temperature in degrees Farenheit"},
  {"reading": "AT", "displayName": "AT", "unit": "\u2070F", "decimalPoint": "2", "info": "Apparent Temperature in degrees Farenheit"},
];

// Index range values and concentration breakpoint values for PM2.5
const Map<int, BreakpointValues> breakpointValuesPM2_5 = {
  1: BreakpointValues(0, 50, 0, 5, "WHO limit, annually", Color.fromRGBO(0, 255, 0, 1.0)),
  2: BreakpointValues(51, 100, 6, 9, "24 hr healthy limit EPA", Color.fromRGBO(0, 255, 0, 1.0)),
  3: BreakpointValues(101, 150, 10, 24, "", Color.fromRGBO(255, 191, 0, 1.0)),
  4: BreakpointValues(151, 200, 25, 35, "24 hour unhealthy limit", Color.fromRGBO(255, 191, 0, 1.0)),
  5: BreakpointValues(201, 250, 36, 45, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  6: BreakpointValues(251, 300, 46, 55, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  7: BreakpointValues(301, 350, 56, 65, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  8: BreakpointValues(351, 400, 66, 75, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  9: BreakpointValues(401, 450, 76, 85, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  10: BreakpointValues(451, 500, 86, 95, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
};

// Index range values and concentration breakpoint values for PM10
const Map<int, BreakpointValues> breakpointValuesPM10 = {
  1: BreakpointValues(0, 50, 0, 10, "", Color.fromRGBO(0, 255, 0, 1.0)),
  2: BreakpointValues(51, 100, 11, 20, "WHO limit, annually", Color.fromRGBO(0, 255, 0, 1.0)),
  3: BreakpointValues(101, 150, 21, 33, "", Color.fromRGBO(255, 191, 0, 1.0)),
  4: BreakpointValues(151, 200, 34, 50, "24 hour unhealthy limit", Color.fromRGBO(255, 191, 0, 1.0)),
  5: BreakpointValues(201, 250, 51, 60, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  6: BreakpointValues(251, 300, 61, 70, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  7: BreakpointValues(301, 350, 71, 80, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  8: BreakpointValues(351, 400, 81, 90, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  9: BreakpointValues(401, 450, 91, 100, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  10: BreakpointValues(451, 500, 101, 110, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
};

// Index range values and concentration breakpoint values for TVOC
const Map<int, BreakpointValues> breakpointValuesTVOC = {
  1: BreakpointValues(0, 50, 0, 150, "", Color.fromRGBO(0, 255, 0, 1.0)),
  2: BreakpointValues(51, 100, 151, 300, "Recommended upper limit", Color.fromRGBO(0, 255, 0, 1.0)),
  3: BreakpointValues(101, 150, 301, 350, "", Color.fromRGBO(255, 191, 0, 1.0)),
  4: BreakpointValues(151, 200, 351, 500, "LEED upper limit", Color.fromRGBO(255, 191, 0, 1.0)),
  5: BreakpointValues(201, 250, 501, 600, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  6: BreakpointValues(251, 300, 601, 700, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  7: BreakpointValues(301, 350, 701, 800, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  8: BreakpointValues(351, 400, 801, 900, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  9: BreakpointValues(401, 450, 901, 1000, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  10: BreakpointValues(451, 500, 1001, 1100, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
};

// Index range values and concentration breakpoint values for CO2
const Map<int, BreakpointValues> breakpointValuesCO2 = {
  1: BreakpointValues(0, 50, 0, 400, "", Color.fromRGBO(0, 255, 0, 1.0)),
  2: BreakpointValues(51, 100, 401, 800, "Good limit", Color.fromRGBO(0, 255, 0, 1.0)),
  3: BreakpointValues(101, 150, 801, 900, "", Color.fromRGBO(255, 191, 0, 1.0)),
  4: BreakpointValues(151, 200, 901, 1000, "Recommended upper limit", Color.fromRGBO(255, 191, 0, 1.0)),
  5: BreakpointValues(201, 250, 1001, 1300, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  6: BreakpointValues(251, 300, 1301, 1600, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  7: BreakpointValues(301, 350, 1601, 1900, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  8: BreakpointValues(351, 400, 1901, 2200, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  9: BreakpointValues(401, 450, 2201, 2500, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  10: BreakpointValues(451, 500, 2501, 2800, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
};

// Index range values and concentration breakpoint values for AT
const Map<int, BreakpointValues> breakpointValuesAT = {
  1: BreakpointValues(0, 50, 65, 70, "", Color.fromRGBO(0, 255, 0, 1.0)),
  2: BreakpointValues(51, 100, 71, 80, "", Color.fromRGBO(0, 255, 0, 1.0)),
  3: BreakpointValues(101, 150, 81, 85, "", Color.fromRGBO(255, 191, 0, 1.0)),
  4: BreakpointValues(151, 200, 86, 90, "OSHA caution level", Color.fromRGBO(255, 191, 0, 1.0)),
  5: BreakpointValues(201, 250, 91, 95, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  6: BreakpointValues(251, 300, 96, 100, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  7: BreakpointValues(301, 350, 101, 105, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  8: BreakpointValues(351, 400, 106, 110, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  9: BreakpointValues(401, 450, 111, 115, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
  10: BreakpointValues(451, 500, 116, 120, "very unhealthy", Color.fromRGBO(255, 0, 0, 1.0)),
};

// Map of variables to calculate I-values
const Map<String, Map<int, BreakpointValues>> iValues = {
  "PM2.5": breakpointValuesPM2_5,
  "PM10": breakpointValuesPM10,
  "TVOC": breakpointValuesTVOC,
  "CO2": breakpointValuesCO2,
  "AT": breakpointValuesAT,
};

const Map<int, IArchScaleColorCode> iArchColorCodes = {
  1: IArchScaleColorCode(0, 50, Color.fromRGBO(0, 255, 0, 1.0)),
  2: IArchScaleColorCode(51, 100, Color.fromRGBO(0, 255, 0, 1.0)),
  3: IArchScaleColorCode(101, 150, Color.fromRGBO(255, 191, 0, 1.0)),
  4: IArchScaleColorCode(151, 200, Color.fromRGBO(255, 191, 0, 1.0)),
  5: IArchScaleColorCode(201, 250, Color.fromRGBO(255, 0, 0, 1.0)),
  6: IArchScaleColorCode(251, 300, Color.fromRGBO(255, 0, 0, 1.0)),
  7: IArchScaleColorCode(301, 350, Color.fromRGBO(255, 0, 0, 1.0)),
  8: IArchScaleColorCode(351, 400, Color.fromRGBO(255, 0, 0, 1.0)),
  9: IArchScaleColorCode(401, 450, Color.fromRGBO(255, 0, 0, 1.0)),
  10: IArchScaleColorCode(451, 500, Color.fromRGBO(255, 0, 0, 1.0)),
};

const Map<String, List<String>> remediationParameters = {
  "PMReduction": ["PM2.5", "PM10"],
  "TVOCReduction": ["TVOC"],
  "CO2Reduction": ["CO2"],
  "RHReduction": ["RH"],
  "TSet": ["T"]
};

const List<Map<String, String>> remediationConditions = [
  {"option": "1", "condition": "One CR Box", "PMReduction": "0.4"},
  {"option": "2", "condition": "Two CR Boxes", "PMReduction": "0.8"},
  {"option": "3", "condition": "One CR Box + TVOC remediation", "PMReduction": "0.4", "TVOCReduction": "0.8"},
  {"option": "4", "condition": "Two CR Boxes + TVOC remediation", "PMReduction": "0.8", "TVOCReduction": "0.8"},
  {"option": "5", "condition": "Two CR Box + TVOC remediation + Ventilation", "PMReduction": "0.8", "TVOCReduction": "0.8", "CO2Reduction": "0.5"},
  {"option": "6", "condition": "Two CR Box + TVOC remediation + Ventilation + Dehumidifier", "PMReduction": "0.8", "TVOCReduction": "0.8", "CO2Reduction": "0.5", "RHReduction": "0.2"},
  {"option": "7", "condition": "Two CR Box + TVOC remediation + Ventilation + Dehumidifier + Temperature (75\u2070F)", "PMReduction": "0.8", "TVOCReduction": "0.8", "CO2Reduction": "0.5", "RHReduction": "0.2", "TSet": "75"},
];

const Map<String, List<String>> remediationSteps = {
  "One CR Box": [
    "Install one CR box (reduces PM 2.5 and PM 10 levels by approximately 40%).",
  ],
  "Two CR Boxes": [
    "Install two CR boxes (reduces PM 2.5 and PM 10 levels approximately by 80%).",
  ],
  "One CR Box + TVOC remediation": [
    "Install one CR box (reduces PM 2.5 and PM 10 levels by approximately 40%).",
    "Install and use activated carbon filters (reduces TVOC levels by 80%).",
  ],
  "Two CR Boxes + TVOC remediation": [
    "Install two CR boxes (reduces PM 2.5 and PM 10 levels by approximately 80%).",
    "Install and use activated carbon filters (reduces TVOC levels by 80%).",
  ],
  "Two CR Box + TVOC remediation + Ventilation": [
    "Install two CR boxes (reduces PM 2.5 and PM 10 levels by approximately 80%).",
    "Install and use activated carbon filters (reduces TVOC levels by 80%).",
    "Increase the ventilation in your room (reduces CO\u2082 levels by approximately 50%).",
  ],
  "Two CR Box + TVOC remediation + Ventilation + Dehumidifier": [
    "Install two CR boxes (reduces PM 2.5 and PM 10 levels by approximately 80%).",
    "Install and use activated carbon filters (reduces TVOC levels by 80%).",
    "Increase the ventilation in your room (reduces CO\u2082 levels by approximately 50%).",
    "Install and use a dehumidifier in your room (reduces Relative Humidity by 20%).",
  ],
  "Two CR Box + TVOC remediation + Ventilation + Dehumidifier + Temperature (75\u2070F)": [
    "Install two CR boxes (reduces PM 2.5 and PM 10 levels by approximately 80%).",
    "Install and use activated carbon filters (reduces TVOC levels by 80%).",
    "Increase the ventilation in your room (reduces CO\u2082 levels by approximately 50%).",
    "Install and use a dehumidifier in your room (reduces Relative Humidity by 20%).",
    "Set the room temperature to 75 \u2070F.",
  ],
};

const Map<num, Map<String, num>> scalingFactorsForCorrection = {
  20231030: {"scalingFactor": 0.02838, "intercept":	0},
  20231218: {"scalingFactor": 0.03525, "intercept":	0},
  20240104: {"scalingFactor": 0.02896, "intercept":	0},
  20240826: {"scalingFactor": 0.03863, "intercept":	0},
};

const String defaultPTSerial = "2023-103000000";

const List<Map<String, String>> timeFrameForAverage = [
  {"timeframe": "1-hour", "numReadings": "60"},
  {"timeframe": "3-hour", "numReadings": "180"},
  {"timeframe": "6-hour", "numReadings": "360"},
  {"timeframe": "12-hour", "numReadings": "720"},
];