import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:http/http.dart";

import "package:warm_app/util.dart";

const apiString = "https://api.airgradient.com/public/api/v1/locations/measures/current?token={token}";
const token = "41ef5cae-2f14-470c-90ef-e64cb2fb8512";

Future<Map<String, Map<String, num>>> getCurrentMonitorDataFromAllLocations(String token) async {
  String uri = apiString.replaceAll("{token}", token);
  
  try {
    final response = await get(Uri.parse(uri));

    if (response.statusCode == HttpStatus.ok) {
      return await compute(getProcessedCurrentMonitorData, response.body);
    } else {
      throw Exception('Failed to load data');
    }
  } catch(error) {
    print('Error fetching data: $error');
    return <String, Map<String, num>> {};
  }
}

Map<String, Map<String, num>> getProcessedCurrentMonitorData(String responseBody) {
  List<Map<String, dynamic>> monitors = List<Map<String, dynamic>>.from(json.decode(responseBody));

  Map<String, Map<String, num>> monitorData = {};

  for (Map<String, dynamic> monitor in monitors) {
    monitorData[monitor["locationName"]] = {
      "PM2.5": monitor["pm02"] ?? 0,
      "PM10": monitor["pm10"] ?? 0,
      "TVOC": monitor["tvocIndex"] ?? 0,
      "CO2": monitor["rco2"] ?? 0,
      "RH": monitor["rhum"] ?? 0,
      "T": monitor["atmp"] ?? 0,
      "pm003Count": monitor["pm003Count"] ?? 0,
    };

    applyCorrectionsToRawData(monitorData[monitor["locationName"]]!);
  }

  return monitorData;
}