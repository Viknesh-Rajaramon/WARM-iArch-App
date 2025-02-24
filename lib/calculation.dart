import "package:collection/collection.dart";
import "dart:math";

import "package:warm_app/class.dart";
import "package:warm_app/util.dart";
import "package:warm_app/const.dart";

// Calculate the Apparent Temperature (from Formula)
num calculateApparentTemperature(num T, num rh) {
  num apparentTemperature = -42.379 + (2.04901523 * T) + (10.14333127 * rh)
  - (0.22475541 * T * rh) - (6.83783 * pow(10.0, -3) * pow(T, 2))
  - (5.481717 * pow(10.0, -2) * pow(rh, 2)) + (1.22874 * pow(10.0, -3) * pow(T, 2) * rh)
  + (8.5282 * pow(10.0, -4) * T * pow(rh, 2)) - (1.99 * pow(10.0, -6) * pow(T, 2) * pow(rh, 2));
  
  return apparentTemperature;
}

IValue calculateIValue(String name, num qi) {
  BreakpointValues values = getBreakpointValues(name, qi);
  num iValue = (values.iHigh - values.iLow)/(values.bpHigh - values.bpLow)*(qi - values.bpLow) + values.iLow;
  return IValue(name, iValue);
}

num calculateIArchValue(Map<String, num> sensorReadings) {
  // First, calculate Apparent Temperature
  sensorReadings["AT"] = calculateApparentTemperature(sensorReadings["T"]!, sensorReadings["RH"]!);

  List<IValue> iValuesList = [];
  for (var key in iValues.keys) {
    IValue iValue = calculateIValue(key, sensorReadings[key] ?? 0);
    iValuesList.add(iValue);
  }

  IValue maxITerm = maxBy(iValuesList, (e) => e.i) ?? IValue("", 0);
  num n = maxITerm.i / 50;

  int numIndices = iValuesList.length;
  
  num sumITerms = 0;
  for (var iValue in iValuesList) {
    sumITerms = sumITerms + pow(iValue.i, n);
  }

  num iARCHValue = pow(sumITerms / numIndices, 1 / n);

  return iARCHValue;
}

num reduceParameterValue(num value, String reduction) {
  num percent = 1 - num.parse(reduction);
  return value * percent;
}

num setParameterValue(String value) {
  return num.parse(value);
}

Map<String, num> calculateReducedParameterValues(Map<String, num> sensorReadings, String condition) {
  Map<String, String> revitalizationOption = remediationConditions.firstWhere(
    (element) => element["condition"] == condition,
    orElse: () => throw Exception("Revitalization option $condition not valid!!!!"),
  );

  Map<String, num> newSensorReadings = Map.from(sensorReadings);

  remediationParameters.forEach((key, values) {
    if (revitalizationOption.containsKey(key)) {
      if (key.contains("Reduction")) {
        for (String parameter in values) {
          newSensorReadings[parameter] = reduceParameterValue(newSensorReadings[parameter] ?? 0, revitalizationOption[key] ?? "0");
        }
      } else {
        for (String parameter in values) {
          newSensorReadings[parameter] = setParameterValue(revitalizationOption[key] ?? "0");
        }
      }
    }
  });

  return newSensorReadings;
}

List<Revitalization> calculateRevitalizationIArchValues(Map<String, num> sensorReadings) {
  List<Revitalization> options = [];
  for (Map<String, String> remediationCondition in remediationConditions) {
    Map<String, num> newSensorReadings = calculateReducedParameterValues(sensorReadings, remediationCondition["condition"]!);
    num iArchValue = calculateIArchValue(newSensorReadings);
    options.add(Revitalization(remediationCondition["condition"]!, iArchValue));
  }

  return options;
}
