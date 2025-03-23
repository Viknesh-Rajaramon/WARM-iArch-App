import "dart:io";
import "package:dbcrypt/dbcrypt.dart";

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
  if (email == "") {
    return (null, HttpStatus.badRequest);
  }

  return await Future(() async {
    try {
      final result = await DatabaseService().conn.execute("SELECT * FROM users WHERE email = :email LIMIT 1", {"email": email});

      if (result.numOfRows == 0) {
        return (null, HttpStatus.notFound);
      }

      return (User.fromJson(result.rows.first.assoc()), HttpStatus.found);
    } catch (_) {
      return (null, HttpStatus.internalServerError);
    }
  });
}

bool convertStringToBool(String value) {
  int? val = int.tryParse(value);
  if (val == null) {
    return true;
  }
  
  return val == 0 ? false : true;
}

bool isPasswordAndHashEqual(String password, String hashedPassword, String salt) {
  return DBCrypt().checkpw(password, salt+hashedPassword);
}

Future<int> updateUserPassword(String uuid, String newPassword) async {
  if (uuid == "" || newPassword == "") {
    return HttpStatus.badRequest;
  }

  return await Future(() async {
    String salt = DBCrypt().gensaltWithRounds(14);
    String hashedPassword = DBCrypt().hashpw(newPassword, salt).substring(salt.length);

    try {
      final result = await DatabaseService().conn.execute("UPDATE users SET password = :hashedPassword, salt = :salt, is_first_login = FALSE WHERE uuid = :uuid", {"hashedPassword": hashedPassword, "salt": salt, "uuid": uuid});

      if (result.affectedRows == BigInt.zero) {
        return HttpStatus.noContent;
      }

      return HttpStatus.accepted;
    } catch (_) {
      return HttpStatus.internalServerError;
    }
  });
}
