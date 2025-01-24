import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skills_54_regional_flutter/screens/home.dart';
import 'package:skills_54_regional_flutter/screens/sign_in.dart';
import 'package:skills_54_regional_flutter/screens/sign_up.dart';
import 'package:skills_54_regional_flutter/screens/splash.dart';

void main() {
  runApp(const Entry());
}

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    var router = GoRouter(initialLocation: "/", routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
          path: '/sign-in', builder: (context, state) => const SignInScreen()),
      GoRoute(
          path: '/sign-up', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen())
    ]);
    return MaterialApp.router(
        routerConfig: router, debugShowCheckedModeBanner: false);
  }
}
