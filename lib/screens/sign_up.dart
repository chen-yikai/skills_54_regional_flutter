import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skills_54_regional_flutter/util.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var hidePassword = true, hideConfirmPassword = true;

  var name = TextEditingController(),
      email = TextEditingController(),
      passwordCofirm = TextEditingController(),
      password = TextEditingController();

  var emailError = false, passwordError = false, confirmPasswordError = false;

  samePassword(String _) {
    if (password.text != passwordCofirm.text) {
      confirmPasswordError = true;
    } else {
      confirmPasswordError = false;
    }
    setState(() {});
  }

  checkEmail(String _) {
    if (Utils.emailFormat.hasMatch(email.text) && !email.text.contains(" ")) {
      emailError = false;
    } else {
      emailError = true;
    }
    setState(() {});
  }

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
                controller: name,
                decoration: InputDecoration(
                  labelText: "暱稱",
                )),
            SizedBox(height: 20),
            TextField(
                controller: email,
                onChanged: checkEmail,
                decoration: InputDecoration(
                  errorText: emailError ? "Email格式錯誤" : null,
                  labelText: "帳號(Email)",
                )),
            SizedBox(height: 10),
            TextField(
                controller: password,
                obscureText: hidePassword,
                obscuringCharacter: '*',
                onChanged: samePassword,
                decoration: InputDecoration(
                  errorText: passwordError ? "密碼格式錯誤" : null,
                  labelText: "主密碼",
                  suffixIcon: IconButton(
                      icon: Icon(hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      }),
                )),
            SizedBox(height: 10),
            TextField(
                controller: passwordCofirm,
                obscureText: hideConfirmPassword,
                obscuringCharacter: '*',
                onChanged: samePassword,
                decoration: InputDecoration(
                  labelText: "確認主密碼",
                  errorText: confirmPasswordError ? "密碼和主密碼不同" : null,
                  suffixIcon: IconButton(
                      icon: Icon(hideConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      }),
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
