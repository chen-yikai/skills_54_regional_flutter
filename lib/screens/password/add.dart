import 'package:flutter/material.dart';
import 'package:skills_54_regional_flutter/db.dart';
import 'package:skills_54_regional_flutter/screens/home.dart';
import 'package:skills_54_regional_flutter/screens/password/generator.dart';
import 'package:skills_54_regional_flutter/util.dart';

class AddPasswordScreen extends StatefulWidget {
  final bool isAdd;
  final int id;
  const AddPasswordScreen({super.key, this.isAdd = true, this.id = 0});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  PasswordSchema? editPasswordData;
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController(),
      user = TextEditingController(),
      password = TextEditingController(),
      website = TextEditingController();
  var isFav = false;
  var isVisibile = false;

  Future<void> save() async {
    if (widget.isAdd) {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      await PasswordTable.add(PasswordSchema(
          createdAt: timestamp,
          name: name.text,
          user: user.text,
          password: password.text,
          website: website.text,
          favorite: isFav ? 1 : 0));
    } else {
      int? timestamp = editPasswordData!.createdAt;
      await PasswordTable.update(PasswordSchema(
          createdAt: timestamp!,
          name: name.text,
          user: user.text,
          password: password.text,
          website: website.text,
          favorite: isFav ? 1 : 0));
    }
    if (mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  Future<void> editPassword() async {
    editPasswordData = await PasswordTable.getSingle(widget.id);
    name.text = editPasswordData!.name;
    user.text = editPasswordData!.user;
    password.text = editPasswordData!.password;
    website.text = editPasswordData!.website;
    isFav = editPasswordData!.favorite == 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isAdd) editPassword();
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
        content: Text(widget.isAdd ? '已新增項目' : '以更新項目'),
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
            title: Text(widget.isAdd ? '新增項目' : '編輯項目'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
