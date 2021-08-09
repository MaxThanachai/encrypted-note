import 'package:encrypted_note/const/color.dart';
import 'package:flutter/material.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController noteController = TextEditingController();
  TextEditingController keyController = TextEditingController();

  bool isEncrypted = false;

  final key = encrypt.Key.fromUtf8('4869502448695024');
  final iv = encrypt.IV.fromLength(8);
  dynamic encrypter;

  Color border = lightBlue;
  Color textFieldColor = white;
  Color background = whisperGray;

  void filterTextInQuote() {
    List<String> splittedStr = noteController.text.split('"');
    for (int i = 0; i < splittedStr.length; i++) {
      if (i % 2 != 0) print(splittedStr[i]);
    }
  }

  String encrypting(String plainText) {
    print(plainText);
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decrypting(String encryptedText) {
    print(encryptedText);
    encrypt.Encrypted encrypted = encrypt.Encrypted.from64(encryptedText);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  void switchColorTheme() {
    border = isEncrypted ? lightBlue : Colors.red;
    textFieldColor = isEncrypted ? white : Colors.red[100] as Color;
    background = isEncrypted ? whisperGray : Colors.red[300] as Color;
  }

  void toggleEncrypting() {
    List<String> splittedStr = noteController.text.split('"');
    String result = '';

    if (!isEncrypted) {
      for (int i = 0; i < splittedStr.length; i++) {
        if (i % 2 != 0) {
          splittedStr[i] = '"' + encrypting(splittedStr[i]) + '"';
        }
        result += splittedStr[i];
      }
    } else {
      for (int i = 0; i < splittedStr.length; i++) {
        if (i % 2 != 0) {
          splittedStr[i] = '"' + decrypting(splittedStr[i]) + '"';
        }
        result += splittedStr[i];
      }
    }

    setState(() {
      switchColorTheme();
      isEncrypted = !isEncrypted;
      noteController.text = result;
    });
  }

  @override
  void initState() {
    encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    super.initState();
  }

  Widget keyBar() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: border,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.vpn_key,
            color: textFieldColor,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              decoration: BoxDecoration(
                color: textFieldColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: keyController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notePad() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: textFieldColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextFormField(
          enabled: !isEncrypted,
          controller: noteController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: border,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          keyBar(),
          notePad(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleEncrypting,
        tooltip: isEncrypted ? 'decrypt' : 'encrypt',
        backgroundColor: border,
        child: isEncrypted ? Icon(Icons.vpn_key) : Icon(Icons.lock),
      ),
    );
  }
}
