import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialogConfirm extends StatefulWidget {
  MyDialogConfirm({
    Key? key,
    required this.info
  }) : super(key: key);

  final String info;

  @override
  _MyDialogConfirmState createState() => new _MyDialogConfirmState();
}

class _MyDialogConfirmState extends State<MyDialogConfirm> {

  late String info;

  @override
  void initState() {
    super.initState();

    info = widget.info;

  }
  _getContent() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(info, textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Ya"),
                onPressed: () {
                  String text = jsonEncode({
                    'respon': "ya",
                  });
                  Get.back(result: text);
                },
              ),
              SizedBox(width: 10,),
              ElevatedButton(
                child: Text("Tidak"),
                onPressed: () {
                  String text = jsonEncode({
                    'respon': "tidak",
                  });
                  Get.back(result: text);
                },
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}