import "package:warm_app/const.dart";

// https://www.airgradient.com/blog/low-readings-from-pms5003/
num pm25Correction(num pm25, num pm003Count, num scalingFactor, num intercept) {
  num lowCalibrated = (scalingFactor * pm003Count) + intercept;
  num calibrated = lowCalibrated < 31 ? lowCalibrated : pm25;

  return calibrated < 0 ? 0 : calibrated;
}

// https://www.airgradient.com/documentation/correction-algorithms/#pm_epa_correction
// https://www.airgradient.com/blog/epa-correction-and-airgradient/#implementation
num applyCorrectionFormulaPM2(num pm25, num pm003Count, num rh, num plantowerSerial) {
  rh = rh.clamp(0, 100);

  Map<String, num> plantowerFactors = scalingFactorsForCorrection[plantowerSerial]!;
  pm25 = pm25Correction(pm25, pm003Count, plantowerFactors["scalingFactor"]!, plantowerFactors["intercept"]!);

  if (pm25 == 0) {
    return 0.0;
  }

  if (pm25 < 30) {
    return (0.524 * pm25) - (0.0862 * rh) + 5.75;
  } else if (pm25 < 50) {
    num pm25Scaled = pm25 * 0.05 - 1.5;
    return (0.262 * pm25Scaled + 0.524) * pm25 - (0.0862 * rh) + 5.75;
  } else if (pm25 < 210) {
    return (0.786 * pm25) - (0.0862 * rh) + 5.75;
  } else if (pm25 < 260) {
    num pm25Factor = pm25 * 0.02 - 4.2;
    return (-0.096 * pm25Factor + 0.786) * pm25 - (0.0862 * rh * (1.0 - 
            pm25Factor)) + (2.966 * pm25Factor) + (5.75 * (1.0 - pm25Factor)) + (8.84 * 0.0001 * 
            pm25 * pm25 * pm25Factor);
  } else {
    return 2.966 + (0.69 * pm25) + (8.84 * 0.0001 * pm25 * pm25);
  }
}
