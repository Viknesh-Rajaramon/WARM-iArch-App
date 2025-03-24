import "package:collection/collection.dart";
import "dart:math";

import "package:warm_app/class.dart";
import "package:warm_app/util.dart";
import "package:warm_app/const.dart";

// Calculate the Apparent Temperature (from Formula)
num calculateApparentTemperature(num T, num rh) =>
  -42.379 + (2.04901523 * T) + (10.14333127 * rh)
  - (0.22475541 * T * rh) - (6.83783 * pow(10.0, -3) * pow(T, 2))
  - (5.481717 * pow(10.0, -2) * pow(rh, 2)) + (1.22874 * pow(10.0, -3) * pow(T, 2) * rh)
  + (8.5282 * pow(10.0, -4) * T * pow(rh, 2)) - (1.99 * pow(10.0, -6) * pow(T, 2) * pow(rh, 2));

// Calculate IValue based on breakpoints
IValue calculateIValue(String name, num qi) {
  BreakpointValues values = getBreakpointValues(name, qi);
  return IValue(name, (values.iHigh - values.iLow)/(values.bpHigh - values.bpLow)*(qi - values.bpLow) + values.iLow);
}

// Calculate IArch value for sensor readings
num calculateIArchValue(Map<String, num> sensorReadings) {
  if (!sensorReadings.containsKey("T") || !sensorReadings.containsKey("RH")) {
    throw Exception("Temperature (T) and Relative Humidity (RH) must be provided.");
  }

  // First, calculate Apparent Temperature
  sensorReadings["AT"] = calculateApparentTemperature(sensorReadings["T"]!, sensorReadings["RH"]!);

  List<IValue> iValuesList = iValues.keys.map((key) => calculateIValue(key, sensorReadings[key] ?? 0)).toList();
  IValue maxITerm = maxBy(iValuesList, (e) => e.i) ?? IValue("", 0);
  num n = maxITerm.i / 50;

  num sumITerms = iValuesList.fold<num>(0, (sum, iValue) => sum + pow(iValue.i, n));
  return pow(sumITerms/iValuesList.length, 1/n);
}

// Reduce a parameter value based on a reduction percentage
num reduceParameterValue(num value, String reduction) {
  num? reductionNum = num.tryParse(reduction);
  return reductionNum != null ? value * (1 - reductionNum) : value;
}

// Set a parameter value based on string input
num setParameterValue(String value) => num.tryParse(value) ?? 0;

// Compute new sensor values after applying revitalization
Map<String, num> calculateReducedParameterValues(Map<String, num> sensorReadings, String condition) {
  final revitalizationOption = remediationConditions.firstWhereOrNull(
    (element) => element["condition"] == condition
  );

  if (revitalizationOption == null) {
    throw Exception("Revitalization option $condition not valid!!!!");
  }

  Map<String, num> newSensorReadings = Map<String, num>.from(sensorReadings);

  remediationParameters.forEach((key, values) {
    if (revitalizationOption.containsKey(key)) {
      final updateValue = key.contains("Reduction")
        ? (String parameter) => newSensorReadings[parameter] = reduceParameterValue(newSensorReadings[parameter] ?? 0, revitalizationOption[key] ?? "0")
        : (String parameter) => newSensorReadings[parameter] = setParameterValue(revitalizationOption[key] ?? "0");
      
      values.forEach(updateValue);
    }
  });

  return newSensorReadings;
}

// Compute revitalization IArch values
List<Revitalization> calculateRevitalizationIArchValues(Map<String, num> sensorReadings) { 
  return remediationConditions.map((condition) {
    try {
      Map<String, num> newSensorReadings = calculateReducedParameterValues(sensorReadings, condition["condition"]!);
      return Revitalization(int.tryParse(condition["option"] ?? "0") ?? 0, condition["condition"]!, calculateIArchValue(newSensorReadings));
    } catch(e) {
      return Revitalization(0, "Error: ${condition["condition"]}", 0);
    }
  }).toList();
}
