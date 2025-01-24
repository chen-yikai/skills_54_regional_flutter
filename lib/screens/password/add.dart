import 'package:flutter/material.dart';
import 'package:skills_54_regional_flutter/util.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final name = TextEditingController(),
      user = TextEditingController(),
      password = TextEditingController(),
      website = TextEditingController();
  var isFav = false;
  var isVisibile = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新增項目'),
          actions: [
            TextButton(onPressed: () {}, child: Text('儲存')),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: '項目名稱',
                ),
              ),
              Sh(h: 20),
              TextField(
                controller: user,
                decoration: InputDecoration(
                  hintText: '使用者名稱',
                ),
              ),
              Sh(h: 20),
              TextField(
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
                            onPressed: () {}, icon: Icon(Icons.auto_fix_high)),
                      ],
                    )),
              ),
              Sh(h: 20),
              TextField(
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
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              )
            ],
          ),
        ));
  }
}
