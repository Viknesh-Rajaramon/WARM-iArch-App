import 'dart:io';

import "package:warm_app/db/database.dart";
import "package:warm_app/const.dart";

class Monitor {
  final String serialNumber;
  final int locationId;
  final String name;
  final String plantowerSerial;
  final String projectId;

  const Monitor(this.serialNumber, this.locationId, this.name, this.plantowerSerial, this.projectId);

  factory Monitor.fromJson(Map<String, dynamic> json) {
    return Monitor(
      json["serial_no"] as String,
      int.parse(json["location_id"]),
      json["name"] as String,
      json["plantower_serial"] ?? defaultPTSerial,
      json["project_id"] as String,
    );
  }
}

Future<(List<Monitor>, int)> getMonitorsByProjectId(String projectId) async {
  try {
    if (projectId == "") {
      return (<Monitor>[], HttpStatus.badRequest);
    }
    
    final result = await DatabaseService().conn.execute("SELECT * FROM monitors WHERE project_id = :projectId", {"projectId": projectId});

    if (result.numOfRows == 0) {
      return (<Monitor>[], HttpStatus.notFound);
    }

    List<Monitor> monitors = [];
    for (var row in result.rows) {
      var monitor = row.assoc();
      monitors.add(Monitor.fromJson(monitor));
    }
    
    return (monitors, HttpStatus.found);
  } catch (e) {
    return (<Monitor>[], HttpStatus.internalServerError);
  }
}

Future<Map<int, String>> getLocationIdsAndPlantowerSerialByProjectId(String projectId) async {
  if (projectId == "") {
    return {};
  }
    
  final result = await getMonitorsByProjectId(projectId);

  if (result.$2 != HttpStatus.found) {
    return {};
  }

  Map<int, String> locationPT = {};
  for (var monitor in result.$1) {
    locationPT[monitor.locationId] = monitor.plantowerSerial;
  }
    
  return locationPT;
}
