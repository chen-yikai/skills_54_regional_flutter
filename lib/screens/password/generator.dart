import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skills_54_regional_flutter/util.dart';

class PasswordGenerator extends StatefulWidget {
  final TextEditingController password;
  const PasswordGenerator({super.key, required this.password});

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  final _customSymbolController = TextEditingController();
  String password = "";
  double _sliderValue = 10;
  bool upperCase = true,
      lowerCase = true,
      number = true,
      symbol = true,
      customSymbol = true;

  getConfig() {
    SharedPreferences.getInstance().then((prefs) {
      upperCase = prefs.getBool('upperCase') ?? true;
      lowerCase = prefs.getBool('lowerCase') ?? true;
      number = prefs.getBool('number') ?? true;
      symbol = prefs.getBool('symbol') ?? true;
      customSymbol = prefs.getBool('customSymbol') ?? true;
      _customSymbolController.text = prefs.getString('customSymbolText') ?? "";
      _sliderValue = prefs.getDouble('sliderValue') ?? 10;
      setState(() {});
      genPassword();
    });
  }

  genPassword() {
    password = "";
    List<String> upperCaseLetter =
        List.generate(26, (index) => String.fromCharCode(65 + index));
    List<String> lowerCaseLetter =
        upperCaseLetter.map((value) => value.toLowerCase()).toList();
    List<int> numberLetter = List.generate(10, (index) => index);
    List<String> symbolLetter = "!@#\$%^&*".split('');
    List<String> customSymbolLetter =
        _customSymbolController.text.split('').toList();

    var allSwitch = [upperCase, lowerCase, number, symbol, customSymbol];
    var allChar = [
      upperCaseLetter,
      lowerCaseLetter,
      numberLetter,
      symbolLetter,
      customSymbolLetter
    ];
    List<List> requieredChar = [];
    allSwitch.asMap().forEach(
        (index, value) => value ? requieredChar.add(allChar[index]) : null);

    var random = Random();
    if (requieredChar.isNotEmpty) {
      for (int i = 0; i < requieredChar.length; i++) {
        if (requieredChar[i].isNotEmpty) {
          password += requieredChar[i][random.nextInt(requieredChar[i].length)]
              .toString();
        }
      }
      while (true) {
        var randomIndex = random.nextInt(requieredChar.length);
        if (requieredChar[randomIndex].isNotEmpty) {
          password += requieredChar[randomIndex]
                  [random.nextInt(requieredChar[randomIndex].length)]
              .toString();
        }
        if (password.length == _sliderValue) {
          break;
        }
      }
    }
    setState(() {});
    widget.password.text = password;
  }

  @override
  void initState() {
    super.initState();
    getConfig();
  }

  Widget switchList(String label, String subLabel, String name, bool value,
      Function(bool) callback) {
    return Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 1.5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: grayText),
            Row(
              children: [
                Text(subLabel, style: grayText),
                Switch(
                    value: value,
                    onChanged: (value) {
                      callback(value);
                      SharedPreferences.getInstance()
                          .then((prefs) => prefs.setBool(name, value));
                      setState(() {});
                      genPassword();
                    }),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("密碼產生器", style: TextStyle(color: Colors.black45)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("確定", style: TextStyle(color: Colors.teal)))
              ]),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                              children: password.split('').map((value) {
                        return TextSpan(
                            text: value,
                            style: TextStyle(
                                color: RegExp(r'^[a-zA-z]$').hasMatch(value)
                                    ? Colors.black
                                    : RegExp(r'^[0-9]$').hasMatch(value)
                                        ? Colors.blue
                                        : Colors.green,
                                fontSize: 20));
                      }).toList())),
                      Row(children: [
                        IconButton(
                            onPressed: () => Clipboard.setData(
                                ClipboardData(text: password)),
                            icon: Icon(Icons.content_copy)),
                        IconButton(
                            onPressed: genPassword, icon: Icon(Icons.refresh))
                      ])
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 1.5))),
                child: Row(
                  children: [
                    Text("密碼長度", style: grayText),
                    Expanded(
                      child: Slider(
                        value: _sliderValue,
                        min: 5,
                        max: 20,
                        divisions: 15,
                        onChanged: (value) {
                          _sliderValue = value;
                          SharedPreferences.getInstance().then(
                              (prefs) => prefs.setDouble('sliderValue', value));
                          setState(() {});
                          genPassword();
                        },
                      ),
                    ),
                    Text(_sliderValue.toInt().toString(), style: grayText)
                  ],
                ),
              ),
              switchList("大寫字母", "A-Z", "upperCase", upperCase,
                  (value) => upperCase = value),
              switchList("小寫字母", "a-z", "lowerCase", lowerCase,
                  (value) => lowerCase = value),
              switchList(
                  "數字", "0-9", "number", number, (value) => number = value),
              switchList("符號", "!@#\$%^&*", "symbol", symbol,
                  (value) => symbol = value),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customSymbolController,
                      maxLength: 20,
                      onChanged: (value) {
                        SharedPreferences.getInstance().then((prefs) =>
                            prefs.setString('customSymbolText', value));
                        genPassword();
                      },
                      decoration: InputDecoration(
                          labelText: "自訂字元", labelStyle: grayText),
                    ),
                  ),
                  Switch(
                      value: customSymbol,
                      onChanged: (value) {
                        customSymbol = value;
                        SharedPreferences.getInstance().then(
                            (prefs) => prefs.setBool('customSymbol', value));
                        setState(() {});
                        genPassword();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
