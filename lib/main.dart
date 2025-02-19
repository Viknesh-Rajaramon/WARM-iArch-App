import "package:flutter/material.dart";
import "auth.dart";

void main() async {
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
