import "dart:io";
import "package:flutter/foundation.dart";

import "package:warm_app/db/database.dart";
import "package:warm_app/backend/data_type_conversion.dart";
import "package:warm_app/backend/password.dart";

class User {
  final String uuid;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String salt;
  final String projectId;
  final bool isFirstLogin;

  const User(this.uuid, this.firstName, this.lastName, this.email, this.password, this.salt, this.projectId, this.isFirstLogin);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json["uuid"] as String,
      json["first_name"] as String,
      json["last_name"] as String,
      json["email"] as String,
      json["password"] as String,
      json["salt"] as String,
      json["project_id"] as String,
      convertStringToBool(json["is_first_login"]),
    );
  }
}

Future<(User?, int)> getUserByEmail(String email) async {
  if (email.isEmpty) {
    return (null, HttpStatus.badRequest);
  }

  try {
    String query = "SELECT * FROM users WHERE email = :email LIMIT 1";
    Map<String, dynamic> params = {"email": email};

    final result = await DatabaseService().execute(query, params: params);

    if (result.numOfRows == 0) {
      return (null, HttpStatus.notFound);
    }

    return (User.fromJson(result.rows.first.assoc()), HttpStatus.found);
  } catch (e) {
    debugPrint("Database error in getUserByEmail(): $e");
    return (null, HttpStatus.internalServerError);
  }
}

Future<int> updateUserPassword(String uuid, String newPassword) async {
  if (uuid.isEmpty || newPassword.isEmpty) {
    return HttpStatus.badRequest;
  }

  final data = await compute(getSaltAndHashedPassword, newPassword);
  String salt = data.$1;
  String hashedPassword = data.$2;

  try {
    String query = "UPDATE users SET password = :hashedPassword, salt = :salt, is_first_login = FALSE WHERE uuid = :uuid";
    Map<String, dynamic> params = {"hashedPassword": hashedPassword, "salt": salt, "uuid": uuid};

    final result = await DatabaseService().execute(query, params: params);

    return result.affectedRows == BigInt.zero ? HttpStatus.noContent : HttpStatus.accepted;
  } catch (e) {
    debugPrint("Database error in updateUserPassword(): $e");
    return HttpStatus.internalServerError;
  }
}
