import "package:flutter/foundation.dart";
import "package:mysql_client/mysql_client.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  MySQLConnection? _connection;

  factory DatabaseService() => _instance;

  DatabaseService._internal() {
    _connect();
  }

  Future<void> _connect() async {
    if (_connection != null && _connection!.connected) {
      debugPrint("Database already connected.");
      return;
    }
    
    try {
      await dotenv.load(fileName: ".env");

      _connection = await MySQLConnection.createConnection(
        host: dotenv.env["DB_HOST"] ?? "localhost",
        port: int.tryParse(dotenv.env["DB_PORT"] ?? "3306") ?? 3306,
        userName: dotenv.env["DB_USER"] ?? "",
        password: dotenv.env["DB_PASSWORD"] ?? "",
        databaseName: dotenv.env["DB_NAME"],
        collation: dotenv.env["DB_COLLATION"] ?? "utf8mb4_general_ci",
      );

      await _connection?.connect(timeoutMs: 20000);
      debugPrint("Database connected successfully.");
    } catch (e) {
      debugPrint("Database connection failed: $e");
      _connection = null;
    }
  }

  MySQLConnection get conn {
    if (_connection == null || !_connection!.connected) {
      throw Exception("Database connection is not initialized. Call initializeDB() first.");
    }
    return _connection!;
  }

  Future<void> close() async {
    if (_connection != null && _connection!.connected) {
      await _connection!.close();
      debugPrint("Database connection closed.");
    }
    _connection = null;
  }

  Future<IResultSet> execute(String query, {Map<String, dynamic>? params}) async {
    if (_connection == null || !_connection!.connected) {
      await _connect();
    }

    if (!_connection!.connected) {
      throw Exception('Could not connect to the database');
    }
    
    return _connection!.execute(query, params);
  }
}
