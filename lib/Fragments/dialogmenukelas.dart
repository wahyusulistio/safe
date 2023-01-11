

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialogMenuKelas extends StatefulWidget {
  MyDialogMenuKelas({
    Key? key,
  }) : super(key: key);


  @override
  _MyDialogMenuKelasState createState() => new _MyDialogMenuKelasState();
}

class _MyDialogMenuKelasState extends State<MyDialogMenuKelas> {

  @override
  void initState() {
    super.initState();

  }
  _getContent() {
    return Column(
      children: [
        Container(
          child: Text("Manage Kelompok"),
        ),
        SizedBox(height: 10),
        Container(
          child: Text("Manage Assessment"),
        ),
        SizedBox(height: 10),
        Container(
          child: Text("Hasil Assessment"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}