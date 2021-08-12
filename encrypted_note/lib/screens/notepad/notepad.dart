import 'package:flutter/material.dart';
import 'package:encrypted_note/const/color.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = new FlutterSecureStorage();

  TextEditingController noteController = TextEditingController();
  TextEditingController keyController = TextEditingController();

  bool isEncrypted = true;

  final iv = encrypt.IV.fromLength(8);

  Color textColor = blueWhite;
  Color borderColor = blueNeon;
  Color fillColor = blueDark;
  Color backgroundColor = blueBlack;

  Future<void> loadNote() async {
    String? note = await storage.read(key: 'untitledEncryptedNote');
    if (note == null) return;
    print('cannot read note');
    setState(() {
      noteController.text = note;
    });
  }

  Future<void> saveNote(String note) async {
    print('Saving . . .');
    return storage.write(key: 'untitledEncryptedNote', value: note);
  }

  String encrypting(String plainText) {
    encrypt.Key key = encrypt.Key.fromUtf8(keyController.text);
    encrypt.Encrypter encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decrypting(String encryptedText) {
    encrypt.Key key = encrypt.Key.fromUtf8(keyController.text);
    encrypt.Encrypter encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    encrypt.Encrypted encrypted = encrypt.Encrypted.from64(encryptedText);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  // void switchColorTheme() {
  //   setState(() {
  //     textColor = isEncrypted ? blueWhite : redWhite;
  //     borderColor = isEncrypted ? blueNeon : redNeon;
  //     fillColor = isEncrypted ? blueDark : redDark;
  //     backgroundColor = isEncrypted ? blueBlack : redBlack;
  //   });
  // }

  void switchColorTheme() {
    setState(() {
      textColor = isEncrypted ? blueWhite : redWhite;
      borderColor = isEncrypted ? blueNeon : redNeon;
      fillColor = isEncrypted ? blueDark : redDark;
      backgroundColor = isEncrypted ? blueBlack : redBlack;
    });
  }

  void toggleEncrypting() async {
    List<String> splittedStr = noteController.text.split('"');
    String result = '';

    if (!isEncrypted) {
      print('encrypting . . .');
      for (int i = 0; i < splittedStr.length; i++) {
        if (i % 2 != 0) {
          splittedStr[i] = '"' + encrypting(splittedStr[i]) + '"';
        }
        result += splittedStr[i];
      }
      await saveNote(result);
    } else {
      print('decrypting . . .');
      for (int i = 0; i < splittedStr.length; i++) {
        if (i % 2 != 0) {
          splittedStr[i] = '"' + decrypting(splittedStr[i]) + '"';
        }
        result += splittedStr[i];
      }
    }

    setState(() {
      isEncrypted = !isEncrypted;
      switchColorTheme();
      noteController.text = result;
    });
  }

  @override
  void initState() {
    loadNote();
    switchColorTheme();
    super.initState();
  }

  Widget appBar() {
    return Container(
      height: 96,
      width: 369,
      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Untitled encrypted note',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget keyBar() {
    return Container(
      height: 108,
      width: 369,
      margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Center(
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            color: fillColor,
            border: Border.all(
              width: 2,
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.vpn_key,
                color: borderColor,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: keyController,
                  obscureText: true,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget notePad() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          border: Border.all(
            width: 2,
            color: borderColor,
          ),
        ),
        child: TextFormField(
          enabled: !isEncrypted,
          controller: noteController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          appBar(),
          keyBar(),
          notePad(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleEncrypting,
        tooltip: isEncrypted ? 'decrypt' : 'encrypt',
        backgroundColor: fillColor,
        shape: new CircleBorder(
          side: BorderSide(width: 2, color: textColor),
        ),
        child: isEncrypted ? Icon(Icons.lock_outline) : Icon(Icons.lock_open),
      ),
    );
  }
}
