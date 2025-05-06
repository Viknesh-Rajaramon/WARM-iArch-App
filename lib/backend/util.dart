import "package:collection/collection.dart";
import "package:flutter/rendering.dart";

import "package:warm_app/backend/class.dart";
import "package:warm_app/backend/const.dart";

// Get the display data and the unit for sensor readings
List<SensorDisplayUnit> getDisplayData(Map<String, num> data) {
  return displayNames.map((entry) {
    final reading = entry["reading"]!;
    return SensorDisplayUnit(
      entry["displayName"]!,
      entry["unit"]!,
      data[reading] ?? 0,
      int.tryParse(entry["decimalPoint"] ?? "0") ?? 0,
      getColor(reading, data[reading] ?? 0),
      entry["info"]!,
    );
  }).toList();
}

// Get the color code for sensor reading
Color getColor(String name, num rawInput) {
  if (alternateNamesForColor.containsKey(name)) {
    return getBreakpointValues(alternateNamesForColor[name]!, rawInput).color;
  }

  return iValues.containsKey(name)
  ? getBreakpointValues(name, rawInput).color
  : const Color.fromRGBO(255, 255, 255, 1.0);
}

Color getIArchColor(num iArchValue) {
  if (iArchValue < 0) {
    return Color.fromRGBO(255, 255, 255, 1.0);
  }

  IArchScaleColorCode iValue = iArchColorCodes.entries.map((e) => e.value).firstWhere(
    (iValue) => iValue.iLow <= iArchValue && iArchValue <= iValue.iHigh,
    orElse: () => iArchColorCodes[10]!
  );
  return iValue.color;
}

BreakpointValues getBreakpointValues(String name, num rawInput) {
  Map<int, dynamic>? breakpointValuesMap = iValues[name];
  if (breakpointValuesMap == null) {
    throw ArgumentError("Invalid reading name: $name");
  }

  return breakpointValuesMap.entries.map((e) => e.value).firstWhere(
    (bpValue) => bpValue.bpLow <= rawInput && rawInput <= bpValue.bpHigh,
    orElse: () => breakpointValuesMap[10]
  );
}

num convertCelciusToFarenheit(num temp) => num.parse(temp.toStringAsFixed(1)) * 1.8 + 32;

num convertPPBTomicrogPerm3(num value) => value * 2;

void applyCorrectionsToRawData(Map<String, num> monitorData) {
  monitorData["T"] = convertCelciusToFarenheit(monitorData["T"]!);
  monitorData["TVOC"] = convertPPBTomicrogPerm3(monitorData["TVOCppb"]!);
}

num getAverageIArchValue(List<num> iArchValues, int numReadings) {
  return iArchValues.length < numReadings ? -1 : iArchValues.sublist(0, numReadings).average;
}

String intAsTwoDigits(int value) => value.toString().padLeft(2, "0");

String formatDateTime(DateTime datetime) {
  return "${datetime.year}"
    "${intAsTwoDigits(datetime.month)}"
    "${intAsTwoDigits(datetime.day)}"
    "T"
    "${intAsTwoDigits(datetime.hour)}"
    "${intAsTwoDigits(datetime.minute)}"
    "${intAsTwoDigits(datetime.second)}"
    "Z";
}

(String, String) getfromAndToTimestamp() {
  DateTime toTime = DateTime.now().toUtc();
  DateTime fromTime = toTime.subtract(Duration(hours: 13));
  
  return (formatDateTime(fromTime), formatDateTime(toTime));
}
