import "package:flutter/material.dart";

import "package:warm_app/auth.dart";
import "package:warm_app/routes.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IArchApp());
}

class IArchApp extends StatelessWidget {
  const IArchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.auth,
      onGenerateRoute: AppRoutes.generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const AuthPage(),
      ),
    );
  }
}
