import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe/Fragments/kelaspeserta/assessmentpesertaitem.dart';
import 'package:safe/Fragments/manageassessment/manageassessmentitem.dart';
import 'package:safe/Models/IndAssessment.dart';
import 'package:safe/Models/Kelas.dart';
import 'package:safe/Models/testkelasgrouping.dart';
import 'package:safe/Utilities/ApiService.dart';
import 'package:safe/Utilities/SecureStorageHelper.dart';

class AssessmentPeserta extends StatefulWidget {
  const AssessmentPeserta({Key? key, required this.kls}) : super(key: key);

  final Kelas kls;

  @override
  State<AssessmentPeserta> createState() => _AssessmentPesertaState();
}

class _AssessmentPesertaState extends State<AssessmentPeserta> {

  ApiService apiService = Get.find(tag: 'apiserv1');
//  static String jwttoken = "";
  String nama = "";
  String nip = "";
  String role="";
  late List<TestKelasGrouping> indasmnts = <TestKelasGrouping>[];
  late Kelas kls;
  bool isLoading=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kls=widget.kls;
    SecureStorageHelper.getListString("userinfo")
        .then((value) {
      setState(() {
        if (value != null) {
          nama = value[2].toString();
          nip = value[3].toString();
          role=value[6].toString();
          getAssessmentKelas();
        } else {
          //print("username1 $value");
        }
      });
    });
    //getAssessmentKelas();
  }

  Future<void> getAssessmentKelas() async {
    setState((){
      indasmnts.clear();
      isLoading=true;
    });
    var req = await apiService.getAssessmentAktifInClass(user: nip,
    idkelas: kls.id_kelas, iddiklat: kls.id_diklat, idmatadiklat: kls.id_matadiklat);

    List<TestKelasGrouping> tasmnt=<TestKelasGrouping>[];
    if (json.decode(req.body)['data'] != null) {
      for (int i = 0; i < json.decode(req.body)['data'].length; i++) {
        tasmnt.add(TestKelasGrouping.fromJSON(json.decode(req.body)['data'][i]));
      }
    }

    setState((){
      indasmnts=tasmnt;
      isLoading=false;
    });
    // kelaspesertas.add(Kelas(
    //     namakelas: "Kelas 1 Angkatan I",
    //     namadiklat: "Diklat JFPAP",
    //   namamatadiklat: "SPI",
    //     lokasi: "Badiklat",
    //     tglmulai: "2022/02/01",
    //     tglselesai: "2022/10/31",
    //   )
    // );
    // kelaspesertas.add(Kelas(
    //   namakelas: "Kelas 2 Angkatan I",
    //   namadiklat: "Diklat JFPAP",
    //   namamatadiklat: "APB",
    //   lokasi: "Badiklat",
    //   tglmulai: "2022/02/01",
    //   tglselesai: "2022/10/31",
    // )
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal,
      appBar: AppBar(
        //elevation: 0.1,
        backgroundColor: Colors.teal,
        title: Text("Daftar Assessment Aktif"),
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
          itemCount: indasmnts.length,
          itemBuilder: (BuildContext context, int index) {
            return isLoading==false ? AssessmentPesertaItem(indasmnt: indasmnts[index]) : Center(child: CircularProgressIndicator(),);  //makeCard(mails[index]);
          },
        ),
      ),
      //bottomNavigationBar: makeBottom,
    );
  }
}
