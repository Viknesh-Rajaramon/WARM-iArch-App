import "package:warm_app/class.dart";

// Mapping different sensor readings to their display names and respective units
const List<Map<String, String>> displayNames = [
  {"reading": "PM2.5", "displayName": "PM\u2082\u002e\u2085", "unit": "µg/m³", "decimalPoint": "1"},
  {"reading": "PM10", "displayName": "PM\u2081\u2080", "unit": "µg/m³", "decimalPoint": "1"},
  {"reading": "TVOC", "displayName": "TVOC", "unit": "ppm", "decimalPoint": "1"},
  {"reading": "CO2", "displayName": "CO\u2082", "unit": "ppm", "decimalPoint": "1"},
  {"reading": "RH", "displayName": "RH", "unit": "%", "decimalPoint": "1"},
  {"reading": "T", "displayName": "T", "unit": "\u2070F", "decimalPoint": "1"},
  {"reading": "AT", "displayName": "AT", "unit": "\u2070F", "decimalPoint": "1"},
];

// Index range values and concentration breakpoint values for PM2.5
const Map<int, dynamic> breakpointValuesPM2_5 = {
  1: BreakpointValues(0, 50, 0, 5, "WHO limit, annually"),
  2: BreakpointValues(51, 100, 6, 9, "24 hr healthy limit EPA"),
  3: BreakpointValues(101, 150, 10, 24, ""),
  4: BreakpointValues(151, 200, 25, 35, "24 hour unhealthy limit"),
  5: BreakpointValues(201, 250, 36, 45, "very unhealthy"),
  6: BreakpointValues(251, 300, 46, 55, "very unhealthy"),
  7: BreakpointValues(301, 350, 56, 65, "very unhealthy"),
  8: BreakpointValues(351, 400, 66, 75, "very unhealthy"),
  9: BreakpointValues(401, 450, 76, 85, "very unhealthy"),
  10: BreakpointValues(451, 500, 86, 95, "very unhealthy"),
};

// Index range values and concentration breakpoint values for PM10
const Map<int, dynamic> breakpointValuesPM10 = {
  1: BreakpointValues(0, 50, 0, 10, ""),
  2: BreakpointValues(51, 100, 11, 20, "WHO limit, annually"),
  3: BreakpointValues(101, 150, 21, 33, ""),
  4: BreakpointValues(151, 200, 34, 50, "24 hour unhealthy limit"),
  5: BreakpointValues(201, 250, 51, 60, "very unhealthy"),
  6: BreakpointValues(251, 300, 61, 70, "very unhealthy"),
  7: BreakpointValues(301, 350, 71, 80, "very unhealthy"),
  8: BreakpointValues(351, 400, 81, 90, "very unhealthy"),
  9: BreakpointValues(401, 450, 91, 100, "very unhealthy"),
  10: BreakpointValues(451, 500, 101, 110, "very unhealthy"),
};

// Index range values and concentration breakpoint values for TVOC
const Map<int, dynamic> breakpointValuesTVOC = {
  1: BreakpointValues(0, 50, 0, 150, ""),
  2: BreakpointValues(51, 100, 151, 300, "Recommended upper limit"),
  3: BreakpointValues(101, 150, 301, 350, ""),
  4: BreakpointValues(151, 200, 351, 500, "LEED upper limit"),
  5: BreakpointValues(201, 250, 501, 600, "very unhealthy"),
  6: BreakpointValues(251, 300, 601, 700, "very unhealthy"),
  7: BreakpointValues(301, 350, 701, 800, "very unhealthy"),
  8: BreakpointValues(351, 400, 801, 900, "very unhealthy"),
  9: BreakpointValues(401, 450, 901, 1000, "very unhealthy"),
  10: BreakpointValues(451, 500, 1001, 1100, "very unhealthy"),
};

// Index range values and concentration breakpoint values for CO2
const Map<int, dynamic> breakpointValuesCO2 = {
  1: BreakpointValues(0, 50, 0, 400, ""),
  2: BreakpointValues(51, 100, 401, 800, "Good limit"),
  3: BreakpointValues(101, 150, 801, 900, ""),
  4: BreakpointValues(151, 200, 901, 1000, "Recommended upper limit"),
  5: BreakpointValues(201, 250, 1001, 1300, "very unhealthy"),
  6: BreakpointValues(251, 300, 1301, 1600, "very unhealthy"),
  7: BreakpointValues(301, 350, 1601, 1900, "very unhealthy"),
  8: BreakpointValues(351, 400, 1901, 2200, "very unhealthy"),
  9: BreakpointValues(401, 450, 2201, 2500, "very unhealthy"),
  10: BreakpointValues(451, 500, 2501, 2800, "very unhealthy"),
};

// Index range values and concentration breakpoint values for AT
const Map<int, dynamic> breakpointValuesAT = {
  1: BreakpointValues(0, 50, 65, 70, ""),
  2: BreakpointValues(51, 100, 71, 80, ""),
  3: BreakpointValues(101, 150, 81, 85, ""),
  4: BreakpointValues(151, 200, 86, 90, "OSHA caution level"),
  5: BreakpointValues(201, 250, 91, 95, "very unhealthy"),
  6: BreakpointValues(251, 300, 96, 100, "very unhealthy"),
  7: BreakpointValues(301, 350, 101, 105, "very unhealthy"),
  8: BreakpointValues(351, 400, 106, 110, "very unhealthy"),
  9: BreakpointValues(401, 450, 111, 115, "very unhealthy"),
  10: BreakpointValues(451, 500, 116, 120, "very unhealthy"),
};

// Map of variables to calculate I-values
const Map<String, Map<int, dynamic>> iValues = {
  "PM2.5": breakpointValuesPM2_5,
  "PM10": breakpointValuesPM10,
  "TVOC": breakpointValuesTVOC,
  "CO2": breakpointValuesCO2,
  "AT": breakpointValuesAT,
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
