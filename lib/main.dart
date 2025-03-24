import "package:flutter/material.dart";

import "package:warm_app/routes.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IArchApp());
}

class IArchApp extends StatelessWidget {
  const IArchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.auth,
      onGenerateRoute: AppRoutes.generateRoute,
      onUnknownRoute: AppRoutes.unknownRoute,
    );
  }
}
