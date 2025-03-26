import "dart:io";
import "package:flutter/foundation.dart";

import "package:warm_app/db/database.dart";
import "package:warm_app/backend/const.dart";

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
      int.parse(json["location_id"].toString()),
      json["name"] as String,
      json["plantower_serial"] ?? defaultPTSerial,
      json["project_id"] as String,
    );
  }
}

Future<(List<Monitor>, int)> getMonitorsByProjectId(String projectId) async {
  if (projectId.isEmpty) {
    return (<Monitor>[], HttpStatus.badRequest);
  }

  try {
    String query = "SELECT * FROM monitors WHERE project_id = :projectId";
    Map<String, dynamic> params = {"projectId": projectId};

    final result = await DatabaseService().execute(query, params: params);

    if (result.numOfRows == 0) {
      return (<Monitor>[], HttpStatus.notFound);
    }

    List<Monitor> monitors = result.rows.map((row) => Monitor.fromJson(row.assoc())).toList();
      
    return (monitors, HttpStatus.found);
  } catch (e) {
    debugPrint("Database error in getMonitorsByProjectId(): $e");
    return (<Monitor>[], HttpStatus.internalServerError);
  }
}

Future<Map<int, String>> getLocationIdsAndPlantowerSerialByProjectId(String projectId) async {
  if (projectId.isEmpty) {
    return {};
  }
    
  final (monitors, status) = await getMonitorsByProjectId(projectId);
  return status == HttpStatus.found ? {for (var monitor in monitors) monitor.locationId: monitor.plantowerSerial} : {};
}
