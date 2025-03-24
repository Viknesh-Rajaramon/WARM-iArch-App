import "dart:io";
import "package:dbcrypt/dbcrypt.dart";
import "package:flutter/foundation.dart";

import "package:warm_app/db/database.dart";

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
    final result = await DatabaseService().conn.execute("SELECT * FROM users WHERE email = :email LIMIT 1", {"email": email});

    if (result.numOfRows == 0) {
      return (null, HttpStatus.notFound);
    }

    return (User.fromJson(result.rows.first.assoc()), HttpStatus.found);
  } catch (e) {
    debugPrint("Database error in getUserByEmail(): $e");
    return (null, HttpStatus.internalServerError);
  }
}

bool convertStringToBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  
  if (value is int) {
    return value != 0;
  }

  return value.toString().trim() == "1";
}

bool isPasswordAndHashEqual(String password, String hashedPassword, String salt) {
  return DBCrypt().checkpw(password, salt+hashedPassword);
}

Future<int> updateUserPassword(String uuid, String newPassword) async {
  if (uuid.isEmpty || newPassword.isEmpty) {
    return HttpStatus.badRequest;
  }

  String salt = DBCrypt().gensaltWithRounds(14);
  String hashedPassword = DBCrypt().hashpw(newPassword, salt).substring(salt.length);

  try {
    final result = await DatabaseService().conn.execute("UPDATE users SET password = :hashedPassword, salt = :salt, is_first_login = FALSE WHERE uuid = :uuid", {"hashedPassword": hashedPassword, "salt": salt, "uuid": uuid});

    return result.affectedRows == BigInt.zero ? HttpStatus.noContent : HttpStatus.accepted;
  } catch (e) {
    debugPrint("Database error in updateUserPassword(): $e");
    return HttpStatus.internalServerError;
  }
}
