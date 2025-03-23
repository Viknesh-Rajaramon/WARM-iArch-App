import "package:mysql_client/mysql_client.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late MySQLConnection conn;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<void> initializeDB() async {
    try {
      await dotenv.load(fileName: ".env");

      conn = await MySQLConnection.createConnection(
        host: dotenv.env["DB_HOST"] ?? "localhost",
        port: int.tryParse(dotenv.env["DB_PORT"] ?? "3306") ?? 3306,
        userName: dotenv.env["DB_USER"] ?? "",
        password: dotenv.env["DB_PASSWORD"] ?? "",
        databaseName: dotenv.env["DB_NAME"],
        collation: dotenv.env["DB_COLLATION"] ?? "utf8mb4_general_ci",
      );

      await conn.connect();
      print("Database connected successfully.");
    } catch (e) {
      print("Database connection failed: $e");
    }
  }

  Future<void> closeConnection() async {
    await conn.close();
  }
}
