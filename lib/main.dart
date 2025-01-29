import 'package:flutter/material.dart';
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
    // var router = GoRouter(initialLocation: "/", routes: [
    //   GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    //   GoRoute(
    //       path: '/sign-in', builder: (context, state) => const SignInScreen()),
    //   GoRoute(
    //       path: '/sign-up', builder: (context, state) => const SignUpScreen()),
    //   GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    //   GoRoute(
    //       path: '/add', builder: (context, state) => const AddPasswordScreen()),
    //   GoRoute(
    //     path: '/view/:id',
    //     builder: (context, state) => ViewScreen(id: state.pathParameters['id']),
    //   )
    // ]);
    // return MaterialApp.router(
    //     routerConfig: router, debugShowCheckedModeBanner: false);
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
