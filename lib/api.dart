import "dart:convert";
import "dart:io";
import "package:http/http.dart";

import "package:warm_app/util.dart";
import "package:warm_app/const.dart";

const apiString = "https://api.airgradient.com/public/api/v1/locations/measures/current?token={token}";

Future<Map<String, Map<String, num>>> getCurrentMonitorDataFromAllLocations(String token, Map<int, String> locationIds) async {
  String uri = apiString.replaceAll("{token}", token);

  try {
    final response = await get(Uri.parse(uri));

    if (response.statusCode == HttpStatus.ok) {
      return getProcessedCurrentMonitorData(response.body, locationIds);
    } else {
      throw HttpException("Failed to load data: ${response.statusCode}");
    }
  } catch(error) {
    print("Error fetching data: $error");
    return {};
  }
}

Map<String, Map<String, num>> getProcessedCurrentMonitorData(String responseBody, Map<int, String> locationIds) {
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
          "TVOC": monitor["tvoc"] ?? 0,
          "CO2": monitor["rco2"] ?? 0,
          "RH": monitor["rhum"] ?? 0,
          "T": monitor["atmp"] ?? 0,
          "pm003Count": monitor["pm003Count"] ?? 0,
          "plantower": convertPTSerialToNum(locationIds[locationId] ?? defaultPTSerial),
          "timestamp": DateTime.parse(monitor["timestamp"]!).millisecondsSinceEpoch,
        };

        applyCorrectionsToRawData(monitorData[locationName]!);
      }
    } catch (e) {
      print("Error processing monitor data: $e");
    }
  }
  
  return monitorData;
}
