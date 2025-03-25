import 'package:flutter/material.dart';

import 'package:warm_app/auth.dart';
import 'package:warm_app/faq_page.dart';
import 'package:warm_app/forgot_password.dart';

class AppRoutes {
  static const String auth = "/auth";
  static const String faq = "/faq";
  static const String forgotPassword = "/forgot_password";

  static final Map<String, WidgetBuilder> routes = {
    auth: (context) => const AuthPage(),
    faq: (context) => const FAQPage(),
    forgotPassword: (context) => const ForgotPasswordPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    return MaterialPageRoute(
      builder: (context) => const AuthPage(),
    );
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const AuthPage(),
    );
  }
}
