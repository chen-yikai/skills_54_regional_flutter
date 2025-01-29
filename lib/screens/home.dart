import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_54_regional_flutter/db.dart';
import 'package:skills_54_regional_flutter/screens/password/add.dart';
import 'package:skills_54_regional_flutter/screens/password/view.dart';
import 'package:skills_54_regional_flutter/screens/sign_in.dart';
import 'package:skills_54_regional_flutter/util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchInput = TextEditingController();
  String? name = '';
  String? email = '';
  List<PasswordSchema> passwords = [];

  @override
  void initState() {
    super.initState();
    getPrefs();
    getPassword();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getPassword();
  }

  Future<void> getPassword() async {
    passwords = await PasswordTable.get(searchInput.text, "createdAt", true);
    setState(() {});
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

  drawer() {
    return Drawer(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    });
                  },
                  text: "刪除帳號",
                  bg: Colors.red),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPasswordScreen()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Text('我的密碼庫'),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.check),
                          Text('自訂排序'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.check),
                          Text('依名稱排序'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.check),
                          Text('依建立時間排序'),
                        ],
                      ),
                    ),
                  ])
        ],
      ),
      drawer: drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchInput.text = value;
                    getPassword();
                  });
                },
                controller: searchInput,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '搜尋',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: searchInput.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchInput.clear();
                            setState(() {});
                            getPassword();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('我的最愛'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: passwords.map((item) {
                      if (item.favorite == 1) {
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.user),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewScreen(id: item.createdAt))),
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('其他項目'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: passwords.map((item) {
                      if (item.favorite == 0) {
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.user),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewScreen(id: item.createdAt))),
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
