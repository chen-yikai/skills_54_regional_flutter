import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("註冊帳號",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "暱稱",
            )),
            SizedBox(height: 20),
            TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "帳號(Email)",
            )),
            SizedBox(height: 10),
            TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "主密碼",
            )),
            SizedBox(height: 10),
            TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "確認主密碼",
            )),
            SizedBox(height: 50),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  context.go("/sign-in");
                },
                child: Text("註冊"))
          ],
        ),
      ),
    ));
  }
}
