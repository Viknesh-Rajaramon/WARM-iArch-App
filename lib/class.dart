import 'package:flutter/material.dart';

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
  final Color color;

  const BreakpointValues(this.iLow, this.iHigh, this.bpLow, this.bpHigh, this.comments, this.color);
}

class IValue {
  final String name;
  final num i;

  const IValue(this.name, this.i);
}

class Revitalization {
  final String condition;
  final num iArch;

  const Revitalization(this.condition, this.iArch);
}
