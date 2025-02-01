import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_54_regional_flutter/db.dart';
import 'package:skills_54_regional_flutter/screens/password/add.dart';
import 'package:skills_54_regional_flutter/screens/password/view.dart';
import 'package:skills_54_regional_flutter/screens/sign_in.dart';
import 'package:skills_54_regional_flutter/util.dart';

enum SortBy { custom, createdAt, name }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  final searchInput = TextEditingController();
  final List<String> customOrderList = [];
  String? name = '';
  String? email = '';
  List<PasswordSchema> passwords = [];
  SortBy sortingMethod = SortBy.createdAt;
  bool isAsc = true;
  final exportFileName = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPrefs();
    getPassword();
    initSort();
  }

  Future<void> getPassword() async {
    passwords = await PasswordTable.get(searchInput.text, sortingMethod, isAsc);
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

  Future<void> exportJsonData() async {
    Navigator.pop(context);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${exportFileName.text}.json';

    final jsonList = passwords.map((password) => password.toMap()).toList();
    final jsonString = jsonEncode(jsonList);

    final file = File(filePath);
    await file.writeAsString(jsonString);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('匯出成功'),
        ),
      );
    }
  }

  Future<List> getJsonFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory
        .listSync()
        .where((element) => element.path.endsWith('.json'))
        .toList();
    final fileNames = files.map((e) => e.path.split('/').last).toList();
    return fileNames;
  }

  Future<void> importJsonData(String filename) async {
    Navigator.pop(context);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';

    final file = File(filePath);
    final jsonString = await file.readAsString();

    final jsonData = jsonDecode(jsonString) as List;
    for (final item in jsonData) {
      await PasswordTable.add(PasswordSchema(
          createdAt: item["createdAt"],
          name: item["name"],
          user: item["user"],
          password: item["password"],
          website: item["website"],
          favorite: item["favorite"]));
    }
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
                press: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      exportFileName.clear();
                      return AlertDialog(
                        title: Text('匯出檔名'),
                        content: Row(
                          children: [
                            Expanded(
                                child: TextField(controller: exportFileName)),
                            Text(
                              '.json',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('取消'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (exportFileName.text.isNotEmpty) {
                                await exportJsonData();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('請輸入檔名'),
                                  ),
                                );
                              }
                            },
                            child: Text('確定'),
                          ),
                        ],
                      );
                    },
                  );
                },
                text: "匯出密碼",
              ),
              Sh(h: 10),
              Button(
                press: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('匯入檔案'),
                        content: FutureBuilder(
                          future: getJsonFile(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final fileNames = snapshot.data as List;
                              return Column(
                                children: fileNames
                                    .map((fileName) => ListTile(
                                          title: Text(fileName),
                                          onTap: () async {
                                            await importJsonData(fileName);
                                          },
                                        ))
                                    .toList(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      );
                    },
                  );
                },
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

  initSort() {
    SharedPreferences.getInstance().then((prefs) {
      sortingMethod = SortBy.values.firstWhere(
          (element) => element.toString() == prefs.getString('sortingMethod'),
          orElse: () => SortBy.createdAt);
      isAsc = prefs.getBool('isAsc') ?? true;
      updateSort(sortingMethod);
      setState(() {});
    });
  }

  Future<void> updateCustomSort() async {
    customOrderList.clear();
    passwords.forEach((item) {
      customOrderList.add(item.createdAt.toString());
    });
    await UserTable.setCustomOrder(customOrderList);
  }

  Future<void> updateSort(SortBy method) async {
    setState(() {
      sortingMethod = method;
      if (method != SortBy.custom) isAsc = !isAsc;
    });
    List<String> customCheck = await UserTable.getCustomOrder();
    if (sortingMethod == SortBy.custom && customCheck.isEmpty) {
      passwords =
          await PasswordTable.get(searchInput.text, SortBy.createdAt, true);
      setState(() {});
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('sortingMethod', method.toString());
      if (method != SortBy.custom) prefs.setBool('isAsc', isAsc);
    });

    getPassword();
  }

  @override
  Widget build(BuildContext context) {
    // getPassword();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddPasswordScreen()))
              .then((_) => getPassword());
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
                      onTap: () {
                        updateSort(SortBy.custom);
                      },
                      child: InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.check,
                                color: sortingMethod == SortBy.custom
                                    ? Colors.black
                                    : Colors.transparent),
                            Sw(w: 5),
                            Text('自訂排序'),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        updateSort(SortBy.name);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check,
                                  color: sortingMethod == SortBy.name
                                      ? Colors.black
                                      : Colors.transparent),
                              Sw(w: 5),
                              Text('依名稱排序'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                  isAsc
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: sortingMethod == SortBy.name
                                      ? Colors.black
                                      : Colors.transparent)
                            ],
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        updateSort(SortBy.createdAt);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check,
                                  color: sortingMethod == SortBy.createdAt
                                      ? Colors.black
                                      : Colors.transparent),
                              Sw(w: 5),
                              Text('依建立時間排序'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                  isAsc
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: sortingMethod == SortBy.createdAt
                                      ? Colors.black
                                      : Colors.transparent)
                            ],
                          )
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
                  child: ReorderableListView(
                    buildDefaultDragHandles: sortingMethod == SortBy.custom,
                    children: passwords.map((item) {
                      if (item.favorite == 1) {
                        return ListTile(
                          key: Key(item.createdAt.toString()),
                          title: Text(item.name),
                          subtitle: Text(item.user),
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewScreen(id: item.createdAt)))
                                .then((value) => getPassword());
                          },
                        );
                      } else {
                        return Container(
                          key: Key(item.createdAt.toString()),
                        );
                      }
                    }).toList(),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        final item = passwords.removeAt(oldIndex);
                        if (newIndex > oldIndex) newIndex--;
                        passwords.insert(newIndex, item);
                      });
                      updateCustomSort();
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
                  child: ReorderableListView(
                    buildDefaultDragHandles: sortingMethod == SortBy.custom,
                    children: passwords.map((item) {
                      if (item.favorite == 0) {
                        return ListTile(
                          key: Key(item.createdAt.toString()),
                          title: Text(item.name),
                          subtitle: Text(item.user),
                          onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewScreen(id: item.createdAt)))
                              .then((value) => getPassword()),
                        );
                      } else {
                        return Container(
                          key: Key(item.createdAt.toString()),
                        );
                      }
                    }).toList(),
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        final item = passwords.removeAt(oldIndex);
                        if (newIndex > oldIndex) newIndex--;
                        passwords.insert(newIndex, item);
                      });
                      updateCustomSort();
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
