import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:http/http.dart";

import "package:warm_app/util.dart";
import "package:warm_app/const.dart";
import "package:warm_app/calculation.dart";

const apiCurrentString = "https://api.airgradient.com/public/api/v1/locations/measures/current?token={token}";
const apiHistoricString = "https://api.airgradient.com/public/api/v1/locations/{locationId}/measures/raw?token={token}&from={from}&to={to}";

Future<Map<String, Map<String, num>>> getCurrentMonitorDataFromAllLocations(String token, Map<int, String> locationIds) async {
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

Map<String, Map<String, num>> getProcessedCurrentMonitorData((String responseBody, Map<int, String> locationIds) data) {
  final responseBody = data.$1;
  final locationIds = data.$2;
  
  List<dynamic> monitors = json.decode(responseBody);
  final monitorData = <String, Map<String, num>>{};

  for (final monitor in monitors) {
    try {
      final int locationId = monitor["locationId"];
      final String locationName = monitor["locationName"];

      if (locationIds.containsKey(locationId)) {
        monitorData[locationName] = {
          "PM2.5": monitor["pm02"] ?? 0,
          "PM10": monitor["pm10"] ?? 0,
          "TVOCppb": monitor["tvoc"] ?? 0,
          "CO2": monitor["rco2"] ?? 0,
          "RH": monitor["rhum"] ?? 0,
          "T": monitor["atmp"] ?? 0,
          "pm003Count": monitor["pm003Count"] ?? 0,
          "plantower": convertPTSerialToNum(locationIds[locationId] ?? defaultPTSerial),
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

Future<List<num>> getHistoricMonitorDataByLocationId(String token, num locationId, num plantowerSerial) async {
  String uri = apiHistoricString.replaceAll("{locationId}", locationId.toString()).replaceAll("{token}", token);
  var (from, to) = getfromAndToTimestamp();
  uri = uri.replaceAll("{from}", from).replaceAll("{to}", to);

  try {
    final response = await get(Uri.parse(uri));

    if (response.statusCode == HttpStatus.ok) {
      return await compute(getProcessedHistoricMonitorData, (response.body, plantowerSerial));
    } else {
      throw HttpException("Failed to load data: ${response.statusCode}");
    }
  } catch(error) {
    debugPrint("Error fetching data: $error");
    return [];
  }
}

List<num> getProcessedHistoricMonitorData((String responseBody, num plantowerSerial) data) {
  final responseBody = data.$1;
  final plantowerSerial = data.$2;

  List<dynamic> monitors = json.decode(responseBody);
  return monitors.map((monitor) {
    try {
      Map<String, num> data = {
        "PM2.5": monitor["pm02"] ?? 0,
        "PM10": monitor["pm10"] ?? 0,
        "TVOCppb": monitor["tvoc"] ?? 0,
        "CO2": monitor["rco2"] ?? 0,
        "RH": monitor["rhum"] ?? 0,
        "T": monitor["atmp"] ?? 0,
        "pm003Count": monitor["pm003Count"] ?? 0,
        "plantower": plantowerSerial,
      };

      applyCorrectionsToRawData(data);
      return calculateIArchValue(data);
    } catch (e) {
      debugPrint("Error processing monitor data: $e");
      return 0;
    }
  }).toList();
}
