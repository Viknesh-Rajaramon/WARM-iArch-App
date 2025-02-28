import "package:warm_app/const.dart";

// https://www.airgradient.com/blog/low-readings-from-pms5003/
num pm25Correction(num pm25, num pm003Count, num scalingFactor, num intercept) {
  num calibrated = 0;

  num lowCalibrated = (scalingFactor * pm003Count) + intercept;
  if (lowCalibrated < 31) {
    calibrated = lowCalibrated;
  } else {
    calibrated = pm25;
  }

  if (calibrated < 0) {
    return 0.0;
  }

  return calibrated;
}

// https://www.airgradient.com/documentation/correction-algorithms/#pm_epa_correction
// https://www.airgradient.com/blog/epa-correction-and-airgradient/#implementation
num applyCorrectionFormulaPM2(num pm25, num pm003Count, num rh) {
  num value = 0.0;

  if (rh < 0) {
    rh = 0;
  }

  if (rh > 100) {
    rh = 100;
  }

  pm25 = pm25Correction(pm25, pm003Count, scalimgFactorsForCorrection["20231030"]!["scalingFactor"]!, scalimgFactorsForCorrection["20231030"]!["intercept"]!);

  if (pm25 == 0) {
    value = 0.0;
  }

  if (pm25 < 30) {
    value = (0.524 * pm25) - (0.0862 * rh) + 5.75;
  } else if (pm25 < 50) {
    value = (0.786 * (pm25 * 0.05 - 1.5) + 0.524 * (1.0 - (pm25 * 0.05 - 1.5))) * pm25 - (0.0862 * rh) + 5.75;
  } else if (pm25 < 210) {
    value = (0.786 * pm25) - (0.0862 * rh) + 5.75;
  } else if (pm25 < 260) {
    value = (0.69 * (pm25 * 0.02 - 4.2) + 0.786 * (1.0 - (pm25 * 0.02 - 4.2))) * pm25 - (0.0862 * rh * (1.0 - 
            (pm25 * 0.02 - 4.2))) + (2.966 * (pm25 * 0.02 - 4.2)) + (5.75 * (1.0 - (pm25 * 0.02 - 4.2))) + (8.84 * 0.0001 * 
            pm25 * pm25 * (pm25 * 0.02 - 4.2));
  } else {
    value = 2.966 + (0.69 * pm25) + (8.84 * 0.0001 * pm25 * pm25);
  }

  if (value < 0) {
    return 0.0;
  }

  return value;
}
