import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_54_regional_flutter/db.dart';
import 'package:skills_54_regional_flutter/screens/home.dart';
import 'package:skills_54_regional_flutter/screens/sign_up.dart';
import 'package:skills_54_regional_flutter/util.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var hidePassword = true;
  var email = TextEditingController(), password = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkRememberAuth();
  }

  Future<void> checkRememberAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('signIn') ?? false) {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }
  }

  Future<void> savePrefs() async {
    String name = await UserTable.selectName(email.text);
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('email', email.text);
      prefs.setBool('signIn', true);
      prefs.setString('name', name);
    });
  }

  Future<void> signIn() async {
    final auth = await UserTable.auth(email.text, password.text);
    if (auth) {
      savePrefs();
      await UserTable.selectName(email.text);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("登入成功")));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("帳號或密碼錯誤")));
      }
    }
  }

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
            Sh(h: 50),
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "帳號(Email)",
              ),
            ),
            Sh(h: 20),
            TextField(
              controller: password,
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
            Sh(h: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: signIn,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: Text("註冊帳號"),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
