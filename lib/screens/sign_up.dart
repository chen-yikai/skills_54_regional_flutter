import 'package:flutter/material.dart';
import 'package:skills_54_regional_flutter/db.dart';
import 'package:skills_54_regional_flutter/screens/sign_in.dart';
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

  samePassword(_) {
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

  signUp(String email, name, password) async {
    if (emailError || passwordError || confirmPasswordError) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("資料格式錯誤")));
      }
      return;
    }
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("資料未填寫完整")));
      }
      return;
    }
    bool success = await UserTable.signUp(UserSchema(
        email: email,
        name: name,
        password: password,
        collections: "",
        customOrder: ""));
    if (!success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("註冊失敗email已被註冊"),
        ));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("註冊成功"),
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      }
    }
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
            Sh(h: 20),
            TextField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "暱稱",
                )),
            Sh(h: 20),
            TextField(
                controller: email,
                onChanged: checkEmail,
                decoration: InputDecoration(
                  errorText: emailError ? "Email格式錯誤" : null,
                  labelText: "帳號(Email)",
                )),
            Sh(h: 10),
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
            Sh(h: 10),
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
            Sh(h: 20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  signUp(email.text, name.text, password.text);
                },
                child: Text("註冊"))
          ],
        ),
      ),
    ));
  }
}
