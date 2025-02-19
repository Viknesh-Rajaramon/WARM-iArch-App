class SensorDisplayUnit {
  final String displayName;
  final String unit;
  final int decimalPoint;

  const SensorDisplayUnit(this.displayName, this.unit, this.decimalPoint);
}

class BreakpointValues {
  final num iLow;
  final num iHigh;
  final num bpLow;
  final num bpHigh;
  final String comments;

  const BreakpointValues(this.iLow, this.iHigh, this.bpLow, this.bpHigh, this.comments);
}

class IValue {
  final String name;
  final num i;

  const IValue(this.name, this.i);
}

class Revitalization {
  final String option;
  final String condition;
  final num iArch;

  const Revitalization(this.option, this.condition, this.iArch);
}
