import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 100),
            Text(
              "歡迎使用\n我的密碼庫",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                labelText: "帳號(Email)",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: hidePassword,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                labelText: "主密碼",
                suffixIcon: IconButton(
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    }),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Text("登入")),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.grey),
                      foregroundColor: WidgetStateProperty.all(Colors.black),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {
                    context.go('/sign-up');
                  },
                  child: Text("註冊帳號"),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
