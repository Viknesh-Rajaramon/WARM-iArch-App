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
  try {
    if (projectId == "") {
      return (null, HttpStatus.badRequest);
    }
    
    final result = await DatabaseService().conn.execute("SELECT * FROM projects WHERE id = :id LIMIT 1", {"id": projectId});

    if (result.numOfRows == 0) {
      return (null, HttpStatus.notFound);
    }

    final project = result.rows.first.assoc();
    
    return (Project.fromJson(project), HttpStatus.found);
  } catch (e) {
    return (null, HttpStatus.internalServerError);
  }
}

Future<String> getTokenFromProjectId(String projectId) async {
  final result = await getProjectById(projectId);

  if (result.$2 != HttpStatus.found) {
    return "";
  }
  
  final Project project = result.$1 as Project;
  
  return project.token;
}
