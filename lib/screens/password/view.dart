import 'package:flutter/material.dart';
import 'package:skills_54_regional_flutter/util.dart';
import 'package:skills_54_regional_flutter/db.dart';

class ViewScreen extends StatefulWidget {
  final int? id;
  const ViewScreen({super.key, required this.id});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  PasswordSchema passwords = PasswordSchema(
      createdAt: 0, name: "", user: "", password: "", website: "", favorite: 0);
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
              Text(value, style: TextStyle(fontSize: 20, color: Colors.black12))
            ],
          ),
          Row(
            children: right ?? [Container()],
          )
        ],
      ),
    );
  }

  getData() async {
    passwords = await PasswordTable.getSingle(widget.id!);
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
                onPressed: () {},
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
                    contentShow("項目名稱", passwords.name,
                        [IconButton(onPressed: () {}, icon: Icon(Icons.star))]),
                    contentShow("使用者名稱", passwords.name, [
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.content_copy))
                    ]),
                    contentShow("密碼", passwords.password, [
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.visibility)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.content_copy))
                    ]),
                    contentShow("網址", passwords.website, []),
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
                        onPressed: () {},
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
