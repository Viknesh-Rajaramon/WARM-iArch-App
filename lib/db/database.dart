import "package:mysql_client/mysql_client.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late MySQLConnection conn;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> initializeDB() async {
    await dotenv.load(fileName: ".env");
    
    conn = await MySQLConnection.createConnection(
      host: dotenv.env["DB_HOST"],
      port: int.parse(dotenv.env["DB_PORT"]!),
      userName: dotenv.env["DB_USER"]!,
      password: dotenv.env["DB_PASSWORD"]!,
      databaseName: dotenv.env["DB_NAME"]!,
      collation: dotenv.env["DB_COLLATION"]!,
    );

    await conn.connect();
  }

  Future<void> closeConnection() async {
    await conn.close();
  }
}
