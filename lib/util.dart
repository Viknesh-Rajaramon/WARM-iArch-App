import "package:warm_app/class.dart";
import "package:warm_app/const.dart";

// Get the display name and the unit for a given sensor reading
SensorDisplayUnit getDisplayName(String key) {
  var reading = displayNames.firstWhere(
    (element) => element["reading"] == key,
    orElse: () => {"displayName": key, "unit": ""},
  );
  return SensorDisplayUnit(reading["displayName"] ?? "", reading["unit"] ?? "", int.parse(reading["decimalPoint"] ?? "0"));
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
