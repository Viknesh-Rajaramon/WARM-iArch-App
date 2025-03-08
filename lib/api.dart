import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:http/http.dart";

import "package:warm_app/util.dart";
import "package:warm_app/const.dart";

const apiString = "https://api.airgradient.com/public/api/v1/locations/measures/current?token={token}";

class Compute {
  final String responseBody;
  final Map<int, String> locationIds;

  const Compute(this.responseBody, this.locationIds);
}

Future<Map<String, Map<String, num>>> getCurrentMonitorDataFromAllLocations(String token, Map<int, String> locationIds) async {
  String uri = apiString.replaceAll("{token}", token);

  try {
    final response = await get(Uri.parse(uri));

    if (response.statusCode == HttpStatus.ok) {
      return await compute(getProcessedCurrentMonitorData, Compute(response.body, locationIds));
    } else {
      throw HttpException("Failed to load data: ${response.statusCode}");
    }
  } catch(error) {
    print('Error fetching data: $error');
    return {};
  }
}

Map<String, Map<String, num>> getProcessedCurrentMonitorData(Compute data) {
  List<Map<String, dynamic>> monitors = List<Map<String, dynamic>>.from(json.decode(data.responseBody));

  Map<String, Map<String, num>> monitorData = {};

  for (Map<String, dynamic> monitor in monitors) {
    int locationId = monitor["locationId"];
    String locationName = monitor["locationName"];
    
    if (data.locationIds.containsKey(locationId)) {
      monitorData[locationName] = {
        "PM2.5": monitor["pm02"] ?? 0,
        "PM10": monitor["pm10"] ?? 0,
        "TVOC": monitor["tvocIndex"] ?? 0,
        "CO2": monitor["rco2"] ?? 0,
        "RH": monitor["rhum"] ?? 0,
        "T": monitor["atmp"] ?? 0,
        "pm003Count": monitor["pm003Count"] ?? 0,
        "plantower": convertPTSerialToNum(data.locationIds[locationId] ?? defaultPTSerial),
      };

      applyCorrectionsToRawData(monitorData[locationName]!);
    }
  }

  return monitorData;
}
