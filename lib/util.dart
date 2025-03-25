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
      data[reading] ?? 0,
      int.tryParse(entry["decimalPoint"] ?? "0") ?? 0,
      getColor(reading, data[reading] ?? 0),
      entry["info"]!,
    );
  }).toList();
}

// Get the color code for sensor reading
Color getColor(String name, num rawInput) => iValues.containsKey(name)
  ? getBreakpointValues(name, rawInput).color
  : const Color.fromRGBO(255, 255, 255, 1.0);

Color getIArchColor(num iArchValue) {
  IArchScaleColorCode iValue = iArchColorCodes.entries.map((e) => e.value).firstWhere((iValue) => iValue.iLow <= iArchValue && iArchValue <= iValue.iHigh, orElse: () => IArchScaleColorCode(0, 0, const Color.fromRGBO(255, 255, 255, 1.0)));
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

num convertPPBToPPM(num value) => value * 0.001;

void applyCorrectionsToRawData(Map<String, num> monitorData) {
  if (!monitorData.containsKey("T") || !monitorData.containsKey("TVOC") || !monitorData.containsKey("PM2.5")) {
    throw Exception("Missing essential sensor readings in monitorData");
  }

  monitorData["T"] = convertCelciusToFarenheit(monitorData["T"]!);
  monitorData["TVOC"] = convertPPBToPPM(monitorData["TVOC"]!);

  // Apply EPA Correction Formula for PM 2.5
  monitorData["PM2.5"] = applyCorrectionFormulaPM2(monitorData["PM2.5"]!, monitorData["pm003Count"]!, monitorData["RH"]!, monitorData["plantower"]!);
}

num convertPTSerialToNum(String ptSerial) {
  final cleanedSerial = ptSerial.replaceAll("-", "");
  if (cleanedSerial.length < 8) {
    throw ArgumentError("Invalid Plantower serial: $ptSerial");
  }

  return int.parse(cleanedSerial.substring(0, 8));
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
