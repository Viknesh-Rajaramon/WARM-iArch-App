import 'dart:io';

import "package:warm_app/db/database.dart";

class Project {
  final String id;
  final String locationName;
  final String token;

  const Project(this.id, this.locationName, this.token);

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      json["id"] as String,
      json["location_name"] as String,
      json["token"] as String,
    );
  }
}

Future<(Project?, int)> getProjectById(String projectId) async {
  if (projectId == "") {
    return (null, HttpStatus.badRequest);
  }

  try {
    final result = await DatabaseService().conn.execute("SELECT * FROM projects WHERE id = :id LIMIT 1", {"id": projectId});

    if (result.numOfRows == 0) {
      return (null, HttpStatus.notFound);
    }

    return (Project.fromJson(result.rows.first.assoc()), HttpStatus.found);
  } catch (_) {
    return (null, HttpStatus.internalServerError);
  }
}

Future<String> getTokenFromProjectId(String projectId) async {
  final (project, status) = await getProjectById(projectId);  
  return project != null && status == HttpStatus.found ? project.token : "";
}
