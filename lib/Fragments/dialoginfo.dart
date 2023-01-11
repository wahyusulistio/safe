import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialogInfo extends StatefulWidget {
  MyDialogInfo({
    Key? key,
    required this.info
  }) : super(key: key);

  final String info;

  @override
  _MyDialogInfoState createState() => new _MyDialogInfoState();
}

class _MyDialogInfoState extends State<MyDialogInfo> {

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
          ElevatedButton(
            child: Text("Tutup"),
            onPressed: () {
              Get.back();
            },
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