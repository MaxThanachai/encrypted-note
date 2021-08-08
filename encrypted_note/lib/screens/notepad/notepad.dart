import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController noteController = TextEditingController();
  TextEditingController keyController = TextEditingController();

  void filterTextInQuote() {
    List<String> splittedStr = noteController.text.split('"');
    for (int i = 0; i < splittedStr.length; i++) {
      if (i % 2 != 0) print(splittedStr[i]);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget keyBar() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.vpn_key,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              decoration: BoxDecoration(
                color: Colors.blueGrey[300],
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
          color: Colors.blueGrey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextFormField(
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
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          keyBar(),
          notePad(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: filterTextInQuote,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
