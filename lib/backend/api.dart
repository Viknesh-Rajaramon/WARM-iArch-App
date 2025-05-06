import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:http/http.dart";
import "dart:math";

import "package:warm_app/backend/util.dart";
import "package:warm_app/backend/const.dart";
import "package:warm_app/backend/calculation.dart";

const apiCurrentString = "https://api.airgradient.com/public/api/v1/locations/measures/current?token={token}";
const apiHistoricString = "https://api.airgradient.com/public/api/v1/locations/{locationId}/measures/raw?token={token}&from={from}&to={to}";

Future<Map<String, Map<String, num>>> getCurrentMonitorDataFromAllLocations(String token, List<int> locationIds) async {
  String uri = apiCurrentString.replaceAll("{token}", token);

  try {
    final response = await get(Uri.parse(uri));

    if (response.statusCode == HttpStatus.ok) {
      return await compute(getProcessedCurrentMonitorData, (response.body, locationIds));
    } else {
      throw HttpException("Failed to load data: ${response.statusCode}");
    }
  } catch(error) {
    debugPrint("Error fetching data: $error");
    return {};
  }
}

Map<String, Map<String, num>> getProcessedCurrentMonitorData((String responseBody, List<int> locationIds) data) {
  final responseBody = data.$1;
  final locationIds = data.$2;
  
  List<dynamic> monitors = json.decode(responseBody);
  final monitorData = <String, Map<String, num>>{};

  for (final monitor in monitors) {
    try {
      final int locationId = monitor["locationId"];
      final String locationName = monitor["locationName"];

      if (locationIds.contains(locationId)) {
        monitorData[locationName] = {
          "PM2.5": monitor["pm02_corrected"] ?? 0,
          "PM10": monitor["pm10_corrected"] ?? 0,
          "TVOCppb": monitor["tvoc"] ?? 0,
          "CO2": monitor["rco2"] ?? 0,
          "RH": monitor["rhum"] ?? 0,
          "T": monitor["atmp"] ?? 0,
          "timestamp": DateTime.parse(monitor["timestamp"]!).millisecondsSinceEpoch,
          "locationId": locationId,
        };

        applyCorrectionsToRawData(monitorData[locationName]!);
      }
    } catch (e) {
      debugPrint("Error processing monitor data: $e");
    }
  }
  
  return monitorData;
}

Future<List<num>> getHistoricMonitorDataByLocationId(String token, List<num>? iArchValues, Map<String, num> monitorValues) async {
  if (iArchValues != null) {
    return await compute(addRecentData, (iArchValues, monitorValues));
  }

  num locationId = monitorValues["locationId"]!;
  
  String uri = apiHistoricString.replaceAll("{locationId}", locationId.toString()).replaceAll("{token}", token);
  var (from, to) = getfromAndToTimestamp();
  uri = uri.replaceAll("{from}", from).replaceAll("{to}", to);

  try {
    final response = await get(Uri.parse(uri));

    if (response.statusCode == HttpStatus.ok) {
      return await compute(getProcessedHistoricMonitorData, (response.body));
    } else {
      throw HttpException("Failed to load data: ${response.statusCode}");
    }
  } catch(error) {
    debugPrint("Error fetching data: $error");
    return [];
  }
}

List<num> addRecentData((List<num> iArchValues, Map<String, num> monitorValues) data) {
  final iArchValues = data.$1;
  final monitorValues = data.$2;

  iArchValues.insert(0, calculateIArchValue(monitorValues));
  iArchValues.removeLast();
  return iArchValues;
}

List<num> getProcessedHistoricMonitorData(String responseBody) {
  List<dynamic> monitors = json.decode(responseBody);
  
  return monitors.map((monitor) {
    try {
      Map<String, num> data = {
        "PM2.5": monitor["pm02_corrected"] ?? 0,
        "PM10": monitor["pm10_corrected"] ?? 0,
        "TVOCppb": monitor["tvoc"] ?? 0,
        "CO2": monitor["rco2"] ?? 0,
        "RH": monitor["rhum"] ?? 0,
        "T": monitor["atmp"] ?? 0,
      };

      applyCorrectionsToRawData(data);
      return calculateIArchValue(data);
    } catch (e) {
      debugPrint("Error processing monitor data: $e");
      return 0;
    }
  }).toList().sublist(0, min(monitors.length, maxReadings));
}
