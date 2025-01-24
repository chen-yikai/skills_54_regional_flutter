import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_54_regional_flutter/db.dart';
import 'package:skills_54_regional_flutter/util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name = '';
  String? email = '';
  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  Future<void> getPrefs() async {
    SharedPreferences.getInstance().then((prefs) {
      name = prefs.getString('name');
      email = prefs.getString('email');
      setState(() {});
    });
  }

  void _showSimpleDialog(
    BuildContext context,
    String? title,
    Function callback,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? ""),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消"),
            ),
            TextButton(
              onPressed: callback as void Function(),
              child: Text('確定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的密碼庫'),
      ),
      drawer: Drawer(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(name ?? 'user', style: TextStyle(fontSize: 20)),
              Sh(h: 20),
              Text(email ?? 'user', style: TextStyle(fontSize: 20)),
              Sh(h: 20),
              Button(
                press: () {},
                text: "匯出密碼",
              ),
              Sh(h: 10),
              Button(
                press: () {},
                text: "匯入密碼",
              ),
              Sh(h: 100),
              Button(
                  press: () {
                    _showSimpleDialog(context, "確認是否登出", () {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.clear();
                      });
                      context.go('/sign-in');
                    });
                  },
                  text: "登出"),
              Sh(h: 40),
              Button(
                  press: () {
                    _showSimpleDialog(context, "確認是否刪除帳號", () {
                      UserTable.delete(email ?? "");
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.clear();
                      });
                      context.go('/sign-in');
                    });
                  },
                  text: "刪除帳號",
                  bg: Colors.red),
            ],
          ),
        ),
      )),
      body: Center(
        child: Text('主頁面'),
      ),
    );
  }
}
