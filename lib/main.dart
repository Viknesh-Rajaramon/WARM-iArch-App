import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

import "package:warm_app/auth.dart";
import "package:warm_app/db/database.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await DatabaseService().initializeDB();
  runApp(IArchApp());
}

class IArchApp extends StatelessWidget {
  const IArchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        "/auth": (_) => AuthPage()
      },
    );
  }
}
