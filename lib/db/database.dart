import "package:flutter/foundation.dart";
import "package:mysql_client/mysql_client.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  MySQLConnection? connection;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<void> initializeDB() async {
    if (connection != null && connection!.connected) {
      debugPrint("Database already connected.");
      return;
    }
    
    try {
      await dotenv.load(fileName: ".env");

      connection = await MySQLConnection.createConnection(
        host: dotenv.env["DB_HOST"] ?? "localhost",
        port: int.tryParse(dotenv.env["DB_PORT"] ?? "3306") ?? 3306,
        userName: dotenv.env["DB_USER"] ?? "",
        password: dotenv.env["DB_PASSWORD"] ?? "",
        databaseName: dotenv.env["DB_NAME"],
        collation: dotenv.env["DB_COLLATION"] ?? "utf8mb4_general_ci",
      );

      await connection!.connect();
      debugPrint("Database connected successfully.");
    } catch (e) {
      debugPrint("Database connection failed: $e");
      connection = null;
    }
  }

  MySQLConnection get conn {
    if (connection == null || !connection!.connected) {
      throw Exception("Database connection is not initialized. Call initializeDB() first.");
    }
    return connection!;
  }

  Future<void> closeConnection() async {
    if (connection != null && connection!.connected) {
      await connection!.close();
      debugPrint("Database connection closed.");
    }
    connection = null;
  }
}
