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

IValue calculateIValue(String name, num qi) {
  BreakpointValues values = getBreakpointValues(name, qi);
  return IValue(name, (values.iHigh - values.iLow)/(values.bpHigh - values.bpLow)*(qi - values.bpLow) + values.iLow);
}

num calculateIArchValue(Map<String, num> sensorReadings) {
  // First, calculate Apparent Temperature
  sensorReadings["AT"] = calculateApparentTemperature(sensorReadings["T"]!, sensorReadings["RH"]!);

  List<IValue> iValuesList = iValues.keys.map((key) => calculateIValue(key, sensorReadings[key] ?? 0)).toList();
  IValue maxITerm = maxBy(iValuesList, (e) => e.i) ?? IValue("", 0);
  num n = maxITerm.i / 50;

  num sumITerms = iValuesList.fold<num>(0, (sum, iValue) => sum + pow(iValue.i, n));
  return pow(sumITerms/iValuesList.length, 1/n);
}

num reduceParameterValue(num value, String reduction) => value * (1 - num.parse(reduction));

num setParameterValue(String value) => num.parse(value);

Map<String, num> calculateReducedParameterValues(Map<String, num> sensorReadings, String condition) {
  Map<String, String> revitalizationOption = remediationConditions.firstWhere(
    (element) => element["condition"] == condition,
    orElse: () => throw Exception("Revitalization option $condition not valid!!!!"),
  );

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

List<Revitalization> calculateRevitalizationIArchValues(Map<String, num> sensorReadings) => 
  remediationConditions.map((condition) {
    Map<String, num> newSensorReadings = calculateReducedParameterValues(sensorReadings, condition["condition"]!);
    return Revitalization(int.parse(condition["option"]!), condition["condition"]!, calculateIArchValue(newSensorReadings));
  }
).toList();
