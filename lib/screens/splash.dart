import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skills_54_regional_flutter/screens/home.dart';
import 'package:skills_54_regional_flutter/screens/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navtohome();
  }

  Future<void> navtohome() async {
    await Future.delayed(const Duration(seconds: 0));
    // if (mounted) context.go('/sign-in');
    if (mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.lock, size: 100),
            SizedBox(height: 20),
            Text(
              '我的密碼庫',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
