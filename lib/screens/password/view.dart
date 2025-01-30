import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skills_54_regional_flutter/screens/home.dart';
import 'package:skills_54_regional_flutter/screens/password/add.dart';
import 'package:skills_54_regional_flutter/util.dart';
import 'package:skills_54_regional_flutter/db.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ViewScreen extends StatefulWidget {
  final int? id;
  const ViewScreen({super.key, required this.id});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  PasswordSchema passwords = PasswordSchema(
      createdAt: 0, name: "", user: "", password: "", website: "", favorite: 0);
  bool isShowPassword = false;
  String passwordText = "";
  bool isFavorite = false;
  contentShow(String hint, String value, List<Widget>? right) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hint, style: TextStyle(color: Colors.black54, fontSize: 11)),
              hint == "密碼" && isShowPassword
                  ? RichText(
                      text: TextSpan(
                          children: passwordText
                              .split('')
                              .map((value) => TextSpan(
                                  text: value,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: RegExp(r'^[a-zA-Z]$')
                                              .hasMatch(value)
                                          ? Colors.black
                                          : RegExp(r'^[0-9]$').hasMatch(value)
                                              ? Colors.blue
                                              : Colors.green)))
                              .toList()))
                  : Text(value,
                      style: TextStyle(fontSize: 20, color: Colors.black12))
            ],
          ),
          Row(
            children: right ?? [Container()],
          )
        ],
      ),
    );
  }

  Future<void> deleteData() async {
    await PasswordTable.delete(passwords.createdAt!);
    if (mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  getData() async {
    passwords = await PasswordTable.getSingle(widget.id!);
    isFavorite = passwords.favorite == 1 ? true : false;
    passwordText = "*" * 8;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          title: Text("檢視項目"),
          actions: [
            TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            AddPasswordScreen(isAdd: false, id: widget.id!))),
                child: Text("編輯", style: TextStyle(color: Colors.white)))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    contentShow("項目名稱", passwords.name, [
                      IconButton(
                          onPressed: () {
                            isFavorite = !isFavorite;
                            PasswordTable.updateFavorite(
                                passwords.createdAt!, isFavorite);
                            setState(() {});
                          },
                          icon:
                              Icon(isFavorite ? Icons.star : Icons.star_border))
                    ]),
                    contentShow("使用者名稱", passwords.name, [
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.content_copy))
                    ]),
                    contentShow("密碼", passwordText, [
                      IconButton(
                          onPressed: () {
                            isShowPassword = !isShowPassword;
                            passwordText =
                                isShowPassword ? passwords.password : '*' * 8;
                            setState(() {});
                          },
                          icon: Icon(isShowPassword
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: passwords.password));
                          },
                          icon: Icon(Icons.content_copy))
                    ]),
                    GestureDetector(
                      onTap: () async {
                        if (await canLaunchUrlString(passwords.website)) {
                          await launchUrlString(passwords.website);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("無法開啟網址"),
                          ));
                        }
                      },
                      child: contentShow("網址", passwords.website, []),
                    ),
                    Sh(h: 20),
                    Text(
                        "建立時間: ${DateTime.fromMillisecondsSinceEpoch(passwords.createdAt!).toString().split(".")[0]}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("確定要刪除此密碼項目嗎？"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("取消")),
                                    TextButton(
                                        onPressed: deleteData,
                                        child: Text("確定"))
                                  ],
                                )),
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.red),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        child: Text("刪除")),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
