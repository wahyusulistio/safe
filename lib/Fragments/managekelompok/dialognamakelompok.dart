import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Models/Grouping.dart';
import 'package:safe/Utilities/ApiService.dart';

class MyDialogNamaKelompok extends StatefulWidget {
  MyDialogNamaKelompok(
      {Key? key, required this.currname, required this.user, required this.grouping})
      : super(key: key);

  final String user;
  final String currname;
  final Grouping grouping;

  @override
  _MyDialogNamaKelompokState createState() => new _MyDialogNamaKelompokState();
}

class _MyDialogNamaKelompokState extends State<MyDialogNamaKelompok> {
  ApiService apiService = Get.find(tag: 'apiserv1');

  String currname = "";
  String user = "";
  late Grouping grouping;
  TextEditingController tec = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = widget.user;
    grouping = widget.grouping;

    if (widget.currname != "" && widget.currname != null) {
      currname = widget.currname;
      print("masuk set currname");
    }
  }

  _getContent() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: AutoSizeText("Nama Kelompok:")),
              Expanded(
                  flex: 1,
                  child: TextFormField(
                    //initialValue: (currname!="" && currname!=null) ? currname : "",
                    textAlign: TextAlign.left,
                    controller: tec,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 1, color: Colors.teal),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 1, color: Colors.teal),
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onChanged: (String? val){
                      currname=val.toString();
                    },
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Kembali"),
                onPressed: () {
                  Get.back();
                },
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                child: Text("Simpan"),
                onPressed: () async {
                  print("masuk tambah kelompok");
                  // String text = jsonEncode({
                  //   'respon': tec.value,
                  // });
                  await apiService.addGrupInGrouping(
                      user: user,
                      idgrouping: grouping.groupingid,
                   namagrup: tec.text);
                  Get.back();
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
