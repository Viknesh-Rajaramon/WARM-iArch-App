import "package:flutter/rendering.dart";

import "package:warm_app/class.dart";
import "package:warm_app/const.dart";
import "package:warm_app/correction_formula.dart";

// Get the display data and the unit for sensor readings
List<SensorDisplayUnit> getDisplayData(Map<String, num> data) {
  List<SensorDisplayUnit> monitorDisplayData = [];

  for (var entry in displayNames) {
    Color color = getColor(entry["reading"]!, data[entry["reading"]!]!);
    SensorDisplayUnit displayData = SensorDisplayUnit(entry["displayName"]!, entry["unit"]!, data[entry["reading"]!]!, int.parse(entry["decimalPoint"]!), color);
    monitorDisplayData.add(displayData);
  }
  
  return monitorDisplayData;
}

// Get the color code for sensor reading
Color getColor(String name, num rawInput) {
  if (iValues.containsKey(name)) {
    BreakpointValues breakpointValue = getBreakpointValues(name, rawInput);
    return breakpointValue.color;
  }

  return Color.fromRGBO(255, 255, 255, 1.0);
}

BreakpointValues getBreakpointValues(String name, num rawInput) {
  Map<int, dynamic>? breakpointValuesMap = iValues[name];
  if (breakpointValuesMap == null) {
    throw ArgumentError("Invalid name: $name");
  }

  for (var entry in breakpointValuesMap.entries) {
    BreakpointValues bpValue = entry.value;
    if (bpValue.bpLow <= rawInput && rawInput <= bpValue.bpHigh) {
      return entry.value;
    }
  }
  
  return breakpointValuesMap[10];
}

num convertCelciusToFarenheit(num temp) {
  return num.parse(temp.toStringAsFixed(1)) * 1.8 + 32;
}

num convertPPBToPPM(num value) {
  return value * 0.001;
}

void applyCorrectionsToRawData(Map<String, num> monitorData) {
  // Convert Temperature from Celcius to Farenheit
  monitorData["T"] = convertCelciusToFarenheit(monitorData["T"]!);

  // Convert TVOC from ppb (parts per billion) to ppm (parts per million)
  monitorData["TVOC"] = convertPPBToPPM(monitorData["TVOC"]!);

  // Apply EPA Correction Formula for PM 2.5
  monitorData["PM2.5"] = applyCorrectionFormulaPM2(monitorData["PM2.5"]!, monitorData["pm003Count"]!, monitorData["RH"]!);
}
