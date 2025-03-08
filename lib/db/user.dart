import 'dart:io';
import 'package:dbcrypt/dbcrypt.dart';

import "package:warm_app/db/database.dart";

class User {
  final String uuid;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String salt;
  final String projectId;

  const User(this.uuid, this.firstName, this.lastName, this.email, this.password, this.salt, this.projectId);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json["uuid"] as String,
      json["first_name"] as String,
      json["last_name"] as String,
      json["email"] as String,
      json["password"] as String,
      json["salt"] as String,
      json["project_id"] as String,
    );
  }
}

Future<(User?, int)> getUserByEmail(String email) async {
  if (email == "") {
    return (null, HttpStatus.badRequest);
  }

  try {
    final result = await DatabaseService().conn.execute("SELECT * FROM users WHERE email = :email LIMIT 1", {"email": email});

    if (result.numOfRows == 0) {
      return (null, HttpStatus.notFound);
    }

    return (User.fromJson(result.rows.first.assoc()), HttpStatus.found);
  } catch (_) {
    return (null, HttpStatus.internalServerError);
  }
}

bool isPasswordAndHashEqual(String password, String hashedPassword, String salt) {
  return DBCrypt().checkpw(password, salt+hashedPassword);
}
