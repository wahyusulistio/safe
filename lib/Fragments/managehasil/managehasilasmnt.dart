import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/managehasil/managehasilasmntitem.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class ManageHasilAsmnt extends StatefulWidget {
  const ManageHasilAsmnt({Key? key, required this.kls}) : super(key: key);

  final Kelas kls;
  @override
  State<ManageHasilAsmnt> createState() => _ManageHasilAsmntState();
}

class _ManageHasilAsmntState extends State<ManageHasilAsmnt> {
  ApiService apiService = Get.find(tag: 'apiserv1');
//  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role="";

  late Kelas kls;
  List<TestKelasGrouping> indasmntsadded = <TestKelasGrouping>[];


  Future<void> getAddedAssessmentKelas() async {
    var req = await apiService.getAssessmentAddedInClass(
        user: nip,
        idkelas: kls.id_kelas,
        iddiklat: kls.id_diklat,
        idmatadiklat: kls.id_matadiklat);
    print(req.body);

    List<TestKelasGrouping> tasmnt = <TestKelasGrouping>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        print("data existing "+i.toString());
        tasmnt.add(TestKelasGrouping.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    //print("jumlah "+tgrouping.length.toString());
    setState(() {
      indasmntsadded.clear();
      indasmntsadded = tasmnt;
      //_selectedAsmnts=tasmnt;
    });

    //setInitialValue();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kls=widget.kls;
    SecureStorageHelper.getListString("userinfo").then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role = value[6].toString();
          getAddedAssessmentKelas();
          // _items = indasmnts
          //     .map((_indasmnt) => MultiSelectItem<IndAssessment>(
          //         _indasmnt, _indasmnt.asmntname))
          //     .toList();
          //setInitialValue();
        } else {
          //print("username1 $value");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      appBar: AppBar(
        //elevation: 0.1,
        backgroundColor: Colors.teal,
        title: Text("Hasil Assessment"),
        /*actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],*/
      ),
      body: Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          itemCount: indasmntsadded.length,
          itemBuilder: (BuildContext context, int index) {
            return ManageHasilAsmntItem(indasmnt: indasmntsadded[index]);  //makeCard(mails[index]);
          },
        ),
      ),
      //bottomNavigationBar: makeBottom,
    );
  }
}
