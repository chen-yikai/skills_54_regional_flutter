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
  final searchInput = TextEditingController();
  String? name = '';
  String? email = '';
  final List<String> items =
      List<String>.generate(20, (index) => "Item $index");

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go("/add");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('我的密碼庫'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
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
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(items[index]),
                              subtitle: Text('Subtitle $index'),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tapped on ${items[index]}'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
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
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(items[index]),
                              subtitle: Text('Subtitle $index'),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tapped on ${items[index]}'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
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
