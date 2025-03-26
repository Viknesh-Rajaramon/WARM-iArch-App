import "package:dbcrypt/dbcrypt.dart";

bool isPasswordAndHashEqual(String password, String hashedPassword, String salt) {
  return DBCrypt().checkpw(password, salt+hashedPassword);
}

(String, String) getSaltAndHashedPassword(String newPassword) {
  String salt = DBCrypt().gensaltWithRounds(10);
  String hashedPassword = DBCrypt().hashpw(newPassword, salt).substring(salt.length);

  return (salt, hashedPassword);
}
