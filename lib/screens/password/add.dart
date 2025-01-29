import 'package:flutter/material.dart';
import 'package:skills_54_regional_flutter/db.dart';
import 'package:skills_54_regional_flutter/screens/home.dart';
import 'package:skills_54_regional_flutter/screens/password/generator.dart';
import 'package:skills_54_regional_flutter/util.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController(),
      user = TextEditingController(),
      password = TextEditingController(),
      website = TextEditingController();
  var isFav = false;
  var isVisibile = false;

  Future<void> save() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await PasswordTable.add(PasswordSchema(
        createdAt: timestamp,
        name: name.text,
        user: user.text,
        password: password.text,
        website: website.text,
        favorite: isFav ? 1 : 0));
    if (mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void bottomSheet() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return PasswordGenerator(password: password);
        });
  }

  Future<void> goHome() async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('已新增項目'),
      ));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            title: Text('新增項目'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      save();
                    }
                  },
                  child: Text(
                    '儲存',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請填寫完整';
                      }
                      return null;
                    },
                    controller: name,
                    decoration: InputDecoration(
                      hintText: '項目名稱',
                    ),
                  ),
                  Sh(h: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請填寫完整';
                      }
                      return null;
                    },
                    controller: user,
                    decoration: InputDecoration(
                      hintText: '使用者名稱',
                    ),
                  ),
                  Sh(h: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請填寫完整';
                      }
                      return null;
                    },
                    controller: password,
                    obscureText: !isVisibile,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                        hintText: '密碼',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  isVisibile = !isVisibile;
                                  setState(() {});
                                },
                                icon: Icon(isVisibile
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            IconButton(
                                onPressed: bottomSheet,
                                icon: Icon(Icons.auto_fix_high)),
                          ],
                        )),
                  ),
                  Sh(h: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請填寫完整';
                      }
                      return null;
                    },
                    controller: website,
                    decoration: InputDecoration(
                      hintText: '網址',
                    ),
                  ),
                  Sh(h: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "我的最愛",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Switch(
                          value: isFav,
                          onChanged: (_) {
                            isFav = !isFav;
                            setState(() {});
                          })
                    ],
                  ),
                  Sh(h: 10),
                  Container(
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide())),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
