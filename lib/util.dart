import "package:collection/collection.dart";
import "package:flutter/rendering.dart";

import "package:warm_app/class.dart";
import "package:warm_app/const.dart";
import "package:warm_app/correction_formula.dart";

// Get the display data and the unit for sensor readings
List<SensorDisplayUnit> getDisplayData(Map<String, num> data) {
  return displayNames.map((entry) {
    final reading = entry["reading"]!;
    return SensorDisplayUnit(
      entry["displayName"]!,
      entry["unit"]!,
      data[reading]!,
      int.parse(entry["decimalPoint"]!),
      getColor(reading, data[reading]!),
      entry["info"]!,
    );
  }).toList();
}

// Get the color code for sensor reading
Color getColor(String name, num rawInput) => iValues.containsKey(name)
  ? getBreakpointValues(name, rawInput).color
  : Color.fromRGBO(255, 255, 255, 1.0);

Color getIArchColor(num iArchValue) {
    IArchScaleColorCode iValue = iArchColorCodes.entries.map((e) => e.value).firstWhere((iValue) => iValue.iLow <= iArchValue && iArchValue <= iValue.iHigh, orElse: () => IArchScaleColorCode(0, 0, Color.fromRGBO(255, 255, 255, 1.0)));
    return iValue.color;
  }

BreakpointValues getBreakpointValues(String name, num rawInput) {
  Map<int, dynamic>? breakpointValuesMap = iValues[name];
  if (breakpointValuesMap == null) {
    throw ArgumentError("Invalid name: $name");
  }

  return breakpointValuesMap.entries.map((e) => e.value)
  .firstWhere((bpValue) => bpValue.bpLow <= rawInput && rawInput <= bpValue.bpHigh, orElse: () => breakpointValuesMap[10]);
}

num convertCelciusToFarenheit(num temp) => num.parse(temp.toStringAsFixed(1)) * 1.8 + 32;

num convertPPBToPPM(num value) => value * 0.001;

void applyCorrectionsToRawData(Map<String, num> monitorData) {
  // Convert Temperature from Celcius to Farenheit
  monitorData["T"] = convertCelciusToFarenheit(monitorData["T"]!);

  // Convert TVOC from ppb (parts per billion) to ppm (parts per million)
  monitorData["TVOC"] = convertPPBToPPM(monitorData["TVOC"]!);

  // Apply EPA Correction Formula for PM 2.5
  monitorData["PM2.5"] = applyCorrectionFormulaPM2(monitorData["PM2.5"]!, monitorData["pm003Count"]!, monitorData["RH"]!, monitorData["plantower"]!);
}

num convertPTSerialToNum(String ptSerial) => int.parse(ptSerial.replaceAll("-", "").substring(0, 8));

num getAverageIArchValue(List<num> iArchValues, int numReadings) {
  return iArchValues.sublist(0, numReadings).average;
}
