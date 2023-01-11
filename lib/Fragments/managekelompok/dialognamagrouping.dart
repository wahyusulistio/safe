import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Utilities/ApiService.dart';

class MyDialogNamaGrouping extends StatefulWidget {
  MyDialogNamaGrouping(
      {Key? key, required this.currname, required this.user, required this.kls})
      : super(key: key);

  final String user;
  final String currname;
  final Kelas kls;

  @override
  _MyDialogNamaGroupingState createState() => new _MyDialogNamaGroupingState();
}

class _MyDialogNamaGroupingState extends State<MyDialogNamaGrouping> {
  ApiService apiService = Get.find(tag: 'apiserv1');

  String currname = "";
  String user = "";
  late Kelas kls;
  TextEditingController tec = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = widget.user;
    kls = widget.kls;

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
              Expanded(flex: 1, child: AutoSizeText("Nama Grouping:")),
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
                  print("masuk tambah grouping");
                  // String text = jsonEncode({
                  //   'respon': tec.value,
                  // });
                  await apiService.addGroupingKelas(
                      user: user,
                      idkelas: kls.id_kelas,
                      namagrouping: tec.text,
                      idmatadiklat: kls.id_matadiklat,
                  iddiklat: kls.id_diklat);
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
